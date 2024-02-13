output "minikube_ip" {
  value = module.minikube_cluster.minikube_cluster_host
}

output "minikube_name" {
  value = module.minikube_cluster.minikube_cluster_name
}

output "minikube_domain" {
  value = module.minikube_cluster.minikube_cluster_dns_domain
}

output "helm_prometheus-stack_name" {
  value = helm_release.prometheus-stack.name
}

output "helm_prometheus-stack_version" {
  value = helm_release.prometheus-stack.version
}

output "helm_ingress-nginx_name" {
  value = helm_release.ingress-nginx.name
}

output "helm_ingress-nginx_version" {
  value = helm_release.ingress-nginx.version
}