#!/bin/bash

# Variables
ENV_FILE="./.azure/$AZURE_ENV_NAME/.env"
SECRET_NAME="my-secret"
NAMESPACE="app"

# Create the header for the Kubernetes Secret YAML file
echo "apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $NAMESPACE
type: Opaque
data:" > ./manifests/secret.yaml

# Read .env file and append each variable to the YAML file
while IFS= read -r line
do
    if [[ ! -z "$line" && "$line" != \#* ]]; then
        IFS='=' read -r key value <<< "$line"
        # Remove double quotes from value
        key=${key//_/-}
        value=${value//\"/}
        # Encode the value in base64
        if [[ -n "$value" ]]; then
            # Encode the value in base64
            encoded_value=$(echo -n "$value" | base64)
            # Append to the YAML file
            echo "  $key: $encoded_value" >> ./manifests/secret.yaml
        fi       
    fi
done < "$ENV_FILE"

# Apply the Secret to the Kubernetes cluster
# kubectl apply -f secret.yaml