#!/bin/bash

# export VAULT_LICENSE=... 

# Clean any existing environment/processes
sudo pkill vault
sleep 0.5
sudo pkill -9 vault
#export VAULT_LOG_FORMAT=json
export VAULT_ADDR=http://127.0.0.1:8200
echo export VAULT_ADDR=http://127.0.0.1:8200
unset VAULT_TOKEN
rm -f ~/.vault-token 

export VAULT_LOG_LEVEL=debug

# State Vault server in dev mode
mkdir -p log
vault server -dev -dev-root-token-id=root -config=vault.hcl \
    >vault.log 2>vault.err &

#vault server -dev -dev-root-token-id=root 

sleep 1 

vault login root

vault audit enable file file_path=audit

curl  -H "X-Vault-Token: $(cat ~/.vault-token)" localhost:8200/v1/sys/metrics | head 

vault status

