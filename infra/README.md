# Infrastructure

Prerequisites:
- Google Cloud CLI
- Terraform CLI, [tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)

Basic workflow:

1. Authorize `gcloud` against this project

2. Work with Terraform 

    ```sh
    cd infra
    terrafrom init
    
    # do changes in *.tf

    terraform plan
    terraform apply
    ```


## Terraform state

Terraform state is stored in GCP bucket as a remote backend. GCP bucket is located in the same project as the managed resources. 
Generic procedure below. For convenience use [setup-state.sh](./setup-state.sh)

1. Create bucket
    ```shell
    gcloud storage buckets create gs://YOUR_BUCKET_NAME \
      --project=YOUR_PROJECT_ID \
      --location=YOUR_REGION \
      --uniform-bucket-level-access
    ```

2. Enable versioning
    ```shell
    gcloud storage buckets update gs://YOUR_BUCKET_NAME \
      --versioning
    ```

3. Configure bucket in backend in Terraform
    ```hcl
    terraform {
      backend "gcs" {
        bucket  = "YOUR_BUCKET_NAME"
        prefix  = "terraform/state"   # path inside the bucket
      }
    }
    ```

4. Initialize
    ```shell
    terraform init
    ```
