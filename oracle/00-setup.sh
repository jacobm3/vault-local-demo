
file=/usr/local/lib/vault-plugin-database-oracle

sudo setcap cap_ipc_lock=+ep $file

vault secrets enable database

vault write sys/plugins/catalog/database/vault-plugin-database-oracle \
  sha_256="$(shasum -a 256 $file | cut -f1 -d' ')" \
  command="vault-plugin-database-oracle"

vault write database/config/oracle plugin_name=vault-plugin-database-oracle \
    allowed_roles="*" \
    connection_url='{{username}}/{{password}}@//192.168.1.252:1521/oracle_service' \
    username='vaultadmin' \
    password='reallysecurepassword'

vault write -force database/rotate-root/oracle
