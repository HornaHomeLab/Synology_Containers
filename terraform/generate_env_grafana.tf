data "vault_generic_secret" "grafana_config" {
  path = "dot_env_file/Synology_Grafana"
}
locals {
  env_lines_grafana = [
    for key, value in data.vault_generic_secret.grafana_config.data : "${key}=${value}"
  ]
}

resource "local_file" "env_grafana" {
  content = join("\n", local.env_lines_grafana)
  filename = "${path.module}/../docker/Grafana/env"
}
