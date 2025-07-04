provider "vault" {
  address = "http://vault.horna.local:8200"
  token   = var.vault_token
}

variable "secret_backend_name" {
  type = string
  default = "horna-local-subdomains"
}

module "pki_engine" {
  source = "./pki-engine"
  common_name = "Horna.local"
  description = "Root CA for horna.local"
  vault_url = "https://vault.horna.local"
  subdomain_allowed = [ "horna.local"]
  secret_backend_name = var.secret_backend_name
}

module "cert_vault" {
  depends_on = [ module.pki_engine ]
  source = "./pki-cert"
  secret_backend_name = var.secret_backend_name
  common_name = "vault.horna.local"
}
module "cert_grafana" {
  depends_on = [ module.pki_engine ]
  source = "./pki-cert"
  secret_backend_name = var.secret_backend_name
  common_name = "grafana.horna.local"
}
module "cert_prometheus" {
  depends_on = [ module.pki_engine ]
  source = "./pki-cert"
  secret_backend_name = var.secret_backend_name
  common_name = "prometheus.horna.local"
}