
vault auth enable approle

vault auth tune \
  -audit-non-hmac-response-keys=secret_id_accessor \
  approle



vault write auth/approle/role/jenkins token_policies="jenkins" \
    token_ttl=1h token_max_ttl=4h

vault read -format=json auth/approle/role/jenkins/role-id > role-id.json
vault write -format=json -force auth/approle/role/jenkins/secret-id > secret-id.json

jq -r .data.role_id < role-id.json > role-id
jq -r .data.secret_id < secret-id.json > secret-id

vault read auth/approle/role/jenkins

vault policy write jenkins - << EOF

path "secret/*" {
  capabilities = [ "read", "update", "list", "delete" ]
}

path "auth/approle/role/{{identity.entity.metadata.role_name}}/secret-id" {
  capabilities = [ "update" ]
}

EOF


