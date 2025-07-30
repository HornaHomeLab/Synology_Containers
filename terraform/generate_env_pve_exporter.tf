data "vault_generic_secret" "pve_exporter_config" {
  path = "dot_env_file/PVE_Exporter"
}
locals {
  env_lines_pve_exporter = [
    for key, value in data.vault_generic_secret.pve_exporter_config.data : "${key}=${value}"
  ]
}

resource "local_file" "env_pve_exporter" {
  content = join("\n", local.env_lines_pve_exporter)
  filename = "${path.module}/../docker/PVE_Exporter/env"
}
