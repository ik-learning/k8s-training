# Useful pods commands

Get the CPU and memory of the containers inside the pod:
```
kubectl top pods group-context --containers
```

Get the CPU and memory of a specific pod:
```
kubectl top pod pod-with-defaults
```

Get the CPU and memory of pods with a label selector:
```
kubectl top pod -l run=pod-with-defaults
```