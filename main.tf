
locals {
  tmp_dir = "${path.cwd}/.tmp"
}

resource null_resource print_support_namespace {
  provisioner "local-exec" {
    command = "echo 'Namespaces: support_namespace=${var.support_namespace}, tekton_namespace=${var.tekton_namespace}'"
  }
}

module setup_clis {
  source = "cloud-native-toolkit/clis/util"
  version = "1.16.4"

  clis = ["kubectl", "jq"]
}

data external latest_release {
  program = ["bash", "${path.module}/scripts/get-latest-release.sh"]

  query = {
    git_url = var.git_url
    revision = var.revision
    bin_dir = module.setup_clis.bin_dir
  }
}

resource "null_resource" "tekton_resources" {
  count = var.cluster_type == "ocp4" ? 1 : 0
  depends_on = [null_resource.print_support_namespace]

  triggers = {
    kubeconfig      = var.cluster_config_file_path
    tools_namespace = var.resource_namespace
    revision        = data.external.latest_release.result.release
    bin_dir         = module.setup_clis.bin_dir
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-tekton-resources.sh ${self.triggers.tools_namespace} ${var.pre_tekton} ${self.triggers.revision} ${var.git_url}"

    environment = {
      TMP_DIR    = local.tmp_dir
      KUBECONFIG = self.triggers.kubeconfig
      BIN_DIR    = self.triggers.bin_dir
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/destroy-tekton-resources.sh ${self.triggers.tools_namespace} ${self.triggers.revision}"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
      BIN_DIR    = self.triggers.bin_dir
    }
  }
}
