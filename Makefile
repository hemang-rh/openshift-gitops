BASE:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL=/bin/sh
PROJECT:=kueue-demo
USER:=admin

.PHONY: teardown-kueue-demo setup-kueue-demo submit-job

teardown-kueue-demo:

	oc delete project $(PROJECT)
	
	@echo "Deleting all clusterqueues"
	oc delete clusterqueue --all --all-namespaces 

	@echo "Deleting all resourceflavors"
	oc delete resourceflavor --all --all-namespaces 

setup-kueue-demo:
	
	@echo "Creating project $(PROJECT)"
	oc new-project $(PROJECT)
	oc adm policy add-role-to-user admin $(USER) -n $(PROJECT)
	oc adm policy add-role-to-user kueue-batch-user-role $(USER) -n $(PROJECT)

	oc create -f $(BASE)/kueue-demo-config/kueue-cluster-queue.yaml
	oc create -f $(BASE)/kueue-demo-config/kueue-default-flavor.yaml
	oc create -f $(BASE)/kueue-demo-config/kueue-local-queue.yaml

make submit-job:
	@for i in $(shell seq 1 10); do \
		oc create -f $(BASE)/kueue-demo/kueue-job.yaml; \
	done