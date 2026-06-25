variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-nohin-portfolio"
}

variable "location" {
  description = "Azure region for the Resource Group"
  type        = string
  default     = "australiaeast"
}

variable "app_name" {
  description = "Name of the Azure Static Web App"
  type        = string
  default     = "nohin-portfolio-tf"  # new name to avoid clashing with existing app
}

# Service Principal credentials
# These are passed in via GitHub Secrets as environment variables
# Never hardcode these values here

variable "client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}
