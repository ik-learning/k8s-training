# Work with certificates
<!-- Certificates -->
<!-- https://kubernetes.io/docs/concepts/cluster-administration/certificates/ -->

Read the certificate
```
openssl x509 -in <file> -text -noout
```

Grep
```
openssl x509 -in <file> -text -noout | grep -i valid -C 2
openssl req -in <file> -text -noout
ps -aux | grep etcd
openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out
$(cat server.csr | base64 | tr -d '\n')
```

Location of all configurations
```
/etc/kubernetes/manifests
```

```
cat /etc/kubernetes/manifests/kube-apiserver.yaml
```

Create certificate signing request:
```
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: my-svc.my-namespace
spec:
  groups:
  - system:authenticated
  request: $(cat server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
```

