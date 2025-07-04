# Enable PKI secrets engine for root
resource "vault_mount" "pki_root" {
  path        = "pki"
  type        = "pki"
  description = var.description
}

# Generate the root certificate
resource "vault_pki_secret_backend_root_cert" "root_cert" {
  backend = vault_mount.pki_root.path

  type                 = "internal"
  common_name          = var.common_name
  not_after            = var.root_pki_expiration_date
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  organization         = var.organization
  ou                   = var.ou
  country              = "Poland"
}

# Set URLs for issuing and CRL
resource "vault_pki_secret_backend_config_urls" "pki_urls" {
  backend = vault_mount.pki_root.path

  issuing_certificates    = ["${var.vault_url}/v1/pki/ca"]
  crl_distribution_points = ["${var.vault_url}/v1/pki/crl"]
}

# Create a role for issuing subdomain certs
resource "vault_pki_secret_backend_role" "subdomains" {
  backend = vault_mount.pki_root.path
  name    = var.secret_backend_name

  organization = ["Horna Home Lab"]
  ou           = ["Home"]

  allowed_domains  = var.subdomain_allowed
  allow_subdomains = true
  max_ttl          = "63072000"
  require_cn       = true
  generate_lease   = true
  allow_localhost  = false
  key_type         = "rsa"
  key_bits         = 2048
}

# Create a KV to store certs private key
resource "vault_mount" "cert_secrets" {
  path        = "cert-secrets"
  type        = "kv"
  description = "KV storage for certs"

  options = {
    version = "2"
  }
}
