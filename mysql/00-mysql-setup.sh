#!/bin/bash 

#echo "Starting mysql"
#sudo service mysql start

echo "Setting up vault's grant in mysql"
# generate random mysql passwd for vault acct
#passwd=`openssl rand -base64 12 | base32 | cut -b -24`
#echo $passwd > .mysql-vault-passwd

mysql -uroot -proot <<EOF
DROP DATABASE IF EXISTS db1;
CREATE DATABASE db1;

use mysql;
DROP USER 'vault'@'%';
CREATE USER 'vault'@'%' IDENTIFIED BY 'vaultpass';
GRANT SUPER ON *.* to 'vault'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "Creating db1 database"
mysql -uroot -proot <<EOF
create database if not exists db1;
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

create database if not exists db3;
USE db3;
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
vault secrets disable database
vault secrets enable database

echo "Writing db1 DB secrets engine config"
vault write database/config/db1 \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(127.0.0.1:3306)/" \
    allowed_roles="db1-5s,db1-30s" \
    username="root" \
    password="root"

echo "Writing DB1 5s engine role" 
vault write database/roles/db1-5s \
    db_name=db1 \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON db1.* TO '{{name}}'@'%';" \
    default_ttl="5s" \
    max_ttl="5s"

echo "Writing db1 policy"

vault policy write db1 -<<EOF
path "database/creds/db1-5s" {
  capabilities = ["read"]
}
EOF


echo "Writing db3 DB secrets engine config"
vault write database/config/db3 \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(127.0.0.1:3306)/" \
    allowed_roles="db3-5s,db3-30s" \
    username="root" \
    password="root"

echo "Writing DB3 5s engine role" 
vault write database/roles/db3-5s \
    db_name=db3 \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL ON db3.* TO '{{name}}'@'%';" \
    default_ttl="5s" \
    max_ttl="5s"

echo "Writing db3 policy"

vault policy write db3 -<<EOF
path "database/creds/db3-5s" {
  capabilities = ["read"]
}
EOF

