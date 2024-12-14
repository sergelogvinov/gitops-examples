# Gitops examples

Kubernetes GitOps examples with FluxCD.

## Components

This project is a collection of base addons for kubernetes.

FluxCD components:
* [Flux system](apps/flux-system)
* [Flux git config](apps/flux-system/config)
* [Flux repos](apps/flux-system/repos)

Base addons:
* [Cert Manager](apps/base/cert-manager)
* [External Secrets](apps/base/external-secrets)
* [Keda](apps/base/keda)
* [Local path provisioner](apps/base/local-path-provisioner)
* [Metrics server](apps/base/metrics-server)
* [Basic RBAC](apps/base/rbac)

Cloud platform integrations:
* [Azure CCM](apps/clouds/azure-ccm)
* [Azure CSI](apps/clouds/azure-csi)
* [GCP CCM](apps/clouds/gcp-ccm)
* [GCP CSI](apps/clouds/gcp-csi)
* [OVHCloud CCM](apps/clouds/ovh-ccm)
* [OVHCloud CSI](apps/clouds/ovh-csi)
* [Proxmox CCM](apps/clouds/proxmox-ccm)
* [Proxmox CSI](apps/clouds/proxmox-csi)
* [Scaleway CCM](apps/clouds/scaleway-ccm)
* [Scaleway CSI](apps/clouds/scaleway-csi)
* [Talos CCM](apps/clouds/talos-ccm)
* [Talos etcd backup](apps/clouds/talos-backup)
* [Talos update](apps/clouds/talos-upgrade-controller)

Cluster logging:
* [Fluent Bit](apps/logging/fluent-bit)
* [Fluentd route](apps/logging/fluentd-route)
* [Kubernetes event exporter](apps/logging/event-exporter)

Cluster monitoring:
* [Prometheus base components](apps/monitoring/prometheus)
* [Prometheus AlertManager](apps/monitoring/prometheus-alertmanager)
* [Prometheus Node exporter](apps/monitoring/prometheus-node-exporter)
* [Victoria Metrics](apps/monitoring/victoria-metrics)
* [Victoria Metrics Operator](apps/monitoring/victoria-metrics-operator)
* [InfluxDB](apps/monitoring/influxdb)

Ingress controllers:
* [Ingress nginx](apps/ingress/ingress-nginx)
* [Ingress skipper](apps/ingress/skipper)

## Folder structure

```shell
📁 apps
├── 📁 name-of-application
│   ├── 📁 app
│   │  ├── helmrelease.yaml             # fluxcd crd
│   │  ├── helmvalues.yaml              # helm values
│   │  └── kustomization.yaml           # kustomization parameters
│   │
│   ├── fluxcd.yaml                     # fluxcd crd
│   ├── helmfile.yaml                   # helmfile (manual deploy)
│   └── kustomization.yaml              # kustomization parameters
│
├── 📁 group-of-application
│   ├── 📁 name-of-application
│   │   ├── 📁 app
│   │   │   ├── helmrelease.yaml        # fluxcd crd
│   │   │   ├── helmvalues.yaml         # helm values
│   │   │   └── kustomization.yaml      # kustomization parameters
│   │   │
│   │   ├── fluxcd.yaml                 # fluxcd crd
│   │   ├── helmfile.yaml               # helmfile (manual deploy)
│   │   ├── kustomization.yaml          # kustomization parameters
│   │   └── namespace.yaml              # namespace definition
│   │
│   └── 📁 name-of-application
│       ├── 📁 app
│       │   ├── helmrelease.yaml        # fluxcd crd
│       │   ├── helmvalues.yaml         # helm values
│       │   └── kustomization.yaml      # kustomization parameters
│       │
│       ├── fluxcd.yaml                 # fluxcd crd
│       ├── helmfile.yaml               # helmfile (manual deploy)
│       ├── kustomization.yaml          # kustomization parameters
│       └── namespace.yaml              # namespace definition
│
└── 📁 clusters                         # clusters
    └── 📁 cluster-1                    # cluster name
       ├── 📁 vars
       │   ├── cluster.yaml             # cluster common variables
       │   ├── secrets.fluxcd.yaml      # fluxcd secrets git-token, slack-token etc.
       │   └── kustomization.yaml       # kustomization parameters
       │
       ├── fluxcd.yaml                 # fluxcd crd
       └── kustomization.yaml          # component list
```

## Prepare

Clone repository, and add change:
* git url in file `apps/flux-system/config/repository.yaml`
* git-token in file `clusters/cluster-0/vars/secrets.fluxcd.yaml`
* comment/uncomment application in file `clusters/cluster-0/kustomization.yaml`

Commit the changes and push to the repository.

## Bootstrap

```shell
kubectl apply --server-side --kustomize bootstrap
```

## Deploy cluster

```shell
sops --decrypt clusters/cluster-0/vars/secrets.fluxcd.yaml | kubectl -n flux-system apply -f -
kubectl apply --server-side --kustomize clusters/cluster-0
```

## Refresh source

```shell
kubectl get HelmRelease -A
flux reconcile -n flux-system source git gitops-clusters
```

# Development

## Git

```shell
git config user.name "Serge Logvinov"
git config user.email serge.logvinov@email

gpg --list-secret-keys --keyid-format=long
git config user.signingkey 349CAAD68AF02E2B
git config commit.gpgsign true
```

## References

* https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key

## Inspiration

* https://github.com/jfroy/flatops.git
* https://github.com/kashalls/home-cluster.git
* https://github.com/onedr0p/home-ops.git
* https://github.com/xunholy/k8s-gitops.git
* https://github.com/szinn/k8s-homelab.git
