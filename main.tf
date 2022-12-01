locals {
  target_origin_id = random_id.id.hex

  default_tags = {
    application            = var.application
    business-unit          = var.business-unit
    environment-name       = var.environment-name
    infrastructure-support = var.infrastructure-support
    is-production          = var.is-production
    namespace              = var.namespace
    owner                  = var.team_name
  }
}

resource "random_id" "id" {
  byte_length = 8
}

# TODO: When Cloud Platform supports terraform-provider-aws >=4.0.0, create Origin Access Control as part of this module

resource "aws_cloudfront_distribution" "this" {
  enabled         = var.enabled
  comment         = "application: ${var.application}, environment: ${var.environment-name}"
  http_version    = "http2" # TODO: When Cloud Platform supports terraform-provider-aws >=4.0.0, enable `http3`
  is_ipv6_enabled = var.is_ipv6_enabled
  price_class     = var.price_class
  tags            = local.default_tags

  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]

    content {
      allowed_methods            = lookup(default_cache_behavior.value, "allowed_methods", ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
      cached_methods             = lookup(default_cache_behavior.value, "cached_methods", ["GET", "HEAD"])
      compress                   = lookup(default_cache_behavior.value, "compress", true)
      default_ttl                = lookup(default_cache_behavior.value, "default_ttl", 0)
      max_ttl                    = lookup(default_cache_behavior.value, "max_ttl", 0)
      min_ttl                    = lookup(default_cache_behavior.value, "min_ttl", 0)
      target_origin_id           = local.target_origin_id
      viewer_protocol_policy     = "redirect-to-https"                                                                                        # Enforce redirecting HTTP to HTTPS
      cache_policy_id            = lookup(default_cache_behavior.value, "cache_policy_id", "658327ea-f89d-4fab-a63d-7e88639e58f6")            # 658327ea-f89d-4fab-a63d-7e88639e58f6 is "CachingOptimized"
      response_headers_policy_id = lookup(default_cache_behavior.value, "response_headers_policy_id", "67f7725c-6f97-4210-82d7-5512b31e9d03") # 67f7725c-6f97-4210-82d7-5512b31e9d03 is "Managed-SecurityHeadersPolicy"
    }
  }

  dynamic "origin" {
    for_each = [var.origin]

    content {
      connection_attempts = lookup(origin.value, "connection_attempts", 3)
      connection_timeout  = lookup(origin.value, "connection_timeout", 10)
      domain_name         = lookup(origin.value, "domain_name", 10)
      origin_id           = local.target_origin_id
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
    cloudfront_default_certificate = true # Defaults to using CloudFront's certificate rather than using a custom domain and ACM
  }
}
