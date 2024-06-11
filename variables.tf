variable "content_based_deduplication" {
  default     = false
  description = "Set to true to enable content-based deduplication for FIFO topics."
  type        = bool
}

variable "delivery_policy" {
  default     = null
  description = "The delivery policy for the SNS topic."
  type        = string

  validation {
    condition     = var.delivery_policy == null || can(jsondecode(var.delivery_policy))
    error_message = "The value of 'delivery_policy' must contain valid JSON."
  }
}

variable "display_name" {
  default     = null
  description = "The display name for the SNS topic."
  type        = string

  validation {
    condition     = var.display_name == null || can(length(var.display_name) <= 100)
    error_message = "The display name of an SNS topic may be null or up to 100 characters in length."
  }

  validation {
    condition     = var.display_name == null || can(regex("^[[:word:]- \t]*$", var.display_name))
    error_message = "The display name of an SNS topic may only contain alphanumeric characters, hyphens, underscores, spaces, and tabs."
  }
}

variable "kms_master_key_id" {
  default     = null
  description = "The ID of the AWS-managed customer master key for use with SNS."
  type        = string
}

variable "tracing_config" {
  default     = null
  description = "Tracing mode for the SNS topic.  Valid values are 'Active' or 'PassThrough'."
  type        = string

  validation {
    condition     = var.tracing_config == null || can(contains(["Active", "PassThrough"], var.tracing_config))
    error_message = "Valid values must be either \"Active\" or \"PassThrough\"."
  }
}

# Translated into locals application values below
variable "application_feedback" {
  default     = {}
  description = "The ARNs of IAM Roles for application feedback failures and successes, as well as the percentage sample rate for successes."
  type = object({
    failure_role_arn    = optional(string, null)
    success_role_arn    = optional(string, null)
    success_sample_rate = optional(number, null)
  })

  validation {
    condition     = var.application_feedback.failure_role_arn == null || can(provider::aws::arn_parse(var.application_feedback.failure_role_arn).service == "iam")
    error_message = "The value of the 'failure_role_arn' attribute for \"application_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.application_feedback.success_role_arn == null || can(provider::aws::arn_parse(var.application_feedback.success_role_arn).service == "iam")
    error_message = "The value of the 'success_role_arn' attribute for \"application_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.application_feedback.success_sample_rate == null || can(var.application_feedback.success_sample_rate >= 0 && var.application_feedback.success_sample_rate <= 100)
    error_message = "The value of the 'success_sample_rate' attribute for \"application_feedback\" must be an integer between 0 and 100."
  }
}

locals {
  application_failure_feedback_role_arn    = var.application_feedback.failure_role_arn
  application_success_feedback_role_arn    = var.application_feedback.success_role_arn
  application_success_feedback_sample_rate = var.application_feedback.success_sample_rate
}

# Translated into locals firehose values below
variable "firehose_feedback" {
  default     = {}
  description = "The ARNs of IAM Roles for firehose feedback failures and successes, as well as the percentage sample rate for successes."
  type = object({
    failure_role_arn    = optional(string, null)
    success_role_arn    = optional(string, null)
    success_sample_rate = optional(number, null)
  })

  validation {
    condition     = var.firehose_feedback.failure_role_arn == null || can(provider::aws::arn_parse(var.firehose_feedback.failure_role_arn).service == "iam")
    error_message = "The value of the 'failure_role_arn' attribute for \"firehose_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.firehose_feedback.success_role_arn == null || can(provider::aws::arn_parse(var.firehose_feedback.success_role_arn).service == "iam")
    error_message = "The value of the 'success_role_arn' attribute for \"firehose_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.firehose_feedback.success_sample_rate == null || can(var.firehose_feedback.success_sample_rate >= 0 && var.firehose_feedback.success_sample_rate <= 100)
    error_message = "The value of the 'success_sample_rate' attribute for \"firehose_feedback\" must be an integer between 0 and 100."
  }
}

locals {
  firehose_failure_feedback_role_arn    = var.firehose_feedback.failure_role_arn
  firehose_success_feedback_role_arn    = var.firehose_feedback.success_role_arn
  firehose_success_feedback_sample_rate = var.firehose_feedback.success_sample_rate
}

