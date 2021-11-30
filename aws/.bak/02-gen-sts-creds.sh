echo 'vault read aws/creds/my-sts-role'
vault read -format=json aws/creds/my-sts-role  | jq
