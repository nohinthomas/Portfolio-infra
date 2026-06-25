output "static_web_app_url" {
  description = "The default URL of the deployed Static Web App"
  value       = "https://${azurerm_static_site.portfolio.default_host_name}"
}

output "api_key" {
  description = "Deployment API key — add this to GitHub Secrets as AZURE_STATIC_WEB_APPS_API_TOKEN"
  value       = azurerm_static_site.portfolio.api_key
  sensitive   = true
}

output "resource_group_name" {
  description = "The existing resource group being used"
  value       = data.azurerm_resource_group.portfolio.name
}
