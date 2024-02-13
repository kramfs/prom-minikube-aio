##############
## MINIKUBE ##
##############
# Description: Provision a local minikube cluster for that can be used for local development

## TERRAFORM DEFINITION ##
terraform {
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "~>0.3" # Good practice to pin to a specific provider version
    }
  }
}

## PROVIDER ##
provider "minikube" {
  # Commenting the following will default to using the current stable version
  kubernetes_version = var.kubernetes_version
}

resource "minikube_cluster" "docker" {
  driver            = var.driver
  cluster_name      = var.cluster_name
  cpus              = var.cpus
  memory            = var.memory
  nodes             = var.nodes
  container_runtime = var.container_runtime
  addons            = var.addons
  #wait              = var.wait
}