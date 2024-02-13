## OUTPUT ##
output "minikube_cluster_host" {
  value = minikube_cluster.docker.host
}

output "minikube_cluster_name" {
  value = minikube_cluster.docker.cluster_name
}

output "minikube_cluster_client_certificate" {
  value     = minikube_cluster.docker.client_certificate
  sensitive = true
}

output "minikube_cluster_client_key" {
  value     = minikube_cluster.docker.client_key
  sensitive = true
}

output "minikube_cluster_ca_certificate" {
  value     = minikube_cluster.docker.cluster_ca_certificate
  sensitive = true
}

output "minikube_cluster_dns_domain" {
  value = minikube_cluster.docker.dns_domain
}