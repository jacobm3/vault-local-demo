unset AWS_SESSION_TOKEN

echo 'aws ec2 describe-instances --filters "Name=tag:owner, Values=jmartinson*"'
aws ec2 describe-instances --filters "Name=tag:owner, Values=jmartinson*" 2>&1 | jq -C . | head -30
