# cloud-platform-terraform-cloudfront

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-cloudfront/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-cloudfront/releases)

A Terraform module to create a CloudFront distribution, allowing you to put data held in S3 behind a CDN.

## Usage

See the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.75.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.75.2 |
| <a name="provider_random"></a> [random](#provider\_random) | >=2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_business-unit"></a> [business-unit](#input\_business-unit) | Area of the MOJ responsible for the service | `string` | `""` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | Default cache behaviour | `map(any)` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable the CloudFront distribution | `bool` | `true` | no |
| <a name="input_environment-name"></a> [environment-name](#input\_environment-name) | Environment name | `string` | n/a | yes |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | Geographical restrictions | `map(any)` | `{}` | no |
| <a name="input_infrastructure-support"></a> [infrastructure-support](#input\_infrastructure-support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | n/a | yes |
| <a name="input_is-production"></a> [is-production](#input\_is-production) | Whether the environment is production or not | `string` | `"false"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Enable IPv6 support | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | `""` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | Origin to serve from | `map(any)` | `{}` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Price Class to use | `string` | `"PriceClass_All"` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Team name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidance](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |

## Reading Material

- [CloudFront documentation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
