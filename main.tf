terraform {
  required_version = "~> 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "ctx" {}

locals {
  name       = var.fifo_topic && !endswith(var.name, ".fifo") && var.name != null ? join(".", [var.name, "fifo"]) : var.name
  fifo_topic = var.fifo_topic || endswith(var.name, ".fifo")
}

resource "aws_sns_topic" "topic" {
  content_based_deduplication = var.content_based_deduplication
  display_name                = var.display_name
  fifo_topic                  = local.fifo_topic
  name                        = local.name
  name_prefix                 = var.name_prefix
  tags                        = var.tags

  delivery_policy   = var.delivery_policy
  kms_master_key_id = var.kms_master_key_id
  tracing_config    = var.tracing_config

  application_failure_feedback_role_arn    = local.application_failure_feedback_role_arn
  application_success_feedback_role_arn    = local.application_success_feedback_role_arn
  application_success_feedback_sample_rate = local.application_success_feedback_sample_rate

  firehose_failure_feedback_role_arn    = local.firehose_failure_feedback_role_arn
  firehose_success_feedback_role_arn    = local.firehose_success_feedback_role_arn
  firehose_success_feedback_sample_rate = local.firehose_success_feedback_sample_rate

  http_failure_feedback_role_arn    = local.http_failure_feedback_role_arn
  http_success_feedback_role_arn    = local.http_success_feedback_role_arn
  http_success_feedback_sample_rate = local.http_success_feedback_sample_rate

  lambda_failure_feedback_role_arn    = local.lambda_failure_feedback_role_arn
  lambda_success_feedback_role_arn    = local.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate = local.lambda_success_feedback_sample_rate

  sqs_failure_feedback_role_arn    = local.sqs_failure_feedback_role_arn
  sqs_success_feedback_role_arn    = local.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate = local.sqs_success_feedback_sample_rate

  lifecycle {
    precondition {
      condition = sum([
        var.name != null ? 1 : 0,
        var.name_prefix != null ? 1 : 0
      ]) == 1
      error_message = "Only one of \"name\" or \"name_prefix\" may be set."
    }

    precondition {
      condition     = !local.fifo_topic || local.fifo_topic && !var.content_based_deduplication
      error_message = "New error"
    }
  }
}

locals {
  topic_policy_statements = concat(
    [{
      actions = [
        "sns:AddPermission",
        "sns:DeleteTopic",
        "sns:GetTopicAttributes",
        "sns:ListSubscriptionsByTopic",
        "sns:Publish",
        "sns:RemovePermission",
        "sns:SetTopicAttributes",
        "sns:Subscribe",
      ]
      not_actions = null
      conditions = [{
        test     = "StringEquals"
        values   = [data.aws_caller_identity.ctx.account_id]
        variable = "AWS:SourceOwner"
      }]
      effect = "Allow"
      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]
      not_principals = []
      resources      = [aws_sns_topic.topic.arn]
      not_resources  = null
      sid            = "__default_statement_ID"
    }],
    [
      for i in var.policy_statements : merge(
        i,
        { resources = [aws_sns_topic.topic.arn] },
      ) if i.resources == [] && i.type == "topic"
    ],
    [for i in var.policy_statements : i if i.resources != [] && i.type == "topic"]
  )

  data_protection_policy_statements = concat(
    [for i in var.policy_statements : i if i.resources != [] && i.type == "data"]
  )

  policies = {
    for i in ["topic", "data"] : i => {
      policy_id                 = i == "topic" ? var.policy_id : null
      override_policy_documents = i == "topic" ? var.policy_override_documents : null
      source_policy_documents   = i == "topic" ? var.policy_source_documents : null
      statements                = i == "topic" ? local.topic_policy_statements : local.data_protection_policy_statements
      } if anytrue([
        i == "topic",
        alltrue([
          i == "data",
          length(local.data_protection_policy_statements) > 0,
        ])
    ])
  }
}

data "aws_iam_policy_document" "sns" {
  for_each  = local.policies
  policy_id = each.value.policy_id

  override_policy_documents = each.value.override_policy_documents
  source_policy_documents   = each.value.source_policy_documents
  dynamic "statement" {
    for_each = each.value.statements
    content {
      actions       = statement.value.actions
      effect        = statement.value.effect
      not_actions   = statement.value.not_actions
      not_resources = statement.value.not_resources
      resources     = statement.value.resources
      sid           = statement.value.sid

      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }

      dynamic "not_principals" {
        for_each = statement.value.not_principals
        content {
          identifiers = not_principals.value.identifiers
          type        = not_principals.value.type
        }
      }

      dynamic "principals" {
        for_each = statement.value.principals
        content {
          identifiers = principals.value.identifiers
          type        = principals.value.type
        }
      }
    }

  }
}

resource "aws_sns_topic_policy" "sns" {
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns["topic"].json
}

resource "aws_sns_topic_data_protection_policy" "sns" {
  count = contains(keys(data.aws_iam_policy_document.sns), "data") ? 1 : 0

  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns["data"].json
}


resource "aws_sns_topic_subscription" "sns" {
  for_each = var.subscriptions

  endpoint              = each.value.endpoint
  protocol              = each.value.protocol
  subscription_role_arn = each.value.subscription_role_arn
  topic_arn             = aws_sns_topic.topic.arn

  confirmation_timeout_in_minutes = each.value.confirmation_timeout_in_minutes
  delivery_policy                 = each.value.delivery_policy
  endpoint_auto_confirms          = each.value.endpoint_auto_confirms
  filter_policy                   = each.value.filter_policy
  filter_policy_scope             = each.value.filter_policy_scope
  raw_message_delivery            = each.value.raw_message_delivery
  redrive_policy                  = each.value.redrive_policy
  replay_policy                   = each.value.replay_policy
}
