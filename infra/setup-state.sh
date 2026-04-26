#!/bin/bash
set -e

PROJECT_ID=$1
REGION="europe-central2"
BUCKET=${PROJECT_ID}-tfstate

gcloud storage buckets create "gs://$BUCKET" \
  --project=$PROJECT_ID \
  --location=$REGION \
  --uniform-bucket-level-access


echo $BUCKET
