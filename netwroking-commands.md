```
ip link
ip addr
ip addr add 192.168.1.10/24 dev eth0
ip route
ip route add 192.168.1.0/24 via 192.168.2.1
arp
netstat -plnt
route
ip addr show weave
iptables -L -n net | grep db-service
curl <http|https> --key --cert --cacert
```

`/proc/sys/net/ipv4/ip_forward`
```
1
```

[Lecture](https://www.udemy.com/certified-kubernetes-administrator-with-practice-tests/learn/lecture/14296150#overview)
List of IP networking commands to learn
```
ip link add v-net-0 type bridge
ip link set dev v-net-0 up
ip addr add 192.168.15.5/24 dev v-net-0
ip link add veth-red type veth peer name veth-red-br
ip link set veth-red netns red
ip -n red addr add 192.168.15.1 dev veth-red
ip -n red link set veth-red up
ip link set veth-red-br master v-net-0
ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUARADE
```

```
kubectl exec busybox ip route
```