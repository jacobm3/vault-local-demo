
vault policy write policy1 - << EOF
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF

vault auth enable cert
vault write auth/cert/certs/app1 \
    display_name=app1 \
    policies=policy1 \
    certificate=@app1.crt \
    ttl=3600
