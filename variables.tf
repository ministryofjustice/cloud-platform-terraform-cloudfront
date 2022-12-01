variable "application" {
  type        = string
  description = "Application name"
}

variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  default     = ""
  type        = string
}

variable "environment-name" {
  type        = string
  description = "Environment name"
}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}

variable "is-production" {
  default     = "false"
  description = "Whether the environment is production or not"
  type        = string
}

variable "namespace" {
  default     = ""
  description = "Namespace name"
  type        = string
}

variable "team_name" {
  type        = string
  description = "Team name"
}

variable "enabled" {
  type        = bool
  description = "Enable the CloudFront distribution"
  default     = true
}

variable "is_ipv6_enabled" {
  type        = bool
  description = "Enable IPv6 support"
  default     = true
}

variable "price_class" {
  type        = string
  description = "Price Class to use"
  default     = "PriceClass_All"
}

variable "geo_restriction" {
  type        = map(any)
  description = "Geographical restrictions"
  default     = {}
}

variable "default_cache_behavior" {
  type        = map(any)
  description = "Default cache behaviour"
  default     = {}
}

variable "origin" {
  type        = map(any)
  description = "Origin to serve from"
  default     = {}
}
