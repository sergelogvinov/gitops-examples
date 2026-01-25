# Gitops examples

Kubernetes GitOps examples with FluxCD.

All components are designed to work in a hybrid cloud environment, which means they can run across different cloud providers or even between cloud and on-premises systems.

The [Talos](https://github.com/siderolabs/talos) uses as kubernetes distribution. Talos is well-suited for hybrid setups because it focuses on security and simplicity, making it easy to manage Kubernetes clusters.

The Talos Cloud Controller Manager ([Talos CCM](https://github.com/siderolabs/talos-cloud-controller-manager)) is responsible for setting labels on the nodes. These labels are very important because they help the system components know how to manage workloads. For example, some workloads require specific cloud platform to launch.

## Key Features:

* `Flexible Deployment`: The CCM, CSI, and NodeAutoScaler components can all be deployed together or separately. This gives you the flexibility to only use what you need.
* `Multi Cloud Support`: You can combine components from different cloud providers in the same cluster. For example, you might use one provider for storage and another for scaling. This helps avoid being locked into a single provider.
* `Hybrid Cloud Ready`: The setup works well across public cloud, private cloud, or on-premises environments, allowing seamless integration between them.
* `Consistent Setup Across Environments`: No matter if your cluster is running in the public cloud, private cloud, or on-premises, the setup will remain consistent. This ensures easier management and smooth transitions between environments.

## Cloud Platform Integrations

Most of the CCMs was patched to work with hybrid environments. You can find the patches in my repo [containers](https://github.com/sergelogvinov/containers).


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
* [Hetzner Cloud CCM](apps/clouds/hcloud-ccm)
* [Hetzner Cloud CSI](apps/clouds/hcloud-csi)
* [Oracle CCM](apps/clouds/oracle-ccm)
* [Oracle CSI](apps/clouds/oracle-csi)
* [OVHCloud CCM](apps/clouds/ovh-ccm)
* [OVHCloud CSI](apps/clouds/ovh-csi)
* [Proxmox CCM](apps/clouds/proxmox-ccm)
* [Proxmox CSI](apps/clouds/proxmox-csi)
* [Proxmox Karpenter](apps/clouds/proxmox-karpenter)
* [Scaleway CCM](apps/clouds/scaleway-ccm)
* [Scaleway CSI](apps/clouds/scaleway-csi)
* [Talos CCM](apps/clouds/talos-ccm)
* [Talos etcd backup](apps/clouds/talos-backup)
* [Talos update](apps/clouds/talos-upgrade-controller)
* [Cluster Node AutoScaler](apps/clouds/cluster-autoscaler)
    * [Azure](apps/clouds/cluster-autoscaler/azure)
    * [GCP](apps/clouds/cluster-autoscaler/gcp)
    * [Hetzner Cloud](apps/clouds/cluster-autoscaler/hcloud)
    * [Oracle](apps/clouds/cluster-autoscaler/oracle)

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
kubectl apply -f clusters/cluster-0/bootstrap.yaml
kubectl apply -f clusters/cluster-0/bootstrap-fluxcd.yaml
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
