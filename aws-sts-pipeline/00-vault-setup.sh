vault namespace create jenkins-001

export VAULT_NAMESPACE=jenkins-001

vault secrets enable aws

vault write aws/config/root \
    access_key=${AWS_ACCESS_KEY_ID} \
    secret_key=${AWS_SECRET_ACCESS_KEY} \
    region=us-east-1

vault write aws/roles/s3-sts-role \
    credential_type=federation_token \
    ttl=900s \
    policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF


