variable "common_name" {
  type    = string
  default = "Common name of a cert"
}
variable "cert_ttl" {
  type        = string
  description = "Certificate TTL"
  default     = "43800h" # 5 years
}
variable "secret_backend_name" {
  type        = string
  description = "Name of secrets backend in Vault"
}
