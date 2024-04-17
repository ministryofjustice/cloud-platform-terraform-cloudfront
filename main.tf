locals {
  # Generic configuration
  target_origin_id = random_id.id.hex # this is arbitrary

  # Tags
  default_tags = {
    # Mandatory
    business-unit = var.business_unit
    application   = var.application
    is-production = var.is_production
    owner         = var.team_name
    namespace     = var.namespace # for billing and identification purposes

    # Optional
    environment-name       = var.environment_name
    infrastructure-support = var.infrastructure_support
  }

  # Trusted public keys.
  # When setting encoded_key value, there needs a newline at the end of string. 
  # Otherwise, multiple runs of terraform will want to recreate the aws_cloudfront_public_key resource.
  econded_keys_formatted  = [for key in var.trusted_public_keys : "${trimspace(key.encoded_key)}\n"]
  # Short hash of the encoded key - for part of the public key name and maybe comment.
  encoded_keys_short_hash = [for key in local.econded_keys_formatted : substr(sha256(key), 0, 8)]
}

########################
# Generate identifiers #
########################
resource "random_id" "id" {
  byte_length = 8
}

########################################
# Get WAF IDs for Prisoner Content Hub #
########################################
data "aws_ssm_parameter" "prisoner_content_hub" {
  count = (var.ip_allow_listing_environment != null) ? 1 : 0
  name  = "/prisoner-content-hub-${var.ip_allow_listing_environment}/web-acl-arn"
}

################################
# Create CloudFront Public Key #
################################

resource "aws_cloudfront_public_key" "this" {
  count = length(var.trusted_public_keys)

  encoded_key = local.econded_keys_formatted[count.index]
  name        = "${var.application}-${var.namespace}-${local.encoded_keys_short_hash[count.index]}"
  comment     = var.trusted_public_keys[count.index].comment != "" ? var.trusted_public_keys[count.index].comment : local.encoded_keys_short_hash[count.index]

  lifecycle {
    # If encoded_key is changed then terraform doesn't update it in place. It needs to be recreated.
    # The create_before_destroy lifecycle is used to ensure that the new key is created before the old key is destroyed.
    # This should prevent an error like `The Cloudfront public key is currently associated with either Key Group`
    create_before_destroy = true
  }
}

###############################
# Create CloudFront Key Group #
###############################

resource "aws_cloudfront_key_group" "this" {
  count = length(var.trusted_public_keys) == 0 ? 0 : 1

  items = aws_cloudfront_public_key.this[*].id
  name  = "${var.application}-${var.namespace}-key-group"
}

##################################
# Create CloudFront distribution #
##################################
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  aliases             = var.aliases
  comment             = "application: ${var.application}, environment: ${var.environment_name}"
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = var.price_class
  default_root_object = var.default_root_object
  web_acl_id          = (var.ip_allow_listing_environment != null) ? data.aws_ssm_parameter.prisoner_content_hub[0].value : null
  tags                = local.default_tags

  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]

    content {
      allowed_methods            = lookup(default_cache_behavior.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods             = lookup(default_cache_behavior.value, "cached_methods", ["GET", "HEAD"])
      compress                   = lookup(default_cache_behavior.value, "compress", true)
      default_ttl                = lookup(default_cache_behavior.value, "default_ttl", 0)
      max_ttl                    = lookup(default_cache_behavior.value, "max_ttl", 0)
      min_ttl                    = lookup(default_cache_behavior.value, "min_ttl", 0)
      target_origin_id           = local.target_origin_id
      viewer_protocol_policy     = "redirect-to-https"                                                                                        # Enforce redirecting HTTP to HTTPS
      cache_policy_id            = lookup(default_cache_behavior.value, "cache_policy_id", "658327ea-f89d-4fab-a63d-7e88639e58f6")            # 658327ea-f89d-4fab-a63d-7e88639e58f6 is "CachingOptimized"
      response_headers_policy_id = lookup(default_cache_behavior.value, "response_headers_policy_id", "67f7725c-6f97-4210-82d7-5512b31e9d03") # 67f7725c-6f97-4210-82d7-5512b31e9d03 is "Managed-SecurityHeadersPolicy"
      trusted_key_groups         = length(var.trusted_public_keys) == 0 ? null : [aws_cloudfront_key_group.this[0].id]
    }
  }

  dynamic "origin" {
    for_each = [var.origin]

    content {
      connection_attempts      = lookup(origin.value, "connection_attempts", 3)
      connection_timeout       = lookup(origin.value, "connection_timeout", 10)
      domain_name              = var.bucket_domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.this.id
      origin_id                = local.target_origin_id
      origin_path              = lookup(origin.value, "origin_path", null)
    }
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.geo_restriction]

      content {
        restriction_type = lookup(geo_restriction.value, "restriction_type", "none")
        locations        = lookup(geo_restriction.value, "locations", [])
      }
    }
  }

  viewer_certificate {
     # If no aliases and using a CloudFront domain - use CloudFront's certificate rather than using a custom domain and ACM
    cloudfront_default_certificate = var.aliases_cert_arn == null

    # If using aliases - use ACM certificate and SNI-only SSL support method.
    acm_certificate_arn = var.aliases_cert_arn
    ssl_support_method  = var.aliases_cert_arn != null ? "sni-only" : null
  }

}

################################
# Create Origin Access Control #
################################
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = local.target_origin_id
  description                       = "application: ${var.application}, environment: ${var.environment_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

###########################
# Create S3 bucket policy #
###########################
data "aws_iam_policy_document" "bucket_policy" {
  version = "2012-10-17"

  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_id}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.this.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
