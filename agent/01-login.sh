#!/bin/bash
roleid=$(cat role-id.json | jq -r .data.role_id)
secretid=$(cat secret-id.json | jq -r .data.secret_id)
vault write auth/approle/login role_id="$roleid" \
    secret_id="$secretid"

#vault write -force auth/approle/role/jenkins/secret-id

