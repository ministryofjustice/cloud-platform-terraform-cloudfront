output "cloudfront_url" {
  description = "The CloudFront distrubtion domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "cloudfront_public_keys" {
  description = "The CloudFront public key IDs, with reference to the public key's comment, defaults to first 8 characters of it's sha256."
  value = jsonencode([
    for i in range(length(aws_cloudfront_public_key.this)) :
    {
      "id"      = aws_cloudfront_public_key.this[i].id
      "comment" = aws_cloudfront_public_key.this[i].comment
      "group"   = var.trusted_public_keys[i].associate == true ? aws_cloudfront_key_group.this[0].id : null
    }
  ])
}
