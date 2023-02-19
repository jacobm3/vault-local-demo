#!/bin/bash -x 

set -e

. config.env

# Danger
vault secrets disable $PKIPATH

vault secrets enable -path=$PKIPATH pki

vault secrets tune -max-lease-ttl=87600h $PKIPATH

vault write ${PKIPATH}/root/generate/internal \
  common_name=$ROOTCN \
  ttl=87600h > ${ROOTCN}.ca.crt

# import the issuing CA cert into Windows like this from an admin powershell - 
# PS C:\users\jacob>  certutil -addstore -enterprise -f "CA" test-ca.pem

vault write ${PKIPATH}/config/urls \
    issuing_certificates="http://localhost:8200/v1/${PKIPATH}/ca" \
    crl_distribution_points="http://localhost:8200/v1/${PKIPATH}/crl" 

vault write ${PKIPATH}/roles/astro.local \
    allowed_domains=astro.local \
    allowed_localhost=true \
    allow_bare_domains=true \
    allow_glob_domains=true \
    allow_subdomains=true \
    max_ttl=87600h \
    key_bits=4096


#vault write ${PKIPATH}/issue/astro.local \
#    common_name=astro.local \
#    alt_names=*.astro.local \
#    ttl=87600h 


