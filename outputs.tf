output "cloudfront_url" {
  description = "The CloudFront distrubtion domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "cloudfront_public_key_ids" {
  description = "The CloudFront public key IDs"
  value       = aws_cloudfront_public_key.this[0] ? aws_cloudfront_public_key.this[*].id : null
}