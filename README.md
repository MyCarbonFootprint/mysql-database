# mysql-database

Use helm version
```
$ helm version
version.BuildInfo{Version:"v3.3.4", GitCommit:"a61ce5633af99708171414353ed49547cf05013d", GitTreeState:"clean", GoVersion:"go1.14.9"}
```

Launch `./deployment.sh` to deploy the mariadb service in the kubernetes cluster.
It creates or updates the helm chart on the targeted Kube cluster.
