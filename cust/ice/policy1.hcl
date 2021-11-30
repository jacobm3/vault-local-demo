path "secret/" {
  capabilities = ["list"]
}

 

path "secret/group1/*" {

  capabilities = ["deny"]

}

 

path "secret/group2/*" {

  capabilities = ["read","list"]

}


