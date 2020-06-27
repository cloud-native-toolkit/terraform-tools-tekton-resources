provider "null" {
}

locals {
  tmp_dir = "${path.cwd}/.tmp"
  version_file = "${local.tmp_dir}/tekton-resources-version.val"
}

resource "null_resource" "get_latest_release" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/get-latest-release.sh ${var.git_url} ${var.revision} ${local.version_file}"
  }
}

data "local_file" "latest-release" {
  filename = local.version_file
}

resource "null_resource" "tekton_resources" {
  count = var.cluster_type == "ocp4" ? 1 : 0

  triggers = {
    kubeconfig      = var.cluster_config_file_path
    tools_namespace = var.resource_namespace
    revision        = data.local_file.latest-release.content
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/deploy-tekton-resources.sh ${self.triggers.tools_namespace} ${var.pre_tekton} ${self.triggers.revision} ${var.git_url}"

    environment = {
      KUBECONFIG       = self.triggers.kubeconfig
      TMP_DIR          = "${local.tmp_dir}"
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/scripts/destroy-tekton-resources.sh ${self.triggers.tools_namespace} ${self.triggers.revision}"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }
}
