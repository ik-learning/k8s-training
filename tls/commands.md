# TLS

```
# Generate certificate
openssl genrsa -out my-bank.key 1024
# Generate private key
openssl rsa -in my-bank.key -pubout > mybank.pem
# Show contect
openssl rsa -in <key> -text -noout
```

## Create certificates for Kubernetes

### Certificate Authority

```sh
# Generate Keys
$ openssl genrsa -out ca.key 2048
# Certificate Signing Request
$ openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
# Sign Certificate
$ openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt
```

### Admin User Certificates

```sh
# Geenrate private key for admin user
$ openssl genrsa -out admin.key 2048
# Generate CSR for admin user. Note the OU.
$ openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr
# Sign certificate for admin user using CA servers private key
$ openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out admin.crt
```

### The Controller Manager Client Certificate

```sh
# Generate the kube-controller-manager client certificate and private key:
$ openssl genrsa -out kube-controller-manager.key 2048
$ openssl req -new -key kube-controller-manager.key -subj "/CN=system:kube-controller-manager" -out kube-controller-manager.csr
$ openssl x509 -req -in kube-controller-manager.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-controller-manager.crt
# Results
> kube-controller-manager.key
> kube-controller-manager.crt
```

### The Kube Proxy Client Certificate

```sh
# Generate the kube-proxy client certificate and private key
$ openssl genrsa -out kube-proxy.key 2048
$ openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy" -out kube-proxy.csr
$ openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-proxy.crt
# Results
> kube-proxy.key
> kube-proxy.crt
```

### The Scheduler Client Certificate

```sh
# Generate the kube-scheduler client certificate and private key
$ openssl genrsa -out kube-scheduler.key 2048
$ openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler" -out kube-scheduler.csr
$ openssl x509 -req -in kube-scheduler.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-scheduler.crt
# Results
> kube-scheduler.key
> kube-scheduler.crt
```

### The Kubernetes API Server Certificate

The kube-apiserver certificate requires all names that various components may reach it to be part of the alternate names. These include the different DNS names, and IP addresses such as the master servers IP address, the load balancers IP address, the kube-api service IP address etc.

```sh
# the openssl command cannot take alternate names as command line parameter. So we must create a conf file for it
cat > openssl.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 192.168.5.11
IP.3 = 192.168.5.12
IP.4 = 192.168.5.30
IP.5 = 127.0.0.1
EOF
```

```sh
# Generates certs for kube-apiserver
$ openssl genrsa -out kube-apiserver.key 2048
$ openssl req -new -key kube-apiserver.key -subj "/CN=kube-apiserver" -out kube-apiserver.csr -config openssl.cnf
$ openssl x509 -req -in kube-apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-apiserver.crt -extensions v3_req -extfile openssl.cnf
# Results
> kube-apiserver.crt
> kube-apiserver.key
```

### The ETCD Server Certificate

Similarly ETCD server certificate must have addresses of all the servers part of the ETCD cluster

```sh
# The openssl command cannot take alternate names as command line parameter. So we must create a conf file for it
cat > openssl-etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 192.168.5.11
IP.2 = 192.168.5.12
IP.3 = 127.0.0.1
EOF
```

```sh
# Generates certs for ETCD
$ openssl genrsa -out etcd-server.key 2048
$ openssl req -new -key etcd-server.key -subj "/CN=etcd-server" -out etcd-server.csr -config openssl-etcd.cnf
$ openssl x509 -req -in etcd-server.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out etcd-server.crt -extensions v3_req -extfile openssl-etcd.cnf
# Result
kube-apiserver.crt
kube-apiserver.key
```

### The Service Account Key Pair

The Kubernetes Controller Manager leverages a key pair to generate and sign service account tokens as describe in the managing service accounts documentation

```sh
> openssl genrsa -out service-account.key 2048
> openssl req -new -key service-account.key -subj "/CN=service-accounts" -out service-account.csr
> openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out service-account.crt
# Results
> service-account.key
> service-account.crt
```

## QA

Where to find certificates?

```
cat /etc/kubernetes/manifests/kube-apiserver.yaml
# Check the certificate
openssl x509 -in ca.crt -text -noout
```