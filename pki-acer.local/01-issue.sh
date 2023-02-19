#!/bin/bash

. config.env

vault write ${PKIPATH}/issue/astro.local \
    common_name=astro.local \
    alt_names=*.astro.local \
    ttl=7600h \
    format=pem_bundle > astro.local.pem


