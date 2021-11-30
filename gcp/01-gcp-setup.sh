vault secrets enable gcp

vault write gcp/config credentials=@YOUR-GCP-CRED-FILE.json \
    ttl=30 max_ttl=60

vault write gcp/roleset/token-role-set \
    project="gcp-vault-demo-235001" \
    secret_type="access_token" \
    token_scopes="https://www.googleapis.com/auth/cloud-platform" \
    bindings=-<<EOF
resource "//storage.googleapis.com/buckets/vault-bucket-322" {
roles = ["roles/roles/storage.objectViewer"],
}
EOF

