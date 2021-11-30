echo "Starting mysql"
sudo service mysql start

echo "Setting up vault's grant in mysql"
# generate random mysql passwd for vault acct
passwd=`openssl rand -base64 12 | base32 | cut -b -24`
echo $passwd > .mysql-vault-passwd

sudo mysql -uroot <<EOF
DROP DATABASE IF EXISTS db1;
CREATE DATABASE db1;
GRANT ALL ON *.* to 'vault'@'localhost' IDENTIFIED BY "$passwd";
GRANT GRANT OPTION ON *.* to 'vault'@'localhost';
FLUSH PRIVILEGES;

USE db1;
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    status TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    PRIMARY KEY (task_id)
)  ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS users (
    task_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    status TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    PRIMARY KEY (task_id)
)  ENGINE=INNODB;
EOF

echo "Enabling database secrets engine"
vault secrets enable database

echo "Writing db1 DB secrets engine config"
mysqlpass=`cat .mysql-vault-passwd`
vault write database/config/db1 \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(127.0.0.1:3306)/" \
    allowed_roles="db1-5s,db1-30s" \
    username="vault" \
    password="$mysqlpass"

echo "Writing DB1 5s engine role" 
vault write database/roles/db1-5s \
    db_name=db1 \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON db1.* TO '{{name}}'@'%';" \
    default_ttl="5s" \
    max_ttl="5s"

echo "Writing DB1 30s engine role" 
vault write database/roles/db1-30s \
    db_name=db1 \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON db1.* TO '{{name}}'@'%';" \
    default_ttl="30s" \
    max_ttl="30s"

echo "Writing db1 policy"

vault policy write db1 -<<EOF
path "database/creds/db1-5s" {
  capabilities = ["read"]
}
path "database/creds/db1-30s" {
  capabilities = ["read"]
}
EOF

