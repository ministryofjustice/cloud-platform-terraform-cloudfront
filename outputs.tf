output "cloudfront_url" {
  description = "The CloudFront distrubtion domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "cloudfront_public_key_ids" {
  description = "The CloudFront public key IDs, with reference to the public key's first 8 characters."
  value = [
    for i in range(length(aws_cloudfront_public_key.this)) :
    {
      "id"  = aws_cloudfront_public_key.this[i].id
      # Offest 71 will skip over the "-----BEGIN PUBLIC KEY-----\n" and header parts of the PEM.
      "key" = substr(aws_cloudfront_public_key.this[i].encoded_key, 71, 8)
    }
  ]
}
