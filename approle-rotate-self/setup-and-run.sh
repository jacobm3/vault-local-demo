vault auth enable approle
vault write auth/approle/role/jenkins token_policies="rotate-my-secret-id" \
    token_ttl=1h token_max_ttl=4h
vault read auth/approle/role/jenkins/role-id
vault write -force auth/approle/role/jenkins/secret-id
vault read auth/approle/role/jenkins

# substitute your correct approle mount accessor (vault auth list)
vault policy write rotate-my-secret-id - << EOF
path "auth/approle/role/{{identity.entity.aliases.<auth_approle_51dba4f3>.metadata.role_name}}/secret-id" {
  capabilities = [ "read","create","update","delete","list","sudo" ]
}
EOF

vault policy write rotate-own-secret-id - << EOF

EOF

# Capture role ID and secret ID, update for login command below.
vault write auth/approle/login role_id="ec3ca7b8-50fc-8437-79c3-dd0f1cedb5f8" \
    secret_id="753128db-ec89-dd54-2d67-148a8b740958"

vault write -force auth/approle/role/jenkins/secret-id

