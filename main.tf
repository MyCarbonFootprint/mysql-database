
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
