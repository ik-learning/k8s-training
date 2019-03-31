#!/bin/bash

set -euo pipefail

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(minikube ip)

echo "Port: $INGRESS_PORT"
echo "Secure Port: $SECURE_INGRESS_PORT"
echo "Host: $INGRESS_HOST"

echo "Create an Istio Gateway:"

# cat <<EOF | kubectl apply -f -
# apiVersion: networking.istio.io/v1alpha3
# kind: Gateway
# metadata:
#   name: httpbin-gateway
# spec:
#   selector:
#     istio: ingressgateway # use Istio default gateway implementation
#   servers:
#   - port:
#       number: 80
#       name: http
#       protocol: HTTP
#     hosts:
#     - "httpbin.example.com"
# EOF

# echo "Configure routes for traffic entering gateway"

# cat <<EOF | kubectl apply -f -
# apiVersion: networking.istio.io/v1alpha3
# kind: VirtualService
# metadata:
#   name: httpbin
# spec:
#   hosts:
#   - "httpbin.example.com"
#   gateways:
#   - httpbin-gateway
#   http:
#   - match:
#     - uri:
#         prefix: /status
#     - uri:
#         prefix: /delay
#     route:
#     - destination:
#         port:
#           number: 8000
#         host: httpbin
# EOF

export GATEWAY_URL=$INGRESS_HOST:$SECURE_INGRESS_PORT
echo "https://${GATEWAY_URL}/productpage"
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage