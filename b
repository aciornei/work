GOPROXY=off GOFLAGS=-mod=vendor \
go run ./tools/decrypt-secrets \
  -in /etc/vm-doc-server/secrets.enc \
  -out /root/vm-doc-secrets-0.2.2.yaml \
  -key /etc/vm-doc-server/master.key
