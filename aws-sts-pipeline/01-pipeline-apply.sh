HOST=app.terraform.io
ORG=jacobm3
WS=sts
VAULT_ADDR=http://127.0.0.1:8200


echo "Reading new AWS credentials from Vault:"
json=`vault read -format=json aws/creds/s3-sts-role`

# Print result
echo $json | jq; echo; 

# Parse into env vars
access_key=`echo $json | jq -r .data.access_key`
secret_key=`echo $json | jq -r .data.secret_key`
token=`echo $json | jq -r .data.security_token`


# TFE configuration
echo; echo; echo "Creating workspace"
tfe workspace create -tfe-address $HOST -tfe-org $ORG -tfe-workspace $WS 

echo; echo; echo "Pushing credentials to $HOST"
tfe pushvars -dry-run false -overwrite-all true -name ${ORG}/${WS} \
 -tfe-address $HOST \
 -env-var "AWS_ACCESS_KEY_ID=${access_key}" \
 -senv-var "AWS_SECRET_ACCESS_KEY=${secret_key}" \
 -senv-var "AWS_SESSION_TOKEN=${token}" \
 -env-var "CONFIRM_DESTROY=1"

echo; echo
set -x 

terraform init && terraform apply -auto-approve
