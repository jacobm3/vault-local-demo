#!/bin/bash -x 

# vault secrets enable -version=2 -path=secret kv

vault kv put secret/hello foo=world excited=yes

vault kv put secret/goodbye foo="cruel world" excited=no

vault kv put secret/jmartinson first=Jacob last=Martinson SSN=123-45-1877

vault kv put secret/app1/db-conn-str str="mysql://user@db5.internal:3306?get-server-public-key=true" team="na-devops" environment="test"
vault kv metadata put -custom-metadata team="south" secret/app1/db-conn-str


