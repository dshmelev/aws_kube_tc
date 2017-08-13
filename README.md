# AWS kubernetes TeamCity setup
1. Download and install kops/terraform/kubectl/helm
2. Setup AWS credential
```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
```
2. Generate terraform setup and cluster specs
```
kops create cluster --zones=us-west-2a --state=s3://prefix-k8s-dshmelev-net-state-store --name=k8s.dshmelev.net --kubernetes-version=1.7.3 --out=tf --target=terraform
```
3. Review changes and deploy cluster:
```
$ cd tf
$ terraform plan
$ terraform apply
```
4. Configure local kubectl
```
$ kops export kubecfg
```
5. Wait for apply DNS changes
```
$ nslookup api.k8s.dshmelev.net
```
6. Check cluster setup
```
$ kubectl cluster-info
```
7. Install helm tiller
```
$ helm init
```
7. Edit charts
```
charts/external-dns/values.yaml: controller.domain
charts/kube-lego/values.yaml: config.LEGO_EMAIL
charts/teamcity/values.yaml: ingress.hosts; ingress.tls.hosts
```
8. Deploy charts
```
$ helm install charts/nginx-ingress --namespace kube-system
$ helm install charts/kube-lego --namespace kube-system
$ helm install charts/nginx-ingress --namespace kube-system
$ helm install charts/teamcity --namespace teamcity
```
9. Wait for apply pods and DNS changes

...

10. Profit. Go to ingress http address
