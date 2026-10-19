ui = true
disable_mlock = true
storage "file" {
  path = "/vault/file"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}
api_addr = "http://127.0.0.1:8200"
# Localhost-only development bootstrap. Use TLS and durable external storage
# for any network-accessible or production Vault deployment.
