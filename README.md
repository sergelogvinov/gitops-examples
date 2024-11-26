# Gitops examples

Kubernetes GitOps examples with FluxCD.

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
kubectl apply --server-side --kustomize clusters/cluster-0
sops --decrypt clusters/cluster-0/vars/secrets.fluxcd.yaml | kubectl -n flux-system apply -f -
```

## Refresh source

```shell
kubectl get HelmRelease -A
flux reconcile -n flux-system source git gitops-clusters
```

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
