# Networking Pods and Nodes

View the nodes virtual network interfaces
```
ifconfig
```

Get the process ID for the container:
```
docker inspect --format '{{ .State.Pid }}' [container_id]
```

Use nsenter to run a command in the process's network namespace:
```
nsenter -t [container_pid] -n ip addr
```

Look at the iptables rules for your services:
```
sudo iptables-save | grep KUBE | grep nginx
```
