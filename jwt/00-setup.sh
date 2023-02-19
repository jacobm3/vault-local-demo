#!/bin/bash

vault auth enable jwt

vault write auth/jwt/config \
   jwt_validation_pubkeys="-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8ZLsU2uxiJ/mFUeMWlE7
WedaKn4wDJ3yqJteaBRnic4JnqJ2/HAqNbCtwgByXsgNb6AYnxQyT63jS2IBEXUF
+2MhNoCaBhnZILf7eLih6kMGf5iL9AS8jdLZdg/+p2T2teXWIYtPU8EWjJifH6KS
IohWdfXYqTgNP/ScdM32pfpTvTxqXRXiEm3s9f0QfUxSxy6CKN7A6Q8SojsObQ6a
mUK/RmamjI5+flEuB8VbEU2zX687PYZVebtE0f6dEkg2vqg0wjTq6hhvcM41g02k
MV1nEGIzWBKgaCcusGS3aQ6kv5CN317ea/pJ63L0xZRLAhUELT1uG/4kSZZeOXcu
hwIDAQAB
-----END PUBLIC KEY-----"


vault policy write jwt-demo - <<EOF
path "secret/*" {
  capabilities = ["read", "update", "list", "delete"]
}
EOF

vault write auth/jwt/role/jwt-demo \
   role_type="jwt" \
   bound_audiences="https://kubernetes.default.svc.cluster.local" \
   user_claim="sub" \
   bound_subject="system:serviceaccount:ns-demo:sa-demo" \
   policies="jwt-demo" \
   ttl="1h"

