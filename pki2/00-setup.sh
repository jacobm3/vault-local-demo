vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal \
        common_name="acer.local" \
        ttl=87600h > acer.local.ca.crt
vault write pki/config/urls \
        issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \
        crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"
vault secrets enable -path=pki pki
vault secrets tune -max-lease-ttl=43800h pki


