output "adminer_url" {
    value = "adminer${data.terraform_remote_state.kube_cluster.outputs.cluster_wildcard_dns}"
}

