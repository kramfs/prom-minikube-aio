##############
## MINIKUBE ##
##############

module "minikube_cluster" {
  #source = "${path.module}/modules/minikube-cluster"
  source             = "./module/minikube-cluster"
  cluster_name       = lookup(var.minikube, "cluster_name", "minikube-cluster")
  driver             = lookup(var.minikube, "driver", "docker")                 # docker,podman,kvm2,qemu,hyperkit,hyperv,ssh
  kubernetes_version = lookup(var.minikube, "kubernetes_version", null)         # Default: Use "stable" if not set
  container_runtime  = lookup(var.minikube, "container_runtime", "containerd")  # Default: containerd
  nodes              = lookup(var.minikube, "nodes", "1")
}


##############
## PROVIDER ##
##############

provider "kubernetes" {
  config_path = "~/.kube/config"
  host        = module.minikube_cluster.minikube_cluster_host

  client_certificate     = module.minikube_cluster.minikube_cluster_client_certificate
  client_key             = module.minikube_cluster.minikube_cluster_client_key
  cluster_ca_certificate = module.minikube_cluster.minikube_cluster_ca_certificate
}


##################
## HELM SECTION ##
##################

# HELM PROVIDER
provider "helm" {
  kubernetes {
    host                   = module.minikube_cluster.minikube_cluster_host
    client_certificate     = module.minikube_cluster.minikube_cluster_client_certificate
    client_key             = module.minikube_cluster.minikube_cluster_client_key
    cluster_ca_certificate = module.minikube_cluster.minikube_cluster_ca_certificate
  }
}

## HELM RELEASE

# REF: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
resource "helm_release" "prometheus-stack" {
  name             = var.prometheus-stack.name
  namespace        = var.prometheus-stack.namespace
  create_namespace = var.prometheus-stack.create_namespace

  repository = var.prometheus-stack.repository
  chart      = var.prometheus-stack.chart
  version    = lookup(var.prometheus-stack, "version", null) # Chart version

  values = [
    file("./helm_values/kube-prometheus-stack.yaml")
  ]

  #depends_on = [ helm_release.ingress-nginx ]
}

# REF: https://artifacthub.io/packages/helm/metallb/metallb
resource "helm_release" "metallb" {
  name             = var.metallb.name
  namespace        = var.metallb.namespace
  create_namespace = var.metallb.create_namespace

  repository = var.metallb.repository
  chart      = var.metallb.chart
  version    = lookup(var.metallb, "version", null) # Chart version

  values = [
    file("./helm_values/metallb-system.yaml")
  ]

  provisioner "local-exec" {
    command = "kubectl apply -f ./helm_values/metallb-system-config.yaml"
  }

  depends_on = [ helm_release.prometheus-stack ]
  timeout = 600         # In seconds
}


# REF: https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
resource "helm_release" "ingress-nginx" {
  name             = var.ingress-nginx.name
  namespace        = var.ingress-nginx.namespace
  create_namespace = var.ingress-nginx.create_namespace

  repository = var.ingress-nginx.repository
  chart      = var.ingress-nginx.chart
  version    = lookup(var.ingress-nginx, "version", null) # Chart version

  values = [
    file("./helm_values/ingress-nginx.yaml")
  ]

  timeout = 600         # In seconds
  depends_on = [ helm_release.prometheus-stack ]
}