# Translated into locals http values below
variable "http_feedback" {
  default     = {}
  description = "The ARNs of IAM Roles for http feedback failures and successes, as well as the percentage sample rate for successes."
  type = object({
    failure_role_arn    = optional(string, null)
    success_role_arn    = optional(string, null)
    success_sample_rate = optional(number, null)
  })

  validation {
    condition     = var.http_feedback.failure_role_arn == null || can(provider::aws::arn_parse(var.http_feedback.failure_role_arn).service == "iam")
    error_message = "The value of the 'failure_role_arn' attribute for \"http_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.http_feedback.success_role_arn == null || can(provider::aws::arn_parse(var.http_feedback.success_role_arn).service == "iam")
    error_message = "The value of the 'success_role_arn' attribute for \"http_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.http_feedback.success_sample_rate == null || can(var.http_feedback.success_sample_rate >= 0 && var.http_feedback.success_sample_rate <= 100)
    error_message = "The value of the 'success_sample_rate' attribute for \"http_feedback\" must be an integer between 0 and 100."
  }
}

locals {
  http_failure_feedback_role_arn    = var.http_feedback.failure_role_arn
  http_success_feedback_role_arn    = var.http_feedback.success_role_arn
  http_success_feedback_sample_rate = var.http_feedback.success_sample_rate
}

# Translated into locals lambda values below
variable "lambda_feedback" {
  default     = {}
  description = "The ARNs of IAM Roles for lambda feedback failures and successes, as well as the percentage sample rate for successes."
  type = object({
    failure_role_arn    = optional(string, null)
    success_role_arn    = optional(string, null)
    success_sample_rate = optional(number, null)
  })

  validation {
    condition     = var.lambda_feedback.failure_role_arn == null || can(provider::aws::arn_parse(var.lambda_feedback.failure_role_arn).service == "iam")
    error_message = "The value of the 'failure_role_arn' attribute for \"lambda_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.lambda_feedback.success_role_arn == null || can(provider::aws::arn_parse(var.lambda_feedback.success_role_arn).service == "iam")
    error_message = "The value of the 'success_role_arn' attribute for \"lambda_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.lambda_feedback.success_sample_rate == null || can(var.lambda_feedback.success_sample_rate >= 0 && var.lambda_feedback.success_sample_rate <= 100)
    error_message = "The value of the 'success_sample_rate' attribute for \"lambda_feedback\" must be an integer between 0 and 100."
  }
}

locals {
  lambda_failure_feedback_role_arn    = var.lambda_feedback.failure_role_arn
  lambda_success_feedback_role_arn    = var.lambda_feedback.success_role_arn
  lambda_success_feedback_sample_rate = var.lambda_feedback.success_sample_rate
}

# Translated into locals sqs values below
variable "sqs_feedback" {
  default     = {}
  description = "The ARNs of IAM Roles for sqs feedback failures and successes, as well as the percentage sample rate for successes."
  type = object({
    failure_role_arn    = optional(string, null)
    success_role_arn    = optional(string, null)
    success_sample_rate = optional(number, null)
  })

  validation {
    condition     = var.sqs_feedback.failure_role_arn == null || can(provider::aws::arn_parse(var.sqs_feedback.failure_role_arn).service == "iam")
    error_message = "The value of the 'failure_role_arn' attribute for \"sqs_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.sqs_feedback.success_role_arn == null || can(provider::aws::arn_parse(var.sqs_feedback.success_role_arn).service == "iam")
    error_message = "The value of the 'success_role_arn' attribute for \"sqs_feedback\" must be a valid IAM Role ARN."
  }

  validation {
    condition     = var.sqs_feedback.success_sample_rate == null || can(var.sqs_feedback.success_sample_rate >= 0 && var.sqs_feedback.success_sample_rate <= 100)
    error_message = "The value of the 'success_sample_rate' attribute for \"sqs_feedback\" must be an integer between 0 and 100."
  }
}

