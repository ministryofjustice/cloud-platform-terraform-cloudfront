#################
# Configuration #
#################
variable "bucket_domain_name" {
  type        = string
  description = "S3 bucket domain name to serve content from"
}

variable "bucket_id" {
  type        = string
  description = "S3 bucket ID to serve content from (used to automatically create the appropriate policy)"
}

variable "default_cache_behavior" {
  type        = map(any)
  description = "Default cache behaviour"
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
