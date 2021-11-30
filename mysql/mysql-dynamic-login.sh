json=`vault read -format=json database/creds/db1-5s`
echo $json | jq 
user=`echo $json | jq -r .data.username`

echo "mysql -A -u${user} -p db1"

mysql -A -u${user} -p db1
