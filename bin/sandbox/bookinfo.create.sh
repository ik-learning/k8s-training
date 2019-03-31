
ISTIO="$(pwd)/istio-1.0.2"
kubectl delete -f $ISTIO/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f $ISTIO/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f $ISTIO/samples/bookinfo/networking/bookinfo-gateway.yaml

sudo kubectl -n istio-system port-forward istio-ingressgateway-5c457d45c4-4m8c7 80


for i in {1..10}; do curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage; done

 prometheus port forwading
 kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090

for ((i=1;i<=100;i++)); do  curl -o /dev/null -s -w "%{http_code}\n" "http://${GATEWAY_URL}/productpage"; done

port forward Grafana
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090

SYSTEM GRAPGH
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088
http://localhost:8088/force/forcegraph.html
http://localhost:8088/dotviz
http://localhost:8088/dotgraph

grafama
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000


 export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')



 kubectl apply -f $ISTIO/samples/bookinfo/networking/destination-rule-all-mtls.yaml

 $ISTIO/samples/bookinfo/platform/kube/cleanup.sh


 https://github.com/srinandan/istio-workshop/blob/master/README.md