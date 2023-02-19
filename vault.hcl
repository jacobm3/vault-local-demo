listener "tcp" {
  address = "0.0.0.0:8200"
  #tls_cert_file = "tls.crt"
  #tls_key_file  = "tls.key"
  tls_disable = true
}

storage "file" {
  path = "data"
}

license_path = "/home/ubuntu/.vault-license"
disable_mlock = true
log_level = "debug"
ui = true

