#!/bin/bash -x 

vault secrets enable transit

vault write -f transit/keys/orders

# set exportable
vault write transit/keys/orders/config exportable=true

# export 
vault read -format=json transit/export/encryption-key/orders | jq '.data.keys'

# set allow_plaintext_backup=true
vault write transit/keys/orders/config allow_plaintext_backup=true

# export 
vault read -format=json transit/export/encryption-key/orders | jq '.data.keys'

# set allow_plaintext_backup=false
vault write transit/keys/orders/config allow_plaintext_backup=false

# export 
vault read -format=json transit/export/encryption-key/orders | jq '.data.keys'

