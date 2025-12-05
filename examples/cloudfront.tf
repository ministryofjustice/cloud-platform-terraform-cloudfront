module "s3" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-s3-bucket?ref=5.1.0" # use the latest release

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}

# CloudFront Distribution with ordered_cache_behaviors
module "cloudfront" {
  # source = "github.com/ministryofjustice/cloud-platform-terraform-cloudfront?ref=version" # use the latest release
  source = "../"

  # Configuration
  bucket_id          = module.s3.bucket_name
  bucket_domain_name = module.s3.bucket_domain_name

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name
  namespace              = var.namespace
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
  service_area           = var.service_area

  # Ordered cache behaviors (optional)
  enable_ordered_cache_behavior = true # Default is false

  ordered_cache_behavior = {
    path_pattern = "/images/*"
    # Optional parameters
    # cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" ### CachingDisabled
  }
}