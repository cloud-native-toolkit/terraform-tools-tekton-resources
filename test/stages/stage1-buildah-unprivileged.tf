module "buildah-unprivileged" {
  source = "github.com/cloud-native-toolkit/terraform-ocp-buildah-unprivileged"

  cluster_config_file = module.dev_cluster.config_file_path
  namespace = module.toolkit_namespace.name
}