locals {
  sqs_failure_feedback_role_arn    = var.sqs_feedback.failure_role_arn
  sqs_success_feedback_role_arn    = var.sqs_feedback.success_role_arn
  sqs_success_feedback_sample_rate = var.sqs_feedback.success_sample_rate
}

variable "fifo_topic" {
  default     = false
  description = "Set to true to create a FIFO topic."
  type        = bool
}

variable "name" {
  default     = null
  description = "SNS topic name.  Conflicts with \"name_prefix\"."
  type        = string

  validation {
    condition     = var.name == null || can(length(var.name) <= 256)
    error_message = "The name of an SNS topic may be null or between 1 and 256 characters in length."
  }

  validation {
    condition     = var.name == null || can(regex("^[[:word:]-]*$", var.name))
    error_message = "The name of an SNS topic may only contain alphanumeric characters, hyphens, and underscores."
  }
}

variable "name_prefix" {
  default     = null
  description = "Generates unique SNS topic name beginning with name prefix.  Conflicts with \"name\"."
  type        = string
}

variable "policy_id" {
  default     = null
  description = "The ID of the policy for the SNS topic."
  type        = string
}

variable "policy_override_documents" {
  default     = []
  description = "List of IAM policy documents to merge to the SNS topic policy.  Documents in this list will override any existing policy statements."
  type        = list(string)

  validation {
    condition     = alltrue([for i in var.policy_override_documents : can(jsondecode(i))])
    error_message = "The value of 'policy_override_documents' must be valid JSON."
  }
}

variable "policy_statements" {
  default     = []
  description = "Map of IAM policy statements to attach to the SNS topic.  Type must be either \"topic\" or \"data\".  Default is \"topic\".  A type of \"data\" will attach the policy statement to the data protection policy, whereas a type of \"topic\" will attach the policy statement to the topic policy."
  type = list(object({
    actions       = optional(list(string), [])
    effect        = optional(string, "Allow")
    not_actions   = optional(list(string), [])
    not_resources = optional(list(string), [])
    resources     = optional(list(string), [])
    type          = optional(string, "topic")
    sid           = optional(string, null)

    conditions = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })), [])

    not_principals = optional(list(object({
      identifiers = list(string)
      type        = string
    })), [])

    principals = optional(list(object({
      identifiers = list(string)
      type        = string
    })), [])
  }))

  validation {
    condition = alltrue([
      for i in var.policy_statements : contains(["topic", "data"], i.type)
    ])
    error_message = "The value of 'policy_statements' must be valid JSON."
  }

  validation {
    condition = alltrue([
      for i in var.policy_statements : contains(["Allow", "Deny"], i.effect)
    ])
    error_message = "Effect must be either \"Allow\" or \"Deny\"."
  }

  validation {
    condition = alltrue([
      for i in var.policy_statements : alltrue([
        for j in i.not_principals : contains(["AWS", "CanonicalUser", "Federated", "Service", "*"], j.type)
      ])
    ])
    error_message = "The 'type' argument for not_principals much be one of \"AWS\", \"CanonicalUser\", \"Federated\", \"Service\", or \"*\"."
  }

  validation {
    condition = alltrue([
      for i in var.policy_statements : alltrue([
        for j in i.principals : contains(["AWS", "CanonicalUser", "Federated", "Service", "*"], j.type)
      ])
    ])
    error_message = "The 'type' argument for principals much be one of \"AWS\", \"CanonicalUser\", \"Federated\", \"Service\", or \"*\"."
  }
}

variable "policy_source_documents" {
  default     = []
  description = "List of IAM policy documents to merge to the SNS topic policy."
  type        = list(string)

  validation {
    condition     = alltrue([for i in var.policy_source_documents : can(jsondecode(i))])
    error_message = "The value of 'policy_source_documents' must be valid JSON."
  }
}

variable "policy_version" {
  default     = "2012-10-17"
  description = "The policy version to use when generating the SNS topic policy."
  type        = string

  validation {
    condition     = contains(["2012-10-17", "2008-10-17"], var.policy_version)
    error_message = "value must be either \"2012-10-17\" or \"2008-10-17\"."
  }
}

