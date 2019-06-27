# Clean any existing environment/processes
pkill vault
export VAULT_LOG_FORMAT=json
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200
unset VAULT_TOKEN
rm -f ~/.vault-token 


# State Vault server in dev mode
mkdir -p log
vault server -dev -dev-root-token-id=root \
    >log/vault.log 2>log/vault.err &

sleep 0.5

vault login root

vault audit enable file file_path=log/audit

