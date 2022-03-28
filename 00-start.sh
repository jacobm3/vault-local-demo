#!/bin/bash

# Clean any existing environment/processes
while [ "$(pgrep vault)" ]; do
  pkill vault
  sleep 0.5
done

export VAULT_ADDR=http://127.0.0.1:8200
echo
echo export VAULT_ADDR=http://127.0.0.1:8200
echo unset VAULT_TOKEN
echo
rm -f ~/.vault-token



#vault server -dev -dev-root-token-id=root 

sleep 1 

vault login root

vault audit enable file file_path=audit hmac_accessor=false

curl  -H "X-Vault-Token: $(cat ~/.vault-token)" localhost:8200/v1/sys/metrics | head 

vault status

