module "dev_tools_tekton" {
  source = "github.com/cloud-native-toolkit/terraform-tools-tekton.git"

  cluster_config_file_path = module.dev_cluster.config_file_path
  cluster_ingress_hostname = module.dev_cluster.platform.ingress
}

module "dev_tools_tekton_resources" {
  source = "./module"

  cluster_type             = module.dev_cluster.platform.type_code
  cluster_config_file_path = module.dev_cluster.config_file_path
  resource_namespace       = module.dev_tools_namespace.name
  support_namespace        = module.buildah-unprivileged.namespace
  tekton_namespace         = module.dev_tools_tekton.tekton_namespace
}
