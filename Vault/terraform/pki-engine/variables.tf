variable "common_name" {
  type        = string
  description = "Common name for root cert"
}
variable "description" {
  type        = string
  description = "Description of a pki root"
}
variable "organization" {
  type        = string
  description = "Organization name"
  default     = "Horna Home Lab"
}
variable "ou" {
  type        = string
  description = "Organization name"
  default     = "Home"
}
variable "root_pki_expiration_date" {
  type        = string
  description = "Root PKI expiration date in UTC format YYYY-MM-ddTHH:MM:SSZ"
  default     = "2100-01-01T00:00:00Z"
}
variable "vault_url" {
  type        = string
  description = "URL of the Vault"
}
variable "secret_backend_name" {
  type        = string
  description = "Name of secrets backend in Vault"
}
variable "subdomain_allowed" {
  type        = set(string)
  description = "Set of allowed subdomains"
}
