// Variables for AzureRM provider, in case you want to use a service principal

variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
  default     = ""
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
  default     = ""
}

variable "client_id" {
  description = "The Azure client ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "client_secret" {
  description = "The Azure client secret"
  type        = string
  sensitive   = true
  default     = ""
}
