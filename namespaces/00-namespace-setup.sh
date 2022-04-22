#!/bin/bash

set -e
set -x

vault namespace create poc

export VAULT_NAMESPACE=poc

vault policy write sudo-admin - <<EOF

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

EOF

vault policy write admin - <<EOF

path "*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

EOF

vault auth enable userpass

#vault write auth/userpass/users/sudo-admin password=$(openssl rand -base64 12) policies=namespace-admin

vault write auth/userpass/users/sudo-admin password=asdf policies=sudo-admin
vault write auth/userpass/users/admin password=asdf policies=admin

