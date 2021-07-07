echo 'vault read aws/creds/my-iam-role'

# Read sts token
json=`vault read -format=json aws/creds/my-iam-role`

# Print result
echo $json | jq

# Parse into env vars
access_key=`echo $json | jq -r .data.access_key`
secret_key=`echo $json | jq -r .data.secret_key`

echo
echo Paste this into your terminal to use:
echo
echo export HISTIGNORE=\"history*:export*\"
echo export AWS_ACCESS_KEY_ID=${access_key}
echo export AWS_SECRET_ACCESS_KEY=${secret_key}
echo

