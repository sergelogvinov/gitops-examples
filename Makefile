#

CLUSTER ?=
TOKEN=$(shell head -c 12 /dev/urandom | shasum | cut -d ' ' -f1)

########################################################

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

########################################################

check:
ifeq ($(CLUSTER),none)
	@echo
	@echo "CLUSTER is not set"
	@echo
	@exit 1
endif

init: check ## Initialize the cluster
	sops --decrypt clusters/${CLUSTER}/vars/secrets.fluxcd.yaml | kubectl -n flux-system apply -f -
	kubectl apply -f clusters/${CLUSTER}/bootstrap.yaml
	kubectl apply -f clusters/${CLUSTER}/bootstrap-fluxcd.yaml
	kubectl apply --server-side --kustomize clusters/${CLUSTER}