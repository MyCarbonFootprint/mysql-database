
resource "helm_release" "mariadb" {
  name      = "mariadb-release"
  chart     = "bitnami/mariadb"

  values = [
    file("values.yaml")
  ]

  set_sensitive {
    name  = "auth.rootPassword"
    value = var.mariadb_root_password
  }

  set_sensitive {
    name  = "auth.password"
    value = var.mariadb_root_password
  }

  set_sensitive {
    name  = "auth.replicationPassword"
    value = var.mariadb_root_password
  }
}

resource "helm_release" "adminer" {
  name      = "adminer-release"
  chart     = "cetic/adminer"

  values = [
    file("adminer-values.yaml")
  ]

  set {
    name  = "ingress.hosts"
    value = "{adminer${data.terraform_remote_state.kube_cluster.outputs.cluster_wildcard_dns}}"
  }
}
