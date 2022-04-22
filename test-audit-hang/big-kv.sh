#!/bin/bash -x 

vault secrets enable -path=secret kv &>/dev/null
vault kv put secret/big foo=@1MB.md
vault kv put secret/big foo=@1MB.md

