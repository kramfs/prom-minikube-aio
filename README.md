<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Pre-requisites](#pre-requisite)
- [Usage](#usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Introduction

Get your Kubernetes dev env up and running instantly with this automated setup. Spin up a local cluster with Minikube, prepped for monitoring, ingress, and load balancing ro simulate actual cloud environment – all in one go. Tear down just as easily – perfect for rapid development and experimentation.


## Features

This mini-project provides a powerful yet easy-to-use development environment for Kubernetes on your local machine:

* Effortless cluster provisioning and teardown: Leverages Terraform and the [Minikube provider](https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs) for seamless cluster management.
* Pre-configured observability: Get insights into your deployments with a ready-made Grafana dashboard showing resource usage and requests. Uses Grafana Terraform [provider](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard)
* Seamless service exposition: Two sample deployments are exposed using an ingress resource, accessible at /foo and /bar paths.
* Modular and customizable: Built with Minikube and Docker, but configurable to fit your preferences.
* Load testing: Simulate real-world traffic with k6, ensuring your services are ready for the load.
* CI/CD ready: Simulated pipeline using [Taskfile](https://taskfile.dev/) demonstrates real-world deployment workflows.



## Pre-requisite

Before you dive in, make sure the following tools are set up and ready to go: minikube needs to spin up clusters smoothly, and docker must handle container creation without a hitch. This automated setup relies on them playing their parts flawlessly.

### Easy Install
- `pkgx` - Follow the [installation](https://pkgx.sh/) instruction
    - Once you have the `pkgx` utility installed, you can install the other required files using:
    ```
    pkgx install minikube task jq k6 git
    ```
- `Docker Engine` - Follow the [installation](https://docs.docker.com/engine/install/) instruction. Make sure the Docker daemon is also available to the user running the commands w/o sudo.


### Install Manually

If the easy install doesn't work for some reason, install it manually

- `Taskfile` - Follow the [installation](https://taskfile.dev/installation/) instruction
- `Minikube` - Follow the [installation](https://minikube.sigs.k8s.io/docs/start/) instruction
- `kubectl` - Follow the [installation](https://kubernetes.io/docs/tasks/tools/) instruction
- `jq` - Follow the [installation](https://jqlang.github.io/jq/download/) instruction
- `k6` - Follow the [installation](https://k6.io/docs/get-started/installation/) instruction
- `git` - 



## Usage

Convention: Any text formatted as `like this` is a command that will need to be run.


* Clone the repo: `git clone https://github.com/kramfs/prom-minikube-aio`
* Enter the repo folder: `cd prom-minikube-aio`
* Typing `task` will output the available tasks pipelines to run. The `task` utility looks for a `taskfile.yaml` in the root directory.

* Create the cluster: `task up`
    - This will create a multi-node minikube cluster
    - Using Helm, install and configure the kube-prometheus-stack, ingress-nginx and metallb. The values for each chart are located in the `helm_values` folder
    - Deploy our test backend service, `foo` and `bar` deployment. This includes configuring the ingresses and servicemonitors
    - Setup a sample grafana dashboard that will monitor the average requests/cpu/memory metrics

        ```
        Minikube with the docker driver uses the default `192.168.49.0/24` subnet
        for its networking requirements. This will utilize the `192.168.49.50 - 60`
        range for use by metallb for Load Balancing purpose.
        ```

* Since we are using private domain name (`dev.internal`), add the following to /etc/hosts for DNS resolution to work. This is also required so we have metrics per ingress:
    - Edit host file `sudo vi /etc/hosts`, add/append the following and save it:
        ```
            192.168.49.50   grafana.dev.internal
            192.168.49.50   prometheus.dev.internal
            192.168.49.50   echo.dev.internal
        ```

* Check the ingress for `/foo` and `/bar` is accessible: `task ingress-check`
* Run the benchmark/loadtest: `task loadtest`
* Check metrics using PromQL: `task prom-query`

* The resource average dashboard is accessible via
  - https://grafana.dev.internal/d/resource-avg/resource-average
  - Grafana login uses the default helm operator value: `admin/prom-operator`

* To manually check the ingress: 
  - `/foo` : http://echo.dev.internal/foo 
  - `/bar` : http://echo.dev.internal/bar

* To tear down the whole setup and clean up the state files: `task cleanup`

#
In summary:

- `task up`
- `task ingress-check`
- `task loadtest`
- `task prom-query`
- `task cleanup`

#