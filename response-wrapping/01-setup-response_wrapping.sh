#!/bin/bash


vault policy write apps apps-policy.hcl

vault kv put secret/dev apikey="API-S00p3rS3kre3t"

vault token create -policy=apps -wrap-ttl=360 -format=json | jq -r ".wrap_info.token" > .wrap-token

vault token lookup `cat .wrap-token`
vault unwrap `cat .wrap-token`

# vault unwrap -format=json $(.wrap-token) | jq -r ".auth.client_token" > .client-token
# vault login `cat client-token`

vault kv get secret/dev

# Up to this point, it's basically been secure introduction (token). 
# More functionality below:

