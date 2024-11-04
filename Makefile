# Ensure Make is run with bash shell as some syntax below is bash-specific
SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


################################################################################
# Checks
################################################################################

CONTROLLER_GEN ?= $(shell command -v controller-gen 2>/dev/null)
ifeq (,$(strip $(CONTROLLER_GEN)))
$(error controller-gen not detected!)
endif

KIND ?= $(shell command -v kind 2>/dev/null)
ifeq (,$(strip $(KIND)))
$(error kind not detected!)
endif

KUBECTL ?= $(shell command -v kubectl 2>/dev/null)
ifeq (,$(strip $(KUBECTL)))
$(error kubectl not detected!)
endif

CRI_BIN ?= $(shell command -v podman 2>/dev/null || command -v docker 2>/dev/null)
ifeq (,$(strip $(CRI_BIN)))
$(error neither podman nor docker detected!)
endif
export CRI_BIN

################################################################################
# Kind
################################################################################

KIND_CMD := $(KIND)
ifeq (podman,$(notdir $(CRI_BIN)))
KIND_CMD := KIND_EXPERIMENTAL_PROVIDER=podman $(KIND)
endif

KIND_IMAGE ?= kindest/node:v1.31.1

ifneq (,$(strip $(KIND_IMAGE)))
KIND_IMAGE_FLAG := --image $(KIND_IMAGE)
endif

KIND_CLUSTER_NAME ?= widget
KUBECONFIG ?= $(HOME)/.kube/config

.PHONY: kind-up
kind-up: ## Create kind cluster
	$(KIND_CMD) create cluster --name "$(KIND_CLUSTER_NAME)" $(KIND_IMAGE_FLAG)

.PHONY: kind-down
kind-down:
kind-down: ## Delete kind cluster
	$(KIND_CMD) delete cluster --name "$(KIND_CLUSTER_NAME)"


################################################################################
# CRD
################################################################################

SRC := api/v1alpha1/widget_types.go
DCP := api/v1alpha1/zz_generated.deepcopy.go
CRD := config/crd/bases/example.com_widgets.yaml

$(DCP): $(SRC)
	$(CONTROLLER_GEN) paths=./api/... object

$(CRD): $(DCP)
	$(CONTROLLER_GEN) \
	  paths=./api/... \
	  crd:crdVersions=v1 \
	  output:crd:dir=$(@D) \
	  output:none

.PHONY: build
build: $(CRD)
build: ## Build the CRD

.PHONY: apply
apply: $(CRD)
apply: ## Apply the CRD
	KUBECONFIG=$(KUBECONFIG) $(KUBECTL) apply -f $(CRD)


################################################################################
# Tests
################################################################################

WIDGETS := tests.yaml

.PHONY: test
test: apply
test: ## Apply test resources
	KUBECONFIG=$(KUBECONFIG) $(KUBECTL) apply -f $(WIDGETS)

.PHONY: list
list: ## List test resources
	KUBECONFIG=$(KUBECONFIG) $(KUBECTL) get widgets -oyaml