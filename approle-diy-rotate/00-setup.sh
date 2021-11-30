vault auth enable approle
vault write auth/approle/role/jenkins token_policies="rotate-my-secret-id" \
    token_ttl=1h token_max_ttl=4h
vault read auth/approle/role/jenkins/role-id
vault write -force auth/approle/role/jenkins/secret-id
vault read auth/approle/role/jenkins

vault policy write rotate-my-secret-id - << EOF

path "auth/approle/role/{{identity.entity.metadata.role_name}}/secret-id" {
  capabilities = [ "update" ]
}

EOF


