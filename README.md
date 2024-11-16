# Gitops examples

Kubernetes GitOps

```shell
📁 app
├── 📁 name-of-application
│   ├── 📁 app                  # application values
│   │  ├── helmrelease.yaml     # fluxcd crd
│   │  ├── helmvalues.yaml      # helm values
│   │  └── kustomization.yaml   # kustomization parameters
│   ├── fluxcd.yaml             # fluxcd crd
│   ├── helmfile.yaml           # helmfile (manual deploy)
│   ├── kustomization.yaml      # kustomization parameters
│   └── namespace.yaml          # namespace definition
└── 📁 ...                      # other clusters
```

## Git

```shell
git config user.name "Serge Logvinov"
git config user.email serge.logvinov@email

gpg --list-secret-keys --keyid-format=long
git config user.signingkey 349CAAD68AF02E2B
git config commit.gpgsign true
```

Reference: https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
