https://hackertarget.com/nmap-cheatsheet-a-quick-reference-guide/

Ip Tables:
```sh
cat /etc/sysctl.conf
```

Add the iptables rule to sysctl.conf:
```sh
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
```