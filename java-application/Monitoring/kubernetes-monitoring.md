# Kubernetes Monitoring by installing grafana and prometheus using helm chart

$ kubectl get pods -n kube-system

NAME                               READY   STATUS    RESTARTS       AGE

coredns-787d4945fb-rsjp6           1/1     Running   2 (3m5s ago)   7d22h
etcd-minikube                      1/1     Running   2 (7d3h ago)   7d22h
kube-apiserver-minikube            1/1     Running   2 (3m5s ago)   7d22h
kube-controller-manager-minikube   1/1     Running   2 (3m5s ago)   7d22h
kube-proxy-27csz                   1/1     Running   2 (3m5s ago)   7d22h
kube-scheduler-minikube            1/1     Running   2 (7d3h ago)   7d22h
storage-provisioner                1/1     Running   5 (2m1s ago)   7d22h

1- Install helm tool by refering below article.

https://helm.sh/docs/intro/install/

2- Then download the prometheus repository using helm


$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories

$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈

3- Install the prometheus using below command from repository.

$ helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

NAME: prometheus
LAST DEPLOYED: Thu Jul 20 11:11:12 2023
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=prometheus"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.


4- Check if the pods are created and running. Below we can see grafana is also installed.

$ kubectl get pods -n monitoring
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          74s
prometheus-grafana-7d7bd786cb-c7h7m                      3/3     Running   0          95s
prometheus-kube-prometheus-operator-66f8558786-jgtmn     1/1     Running   0          95s
prometheus-kube-state-metrics-5cc6c487f9-wn5jn           1/1     Running   0          95s
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0          73s
prometheus-prometheus-node-exporter-shrcz                1/1     Running   0          95s


5- Below are the services for prometheus and pods.

$ kubectl get svc -n monitoring
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   92s
prometheus-grafana                        ClusterIP   10.100.200.97   <none>        80/TCP                       113s
prometheus-kube-prometheus-alertmanager   ClusterIP   10.98.183.115   <none>        9093/TCP,8080/TCP            113s
prometheus-kube-prometheus-operator       ClusterIP   10.96.123.219   <none>        443/TCP                      113s
prometheus-kube-prometheus-prometheus     ClusterIP   10.106.37.168   <none>        9090/TCP,8080/TCP            113s
prometheus-kube-state-metrics             ClusterIP   10.98.57.32     <none>        8080/TCP                     113s
prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     91s
prometheus-prometheus-node-exporter       ClusterIP   10.98.24.30     <none>        9100/TCP                     113s


6- To access the prometheus UI performed port forwarding as below running in background.

kubectl port-forward --address 0.0.0.0 svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &

Forwarding from 0.0.0.0:9090 -> 9090
Handling connection for 9090

$ kubectl port-forward --address 0.0.0.0 svc/prometheus-kube-state-metrics -n monitoring 8080
Forwarding from 0.0.0.0:8080 -> 8080
Handling connection for 8080


7- Then on Grafana added the prometheus datasource and then used 741 preconfigured grafana dashboard for the kubernetes from below.

https://grafana.com/grafana/dashboards/741-deployment-metrics/

