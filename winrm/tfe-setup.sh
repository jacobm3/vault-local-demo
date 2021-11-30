vault secrets enable pki

vault secrets tune -max-lease-ttl=87600h pki

vault write pki/root/generate/internal common_name=hashicorp.com ttl=87600h > CA_cert.crt

vault write pki/config/urls \
    issuing_certificates="http://vault.hashicorp.com:8200/v1/pki/ca" \
    crl_distribution_points="http://vault.hashicorp.com:8200/v1/pki/crl"

vault write pki/roles/tfe \
    allowed_domains=tfe.slackbase.io \
    allow_bare_domains=true \
    allow_subdomains=true max_ttl=8760h \
    key_bits=4096


vault write pki/issue/tfe \
    common_name=tfe.slackbase.io \
    format=pem_bundle > tfe.slackbase.io.pem


