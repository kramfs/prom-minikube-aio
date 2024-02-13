###############
## PROVIDERS ##
###############
terraform {
  #required_version = ">= 1.6.0"
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~>2"
    }
  }
}

provider "grafana" {
  url = "http://grafana.dev.internal/"
  auth = "admin:prom-operator" # Default kube-prometheus-stack value

  # Allow UI editing of API provisioned resources
  # Ref: https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/view-provisioned-resources/#edit-api-provisioned-alerting-resources
  http_headers = {
    "X-Disable-Provenance" = "true"
  }
}

##############
## VARIABLE ##
##############
#variable "dotc-k8s" {}
variable "ingress-nginx" {}
variable "resource-average" {}


###########################
## FOLDER AND DASHBOARDS ##
###########################

## --- RESOURCE AVERAGE ---
resource "grafana_folder" "resource-avg" {
  #org_id = data.grafana_organization.main.id
  #org_id = grafana_organization.main.org_id
  title = "resource-avg"
}

resource "grafana_dashboard" "resource-avg" {
  #org_id = grafana_organization.main.org_id
  folder      = grafana_folder.resource-avg.id
  config_json = file("dashboards/resource-average/resource-average.json")

  #depends_on = [
  #  grafana_folder.argocd
  #]
}

## --- NGINX ---
resource "grafana_folder" "nginx" {
  #org_id = data.grafana_organization.main.id
  #org_id = grafana_organization.main.org_id
  title = "nginx"
}

resource "grafana_dashboard" "nginx" {
  #org_id = grafana_organization.main.org_id
  folder      = grafana_folder.nginx.id
  config_json = file("dashboards/ingress-nginx/nginx.json")

  #depends_on = [
  #  grafana_folder.argocd
  #]
}