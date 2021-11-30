vault secrets enable kmip
vault write kmip/config listen_addrs=0.0.0.0:5696
vault read kmip/config
vault write kmip/config listen_addrs=0.0.0.0:5696 \
      tls_ca_key_type="rsa" \
      tls_ca_key_bits=2048

vault write -f kmip/scope/finance
vault write kmip/scope/finance/role/accounting operation_all=true
vault read kmip/scope/finance/role/accounting

vault write -format=json \
    kmip/scope/finance/role/accounting/credential/generate \
    format=pem 

