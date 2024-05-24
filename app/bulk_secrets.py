import csv
import azure.keyvault.secrets
from azure.identity import ClientSecretCredential
from dotenv import load_dotenv
import os

class KeyVaultSecretManager:
    @staticmethod
    def add_secrets_from_csv(tenant_id, client_id, client_secret, vault_url, csv_file_path):
        credential = ClientSecretCredential(
            tenant_id=tenant_id,
            client_id=client_id,
            client_secret=client_secret
        )
        client = azure.keyvault.secrets.SecretClient(
            vault_url=vault_url,
            credential=credential
        )
        
        # print current path that this python file is running
        print(f"Current path: {os.getcwd()}")
        
        with open(csv_file_path, "r") as file:
            secrets_list = list(csv.DictReader(file))
        for secret in secrets_list:
            # Skip adding if secret_value is empty
            if not secret["secret_value"]:
                continue
            client.set_secret(secret["secret_name"], secret["secret_value"])

if __name__ == "__main__":
    load_dotenv()
    
    tenant_id = os.getenv("TENANT_ID")
    client_id = os.getenv("CLIENT_ID")
    client_secret = os.getenv("CLIENT_SECRET")
    
    vault_url = "https://<keyvault-name>.vault.azure.net"
    csv_file_path = "secrets.csv"

    KeyVaultSecretManager.add_secrets_from_csv(tenant_id, client_id, client_secret, vault_url, csv_file_path)