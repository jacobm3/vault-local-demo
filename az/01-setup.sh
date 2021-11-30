vault secrets enable azure

vault write azure/config \
subscription_id=$ARM_SUBSCRIPTION_ID \
tenant_id=$ARM_TENANT_ID \
client_id=$ARM_CLIENT_ID \
client_secret=$ARM_CLIENT_SECRET

vault write azure/roles/my-role ttl=20s azure_roles=-<<EOF
    [
        {
            "role_name": "Reader",
            "scope":  "/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/vault-demo"
        }
    ]
EOF
