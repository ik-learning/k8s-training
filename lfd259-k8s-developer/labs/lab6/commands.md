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