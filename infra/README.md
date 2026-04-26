# Infrastructure

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
initialize
```shell
terraform init
```
done
