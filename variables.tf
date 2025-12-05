#################
# Configuration #
#################
variable "aliases" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  default     = []
}

variable "aliases_cert_arn" {
  type        = string
  description = "ACM certificate ARN for the aliases"
  default     = null
}

variable "bucket_domain_name" {
  type        = string
  description = "S3 bucket domain name to serve content from"
}

variable "bucket_id" {
  type        = string
  description = "S3 bucket ID to serve content from (used to automatically create the appropriate policy)"
}

variable "trusted_public_keys" {
  type = list(object({
    encoded_key = string
    comment     = string
    associate   = bool
  }))
  description = "Public key in PEM format. Including --- BEGIN PUBLIC KEY --- and --- END PUBLIC KEY ---. Optional comment."
  default     = []
}

variable "default_root_object" {
  type        = string
  description = "Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default     = null
}

variable "enable_ordered_cache_behavior" {
  type        = bool
  description = "Whether to enable ordered cache behavior"
  default     = false
}

variable "default_cache_behavior" {
  type        = map(any)
  description = "Default cache behaviour"
  default     = {}
}

variable "ordered_cache_behavior" {
  type        = map(any)
  description = "Ordered cache behavior configuration. Must include path_pattern. Optional: allowed_methods, cached_methods, compress, default_ttl, max_ttl, min_ttl, cache_policy_id, response_headers_policy_id"
  default     = {}
}

variable "geo_restriction" {
  type        = map(any)
  description = "Geographical restrictions"
  default     = {}
}

variable "origin" {
  type        = map(any)
  description = "Origin configuration (origin.connection_attempts, origin.connection_timeout)"
  default     = {}
}

variable "price_class" {
  type        = string
  description = "Price Class to use"
  default     = "PriceClass_All"
}

variable "ip_allow_listing_environment" {
  type        = string
  default     = null
  description = "[Prisoner Content Hub only]: specify the environment name to restrict CloudFront to a preset IP allow-list, either `development`, `staging`, `production`. Leave empty for unrestricted access."
}

variable "custom_error_response" {
  type        = list(any)
  description = "One or more custom error response elements"
  default     = []
}

variable "opt_in_xsiam_logging" {
  description = "If set to true, it will send cloudfront logs to an S3 bucket and send them to Cortex XSIAM."
  type        = bool
  default     = false
}

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}

variable "service_area" {
  description = "The MOJ service area this application supports"
  type        = string
}