vault policy write sudo-admin - <<EOF

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

EOF

 vault auth enable userpass
 vault write auth/userpass/users/jacob \
    password=foo \
    policies=db1,sudo-admin
 vault write auth/userpass/users/john \
    password=foo \
    policies=db1
 vault write auth/userpass/users/bill \
    password=foo \
    policies=db1
