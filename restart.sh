#!/bin/bash

# Clean any existing environment/processes
while [ "$(pgrep vault)" ]; do
  sudo pkill vault
  sleep 0.5
done

export VAULT_SKIP_VERIFY=1
export VAULT_ADDR=https://localhost.theneutral.zone:8200
echo
echo export VAULT_ADDR=https://localhost.theneutral.zone:8200
echo unset VAULT_TOKEN VAULT_NAMESPACE
echo
rm -f ~/.vault-token 

vault server -config=vault.hcl >vault.log 2>vault.err &

sleep 1 

vault operator unseal $(jq -r .unseal_keys_b64[0] < .init.json)
vault login $(jq -r .root_token < .init.json)
vault status

