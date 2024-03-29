variable "cluster_type" {
  type        = string
  description = "The type of cluster that should be created (openshift or ocp3 or ocp4 or kubernetes)"
}

variable "cluster_config_file_path" {
  type        = string
  description = "The path to the config file for the cluster"
}

variable "resource_namespace" {
  type        = string
  description = "The namespace where the tekton tasks will be deployed"
  default     = "tools"
}

variable "pre_tekton" {
  type        = string
  description = "Flag indicating that the Tekton installed version is pre 0.7.0"
  default     = "false"
}

variable "revision" {
  type        = string
  description = "The revision Cloud Native Toolkit Tekton tasks and pipelines"
  default     = "v2.7.7"
}

variable "git_url" {
  type        = string
  description = "The git api url containing Cloud-Native Toolkit Tekton tasks and pipelines"
  default     = " https://api.github.com/repos/ibm/ibm-garage-tekton-tasks"
}

variable "support_namespace" {
  type        = string
  description = "The namespace where supporting infrastructure and configuration are running (e.g. buildah-unprivileged daemon set)"
  default     = ""
}

variable "tekton_namespace" {
  type        = string
  description = "The namespace where tekton is running. This variable is used to make sure tekton has installed before installing the tekton resources"
  default     = ""
}
