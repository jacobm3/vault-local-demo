 vault auth enable userpass
 vault write auth/userpass/users/jacob \
    password=foo \
    policies=db1
 vault write auth/userpass/users/john \
    password=foo \
    policies=db1
 vault write auth/userpass/users/bill \
    password=foo \
    policies=db1
