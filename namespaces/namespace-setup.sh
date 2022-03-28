#!/bin/bash

set -e
set -x

vault namespace create poc

export VAULT_NAMESPACE=poc

vault policy write namespace-admin - <<EOF

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

EOF

vault auth enable userpass

vault write auth/userpass/users/john.doe password=$(openssl rand -base64 12) policies=namespace-admin

