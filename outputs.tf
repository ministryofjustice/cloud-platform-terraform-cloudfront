output "cloudfront_url" {
  description = "The CloudFront distrubtion domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}
