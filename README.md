# Deploying a Hybrid CloudBees Core on GKE with Terraform

The content of this repo shows all configuration needed to provision infrastructure and deploy CloudBees Core on GCP (GKE and GCE) using [Terraform](https://terraform.io). In this repo you will find different `.tf` scripts, folders and other sources which contains the following:
* [Packer]() image creation definition (`client-master.json`) to provide a GCP image with CloudBees Core Client Master instance installed
* Terraform module (`module.gke_cluster`) to create GKE cluster where [CloudBees Core]() and the [Operations Center]() will be deployed
* Terraform module (`module.client_masters`) to create GCP resources to provision [Client Master]() instances
* Terraform module to create Kubernetes resources, like required namespaces for CloudBees Core components and NGINX Ingress controller requirements (Tiller `serviceAccount` and `roleBindings`)
* Terraform module (`module.helm`) to install helm charts to deploy [NGINX Ingress controller]() and [CloudBees Core for modern platforms]()
* Terraform scripts to provision and deploy everything according to parameters and configurations

The workflow and architecture of the Terraform project can be shown in the following picture

![TFImage](./Terraform_CB-Core.png)

## Structure of this repo

All resources needed to deploy the Terraform project are structured like this:

```
cloudbees-core (folder with main Terraform project)
|__ main.tf (Terraform script to deploy)
|__ out.tf (Outputs parameters to be shown at the end)
|__ providers.tf (Providers used in main deployment)
|__ vars.tf (Default parameters values to use)

modules (folder with Terraform modules used by project)
|
|__ gcp_cm (module to create Master Client VMs on GCP)
|   |__ main.tf (Terraform definition of the module)
|   |__ outputs.tf (output values of the module)
|   |__ variables.tf (input parameters of the module)
|
|__ gke-cjoc_mm (module to create GKE cluster for CloudBees Core)
|   |__ main.tf (Terraform definition of the module)
|   |__ outputs.tf (output values of the module)
|   |__ variables.tf (input parameters of the module)
|
|__ helm (module to install CloudBees Core and NGINX ingress controller by using Helm)
|   |__ main.tf (Terraform definition of the module)
|   |__ variables.tf (input parameters of the module)
|
|__ k8s (module to configure Kubernetes cluster)
|   |__ main.tf (Terraform definition of the module)
|   |__ outputs.tf (output values of the module)
|   |__ variables.tf (input parameters of the module)
|
|__ Packer (folder with the Packer definition for a Clien Master image)
    |__ client-master.json (Packer file with image build definition)
    |__ README.md (guide to use Packer to build and publish the image in GCP)
    |__ update-cm.sh (script used by Packer to install Cliente Master in the image)
```

## Requirements

To use this Terraform project, you will need the following:

* [Terraform](https://www.terraform.io/downloads.html) (version 0.12+)
* [Packer]()
* [JSON key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-console) from your GCP service account.
  
    ```bash
    gcloud iam service-accounts keys create ~/key.json \
  --iam-account [SA-NAME]@[PROJECT-ID].iam.gserviceaccount.com
  ```
* Access to internet and permissions withing your GCP project to create GKE clusters and VMs

## Uploading the CloudBees Core Client Master image

A CloudBees Core Client Master is a Jenkins Master running on a VM that can be connected to the CloudBees Core Operations Center. This Terraform project creates a VM in Google Compute Engine with the Client Master installed based on an image uploaded to GCP.

Yoy can create and upload the required image using the Packer configuration file included in this repo by using the following [these instructions](./Packer/README.md).

## Deploying CloudBees Core

To deploy CloudBees Core platform using Terraform, this project has defined different input parameters:

* `project`. This is the GCP project where all resources (K8s cluster, VMs, etc.) are going to be created.
* `gcp-region`. The GCP region to deploy.
* `gcp-zone`. The GCP zone.
* `numnodes`. Number of initial nodes for your GKE cluster (cluster is configured for autoscaling 3-6)
* `credentials`. Your credentials key JSON file path for your GCP service account.
* `image`. Parameter to use VMs images if deploying Client Masters (set it to `true` if you want to deploy a CloudBees Core Client Master)
`cjoc_host`. Hostname with domain for your Operations Center (e.g. `cjoc.mydomain.com`). If not set, it will configure your cluster with a `*.nip.io` domain.

> NOTE: The parameters `gcp-region` and `gcp-zone` are only used as variables to connect with the [Terraform Google provider](https://www.terraform.io/docs/providers/google/index.html), but not parametrized in the modules input in `main.tf` file of the Terraform definition. So, if you want to deploy to your own GCP zone and region, you need to change the values at `cloudbees-core > main.tf`, which are currently harcoded to `europe-west1-c` zone. *This will change, as this repo is a work in progress*

### Initialize Terraform with your backend

In this repo you are supposed to use [Terraform Google Cloud Storage backend](https://www.terraform.io/docs/backends/types/gcs.html) to persist your Terraform state. So, to initiate the project, just execute:

```bash
terraform init -backend-config="bucket=<your_gcs_bucket>" -backend-config="prefix=<your_bucket_folder>" -backend-config="credentials=<your_json_file_credentials>"
```