variable "subscriptions" {
  default     = {}
  description = "A mapping of SNS subscriptions to create for the topic."
  type = map(object({
    endpoint              = optional(string, null)
    protocol              = string
    subscription_role_arn = optional(string, null)

    confirmation_timeout_in_minutes = optional(number, 1)
    delivery_policy                 = optional(string, null)
    endpoint_auto_confirms          = optional(bool, false)
    filter_policy                   = optional(string, null)
    filter_policy_scope             = optional(string, null)
    raw_message_delivery            = optional(bool, false)
    redrive_policy                  = optional(string, null)
    replay_policy                   = optional(string, null)
  }))

  # Validate protocol is a valid value
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : contains(["application", "email", "email-json", "http", "https", "lambda", "sms", "sqs"], v.protocol)
    ])
    error_message = "Valid values for 'protocol' are \"application\", \"email\", \"email-json\", \"http\", \"https\", \"lambda\", \"sms\", and \"sqs\"."
  }

  # Validate that endpoint is valid for the protocol
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : provider::aws::arn_parse(v.endpoint).service == v.protocol if contains(["firehose", "lambda", "sqs"], v.protocol)
    ])
    error_message = "The value of 'endpoint' must be a valid ARN for the associated protocol."
  }

  validation {
    condition = alltrue([
      for k, v in var.subscriptions : can(provider::aws::arn_parse(v.endpoint)) if v.protocol == "application"
    ])
    error_message = "The value of 'endpoint' must be a valid ARN for the associated application."
  }

  # Validate that endpoint is a valid SMS number according to the SNS API: https://docs.aws.amazon.com/sns/latest/api/API_CreateSMSSandboxPhoneNumber.html
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : can(regex("^(+[0-9]{8,}|[0-9]{0,9})$", v.endpoint)) if v.protocol == "sms"
    ])
    error_message = "The value of 'endpoint' must be a valid ARN for the associated application."
  }

  # Validate the subscription_role_arn is specified when the protocol is firehose
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : v.subscription_role_arn != null if v.protocol == "firehose"
    ])
    error_message = "'subscription_role_arn' must be specified when 'protocol' is \"firehose\"."
  }

  # Validate the delivery_policy is valid JSON if the protocol is http or https
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : can(jsondecode(v.delivery_policy)) if contains(["http", "https"], v.protocol)
    ])
    error_message = "Value of 'delivery_policy' must be valid JSON.  Required for 'protocol' values \"http\" and \"https\"."
  }

  # Validate the delivery_policy is null if the protocol is not http or https
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : v.delivery_policy == null if !contains(["http", "https"], v.protocol)
    ])
    error_message = "Value of 'delivery_policy' must null if value of 'protocol' is not \"http\" and \"https\"."
  }

  # Validate the filter_policy is valid JSON
  validation {
    condition     = alltrue([for k, v in var.subscriptions : can(jsondecode(v.filter_policy)) if v.filter_policy != null])
    error_message = "Value of 'delivery_policy' must be valid JSON.  Required for 'protocol' values \"http\" and \"https\"."
  }

  # Validate the filter_policy_scope is "MessageAttributes" or "MessageBody"
  validation {
    condition = alltrue([
      for k, v in var.subscriptions : contains(["MessageAttributes", "MessageBody"], v.filter_policy_scope) if v.filter_policy_scope != null
    ])
    error_message = "Valid values for 'filter_policy_scope' are \"MessageAttributes\" (default) or \"MessageBody\"."
  }

  # Validate the redrive_policy is valid JSON
  validation {
    condition     = alltrue([for k, v in var.subscriptions : can(jsondecode(v.redrive_policy)) if v.redrive_policy != null])
    error_message = "Value of 'redrive_policy' must be valid JSON."
  }

  # Validate the replay_policy is valid JSON
  validation {
    condition     = alltrue([for k, v in var.subscriptions : can(jsondecode(v.replay_policy)) if v.replay_policy != null])
    error_message = "Value of 'replay_policy' must be valid JSON."
  }
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}
