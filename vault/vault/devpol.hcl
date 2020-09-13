path "devkv/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/data/{{identity.entity.id}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/metadata/{{identity.entity.id}}/*" {
  capabilities = ["list"]
}
