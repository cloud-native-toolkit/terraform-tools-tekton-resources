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

variable "tekton_namespace" {
  type        = string
  description = "The namespace where the tekton service was deployed"
}

variable "pre_tekton" {
  type        = string
  description = "Flag indicating that the Tekton installed version is pre 0.7.0"
  default     = "false"
}

variable "revision" {
  type        = string
  description = "The revision Cloud Native Toolkit Tekton tasks and pipelines"
  default     = "1.2.0"
}

variable "git_url" {
  type        = string
  description = "The git url Cloud Native Toolkit Tekton tasks and pipelines"
  default     = "https://github.com/ibm/ibm-garage-tekton-tasks"
}
