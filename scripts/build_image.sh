 #!/bin/sh

az acr build --registry $AZURE_CONTAINER_REGISTRY_NAME --image $AZURE_CONTAINER_REGISTRY_NAME.azurecr.io/ragapp:latest --file app/Dockerfile ./app/.