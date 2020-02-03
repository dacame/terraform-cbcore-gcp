# Packer template to create an image with CloudBees Jenkins Distribution

You need to create the image first in order to be able to create the instance template for GKE:
1. [Install Packer](https://www.packer.io/intro/getting-started/install.html)
2. Validate the template:
   ```bash
   packer validate client-master.json
   ```
3. Build the image in GKE:
   ```bash
   packer build -var gcloud_account_json="<path_to_your_private_key_json_file" -var gcloud_project_id="your_GCP_project"  client-master.json
   ```

Now you should be able to run this [Terraform repo](../README.md) with the parameter `image=true` 