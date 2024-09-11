# Azure openAI search demo running on K8S

본 프로젝트의 상세정보는 [Here](PROJECT_README.md)에서 확인할 수 있습니다.

## Quick Start

### login
```bash
az login
azd auth login
```
or in github codespace
```bash
 az login --tenant <tenant>--use-device-code
 azd auth login --tenant-id <tenant>  --use-device-code
```

### create a new environment and provision it
```bash
azd init -e <your-environment-name> -l <your-region>
azd provision

```

### deploy the app
```bash
azd deploy
```

```bash
azd env refresh
source <(azd env get-values)
```

>[!IMPORTANT]
>`.azure/<환경>/.env` 내 `AZURE_AUTH_TENANT_ID`와 `AZURE_TENANT_ID`가 있는 지 확인
> 없으면 `az account show --query tenantId -o tsv`로 값을 가져와서 넣어줄 것

### Pod에서 사용할 Workload Identity 생성


```bash
az aks update --resource-group "${AZURE_RESOURCE_GROUP}" --name "${AZURE_AKS_CLUSTER_NAME}" --enable-oidc-issuer --enable-workload-identity

USER_ASSIGNED_IDENTITY_NAME=workloadid

export AKS_OIDC_ISSUER="$(az aks show --name "${AZURE_AKS_CLUSTER_NAME}" --resource-group "${AZURE_RESOURCE_GROUP}" --query "oidcIssuerProfile.issuerUrl" --output tsv)"

az identity create --name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${AZURE_RESOURCE_GROUP}" --location "${AZURE_LOCATION}" --subscription "${AZURE_SUBSCRIPTION_ID}"

export USER_ASSIGNED_CLIENT_ID="$(az identity show --resource-group "${AZURE_RESOURCE_GROUP}" --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' --output tsv)"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${USER_ASSIGNED_CLIENT_ID}"
  name: "workload-sa"
  namespace: "app"
EOF

az identity federated-credential create --name fedid --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${AZURE_RESOURCE_GROUP}" --issuer "${AKS_OIDC_ISSUER}" --subject system:serviceaccount:app:workload-sa --audience api://AzureADTokenExchange

```
### 권한 할당
```bash
# Assign AI Developer role to USER_ASSIGNED_CLIENT_ID for Azure OpenAI Service
az role assignment create --assignee $USER_ASSIGNED_CLIENT_ID --role "Azure AI Developer" --scope $AZURE_OPENAI_SERVICE

# Assign Search Index Contributor role to USER_ASSIGNED_CLIENT_ID for Azure Search Service
az role assignment create --assignee $USER_ASSIGNED_CLIENT_ID --role "Search Index Data Contributor" --scope $AZURE_SEARCH_SERVICE

# Assign Storage Blob Data Contributor role to USER_ASSIGNED_CLIENT_ID for Azure Storage Account
az role assignment create --assignee $USER_ASSIGNED_CLIENT_ID --role "Storage Blob Data Contributor" --scope $AZURE_STORAGE_ACCOUNT
```

### 앱 배포
```bash
kubectl apply -f ./manifests/secret.yaml
sed -e "s|YOUR-REGISTRY|${AZURE_CONTAINER_REGISTRY_NAME}|g" ./manifests/app.yaml | kubectl apply -f -
```

### LB확인
```bash
kubectl get svc
```

### 테스트

https://<EXTERNAL-IP>