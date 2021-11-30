vault write auth/approle/login role_id="ec3ca7b8-50fc-8437-79c3-dd0f1cedb5f8" \
    secret_id="753128db-ec89-dd54-2d67-148a8b740958"

vault write -force auth/approle/role/jenkins/secret-id

