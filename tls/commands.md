# TLS

```
# Generate certificate
openssl genrsa -out my-bank.key 1024
# Generate private key
openssl rsa -in my-bank.key -pubout > mybank.pem
```