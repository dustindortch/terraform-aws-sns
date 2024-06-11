# terraform-aws-sns

This is a template repository for scaffoldering Terraform modules.  This README file should be updated to reflect the modules name and any other relevant information.

The main.tf file has commented started code for the terraform block, provider blocks (should not be used in a module), and contextual data sources for each provider (also should not be used in a module).  Uncomment and update the necessary items for the module.  If using provider and data sources, use them as references to include in the root module and pass in any required information.

The variables.tf and outputs.tf have an example for "name".

The .gitignore file has common files and directories to ignore for Terraform projects.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_data_protection_policy.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_data_protection_policy) | resource |
| [aws_sns_topic_policy.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_caller_identity.ctx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_feedback"></a> [application\_feedback](#input\_application\_feedback) | The ARNs of IAM Roles for application feedback failures and successes, as well as the percentage sample rate for successes. | <pre>object({<br>    failure_role_arn    = optional(string, null)<br>    success_role_arn    = optional(string, null)<br>    success_sample_rate = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Set to true to enable content-based deduplication for FIFO topics. | `bool` | `false` | no |
| <a name="input_delivery_policy"></a> [delivery\_policy](#input\_delivery\_policy) | The delivery policy for the SNS topic. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the SNS topic. | `string` | `null` | no |
| <a name="input_fifo_topic"></a> [fifo\_topic](#input\_fifo\_topic) | Set to true to create a FIFO topic. | `bool` | `false` | no |
| <a name="input_firehose_feedback"></a> [firehose\_feedback](#input\_firehose\_feedback) | The ARNs of IAM Roles for firehose feedback failures and successes, as well as the percentage sample rate for successes. | <pre>object({<br>    failure_role_arn    = optional(string, null)<br>    success_role_arn    = optional(string, null)<br>    success_sample_rate = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_http_feedback"></a> [http\_feedback](#input\_http\_feedback) | The ARNs of IAM Roles for http feedback failures and successes, as well as the percentage sample rate for successes. | <pre>object({<br>    failure_role_arn    = optional(string, null)<br>    success_role_arn    = optional(string, null)<br>    success_sample_rate = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The ID of the AWS-managed customer master key for use with SNS. | `string` | `null` | no |
| <a name="input_lambda_feedback"></a> [lambda\_feedback](#input\_lambda\_feedback) | The ARNs of IAM Roles for lambda feedback failures and successes, as well as the percentage sample rate for successes. | <pre>object({<br>    failure_role_arn    = optional(string, null)<br>    success_role_arn    = optional(string, null)<br>    success_sample_rate = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | SNS topic name.  Conflicts with "name\_prefix". | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Generates unique SNS topic name beginning with name prefix.  Conflicts with "name". | `string` | `null` | no |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | The ID of the policy for the SNS topic. | `string` | `null` | no |
| <a name="input_policy_override_documents"></a> [policy\_override\_documents](#input\_policy\_override\_documents) | List of IAM policy documents to merge to the SNS topic policy.  Documents in this list will override any existing policy statements. | `list(string)` | `[]` | no |
| <a name="input_policy_source_documents"></a> [policy\_source\_documents](#input\_policy\_source\_documents) | List of IAM policy documents to merge to the SNS topic policy. | `list(string)` | `[]` | no |
| <a name="input_policy_statements"></a> [policy\_statements](#input\_policy\_statements) | Map of IAM policy statements to attach to the SNS topic.  Type must be either "topic" or "data".  Default is "topic".  A type of "data" will attach the policy statement to the data protection policy, whereas a type of "topic" will attach the policy statement to the topic policy. | <pre>list(object({<br>    actions       = optional(list(string), [])<br>    effect        = optional(string, "Allow")<br>    not_actions   = optional(list(string), [])<br>    not_resources = optional(list(string), [])<br>    resources     = optional(list(string), [])<br>    type          = optional(string, "topic")<br>    sid           = optional(string, null)<br><br>    conditions = optional(list(object({<br>      test     = string<br>      values   = list(string)<br>      variable = string<br>    })), [])<br><br>    not_principals = optional(list(object({<br>      identifiers = list(string)<br>      type        = string<br>    })), [])<br><br>    principals = optional(list(object({<br>      identifiers = list(string)<br>      type        = string<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_policy_version"></a> [policy\_version](#input\_policy\_version) | The policy version to use when generating the SNS topic policy. | `string` | `"2012-10-17"` | no |
| <a name="input_sqs_feedback"></a> [sqs\_feedback](#input\_sqs\_feedback) | The ARNs of IAM Roles for sqs feedback failures and successes, as well as the percentage sample rate for successes. | <pre>object({<br>    failure_role_arn    = optional(string, null)<br>    success_role_arn    = optional(string, null)<br>    success_sample_rate = optional(number, null)<br>  })</pre> | `{}` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | A mapping of SNS subscriptions to create for the topic. | <pre>map(object({<br>    endpoint              = optional(string, null)<br>    protocol              = string<br>    subscription_role_arn = optional(string, null)<br><br>    confirmation_timeout_in_minutes = optional(number, 1)<br>    delivery_policy                 = optional(string, null)<br>    endpoint_auto_confirms          = optional(bool, false)<br>    filter_policy                   = optional(string, null)<br>    filter_policy_scope             = optional(string, null)<br>    raw_message_delivery            = optional(bool, false)<br>    redrive_policy                  = optional(string, null)<br>    replay_policy                   = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tracing_config"></a> [tracing\_config](#input\_tracing\_config) | Tracing mode for the SNS topic.  Valid values are 'Active' or 'PassThrough'. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->