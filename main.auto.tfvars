minikube = {
  cluster_name       = "minikube"
  driver             = "docker" # docker,podman,kvm2,qemu,hyperkit,hyperv,ssh
  kubernetes_version = "v1.28.3"
  container_runtime  = "containerd" # docker, containerd, cri-o
  nodes              = "2"
}

metallb = {
  name             = "metallb-system"
  namespace        = "metallb-system"
  create_namespace = true

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  #version    = "4.9.1" # Chart version
}

prometheus-stack = {
  name             = "kube-prometheus-stack"
  namespace        = "kube-prometheus-stack"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "" # Chart version
}

ingress-nginx = {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  #version    = "4.9.1" # Chart version
}