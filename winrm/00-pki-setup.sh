vault secrets disable pki &>/dev/null

vault secrets enable pki

vault secrets tune -max-lease-ttl=87600h pki

vault write pki/root/generate/internal common_name=hashicorp.com ttl=87600h 

vault write pki/config/urls \
    issuing_certificates="http://vault.hashicorp.com:8200/v1/pki/ca" \
    crl_distribution_points="http://vault.hashicorp.com:8200/v1/pki/crl"

vault write pki/roles/hashicorp-test-dot-com \
    allowed_domains=hashicorp-test.com \
    allow_bare_domains=true \
    allow_subdomains=true max_ttl=72h \
    allowed_other_sans="2.5.29.17;UTF8:upn=jmartinson@hashicorp.com" \
    key_bits=4096

    #allowed_other_sans="2.5.29.17;UTF8:jmartinson@hashicorp.com,2.5.29.37;UTF8:*" \

vault write pki/issue/hashicorp-test-dot-com \
    other_sans="2.5.29.17;UTF8:upn=jmartinson@hashicorp.com"\
    common_name=app1.hashicorp-test.com \
    format=pem_bundle > crt

certtool --infile=crt -i | egrep 'Subject Alternative Name|otherName|DNSname'

