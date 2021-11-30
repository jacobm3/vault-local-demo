echo "Enabling approle"
vault auth enable approle  

echo "Writing approle role"
vault write auth/approle/role/db1 \
    policies="db1" \
    secret_id_ttl=24h \
    token_num_uses=5000 \
    token_ttl=60s \
    token_max_ttl=300s \
    secret_id_num_uses=5000

echo "Saving role-id and secret-id for Vault Agent"
vault read -format=json auth/approle/role/db1/role-id | \
    jq -r .data.role_id > .role-id

vault write -format=json -f auth/approle/role/db1/secret-id | \
    jq -r .data.secret_id > .secret-id

vault agent -config=agent.hcl

