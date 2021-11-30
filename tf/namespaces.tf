resource "vault_namespace" "ns1" {
  path = "ns1"
}

resource "vault_namespace" "ns1-ns2" {
  path = "ns1/ns2"
}


