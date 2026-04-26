# Infrastructure

Prerequisites:
- Google Cloud CLI
- Terraform CLI, [tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)

Basic workflow:

1. Authorize `gcloud` against this project

2. Enable APIs in `gcloud`

    ```sh
    gcloud services enable servicenetworking.googleapis.com \
                            vpcaccess.googleapis.com \
                            redis.googleapis.com \
      --project=PROJECT_ID
    ```

3. Create `terraform.tfvars`

    Create a file named `terraform.tfvars` in the [infra folder](/infra/) of the project and define the required variables:
    ```hcp
    project_id   = "PROJECT_ID"
    db_password  = "DB_PASSWORD" 
    ```

4. Work with Terraform 

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
    gcloud storage buckets create gs://BUCKET_NAME \
      --project=PROJECT_ID \
      --location=REGION \
      --uniform-bucket-level-access
    ```

2. Enable versioning
    ```shell
    gcloud storage buckets update gs://BUCKET_NAME \
      --versioning
    ```

3. Configure bucket in backend in Terraform
    ```hcl
    terraform {
      backend "gcs" {
        bucket  = "BUCKET_NAME"
        prefix  = "terraform/state"   # path inside the bucket
      }
    }
    ```

4. Initialize
    ```shell
    terraform init
    ```
