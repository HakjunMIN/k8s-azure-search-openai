# Forked repo ver. README

## Prerequisites
```bash
cd app
touch .env
```
- `.dev.env` 복사하여 `.env` 파일 생성
- `.env` 파일 내용 수정

## Running in local
```bash
cd app
source start-dev.sh
```

## Running as container in local
```bash
cd app
docker compose up
```

## Using KeyVault to store environment variable and use it in AKS

### 1. Create `env.csv` file by running `generate_csv.py`
This will create `secrets.csv` file.

### 2. Create service principal and grant permission to Key Vault.
```bash
az ad sp create-for-rbac --name <name> 
```
Grant `Key Vault Secrets Officer` role to the service principal.

### 3. Run `bulk_secrets.py` to upload secrets to Key Vault.
This will upload secrets defined in `secrets.csv` to Key Vault.

