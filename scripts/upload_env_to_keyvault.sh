#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <KEYVAULT_NAME> <ENV_FILE>"
  exit 1
fi

# Variables
KEYVAULT_NAME=$1
ENV_FILE=$2

# Read .env file and upload each variable to Azure Key Vault
while IFS= read -r line
do
    if [[ ! -z "$line" && "$line" != \#* ]]; then
        IFS='=' read -r key value <<< "$line"
        if [[ -n "$value" && "$value" != "" ]]; then
            value=${value//\"/}
            echo $$KEYVAULT_NAME $key $value
            az keyvault secret set --vault-name "https://$KEYVAULT_NAME.vault.azure.net" --name $key --value $value
        fi
    fi
done < "$ENV_FILE"