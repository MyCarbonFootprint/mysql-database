terraform {
  backend "gcs" {
    bucket  = "tf-state-mariadb"
    prefix  = "terraform/state"
  }
}

data "terraform_remote_state" "kube_cluster" {
  backend = "gcs"
  config = {
    bucket  = "tf-state-kube-cluster"
    prefix  = "terraform/state"
  }
}

provider "helm" {
  kubernetes {
    load_config_file = "false"
    host = data.terraform_remote_state.kube_cluster.outputs.kube_host
    token = data.terraform_remote_state.kube_cluster.outputs.kube_token
    insecure = true
  }
}

provider "kubernetes" {
  load_config_file = "false"
  host = data.terraform_remote_state.kube_cluster.outputs.kube_host
  token = data.terraform_remote_state.kube_cluster.outputs.kube_token
  insecure = true
}
