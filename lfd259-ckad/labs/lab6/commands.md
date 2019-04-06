# Security Labs

```
kubectl apply -f ./lfd259-k8s-developer/labs/lab6/second.yaml
kubectl get  pod secondapp
kubectl get pod secondapp -o yaml
kubectl exec -it secondapp -- sh
kubectl delete pod secondapp
```

```
kubectl exec -it secondapp -- sh
grep Cap /proc/1/status
capsh --decode=00000000a80425fb
```

App with capabilties

```yaml
capabilities:
  add: ["NET_ADMIN", "SYS_TIME"]
```

```sh
grep Cap /proc/1/status
> CapInh:	00000000aa0435fb
> CapPrm:	0000000000000000
> CapEff:	0000000000000000
> CapBnd:	00000000aa0435fb
> CapAmb:	0000000000000000
capsh --decode=00000000aa0435fb
> 0x00000000aa0435fb=cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_admin,cap_net_raw,cap_sys_chroot,cap_sys_time,cap_mknod,cap_audit_write,cap_setfcap
```

## Create and consume Secrets

```
echo LFTr@1n | base64
kubectl exec -ti secondapp -- /bin/sh
```

## Create and use ServiceAccounts

We can use ServiceAccounts to assign cluster roles, or the ability to use particular HTTP verbs. In this section we will create a new ServiceAccount and grant it access to view secrets.

```
kubectl get serviceaccounts
kubectl get clusterroles
kubectl get clusterrole secret-access-cr -o yaml
kubectl describe pod secondapp | grep -i secret
```

## Implement a NetworkPolicy

An early architecture decision with Kubernetes was non-isolation, that all pods were able to connect to all other pods and nodes by design. In more recent releases the use of a NetworkPolicy allows for pod isolation. The policy only has effect when the network plugin, like Project Calico, are capable of honoring them. If used with a plugin like flannel they will have no effect. The use of matchLabels allows for more granular selection within the namespace which can be se- lected using a namespaceSelector. Using multiple labels can allow for complex application of rules. More information can be found here: https://kubernetes.io/docs/concepts/services-networking/network-policies

```
kubectl logs secondapp webserver
kubectl expose pod secondapp --type=NodePort --port=80
> error: couldn't retrieve selectors via --selector flag or introspection: the pod has no labels and cannot be exposed
kubectl create service nodeport secondapp --tcp=80
kubectl get svc secondapp -o yaml
kubectl exec -it -c busy secondapp sh

> nc -vz www.linux.com 80
```