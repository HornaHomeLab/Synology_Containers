data "vault_generic_secret" "omada_config" {
  path = "dot_env_file/Omada_Exporter"
}
locals {
  env_lines_omada = [
    for key, value in data.vault_generic_secret.omada_config.data : "${key}=${value}"
  ]
}

resource "local_file" "env_omada" {
  content = join("\n", local.env_lines_omada)
  filename = "${path.module}/../docker/Omada_Exporter/env"
}
