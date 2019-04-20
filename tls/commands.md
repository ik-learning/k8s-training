# TLS

```
# Generate certificate
openssl genrsa -out my-bank.key 1024
# Generate private key
openssl rsa -in my-bank.key -pubout > mybank.pem
```

## Create certificates for Kubernetes

### Certificate Authority

Generate Keys
```
openssl genrsa -out ca.key 2048
```

Certificate Signing Request
```
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
```

Sign Certificate
```
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
```

### Admin User Certificates

Admin Key generation
```
openssl genrsa -out admin.key 2048
```

Admin Certificate
```
openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr
```

Generate Singed certificate
```
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt
```

### API Server

Generate a Key
```
openssl genrsa -out apiserver.key 2048
```

Generate a key
```
openssl req -new -key apiserver.key -subj "/CN=kube-apiserver" -out apiserver.csr -config openssl.cnf
```

Sign Certificate
```
openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -out apiserver.crt
```

## QA

Where to find certificates?

```
cat /etc/kubernetes/manifests/kube-apiserver.yaml
# Check the certificate
openssl x509 -in ca.crt -text -noout
```