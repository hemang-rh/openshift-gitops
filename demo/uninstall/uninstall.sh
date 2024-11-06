#!/bin/sh

TIMEOUT=60
NAMESPACE=adhoc-admin

cd "$(dirname "$0")" && pwd

self_distruct(){
  echo "
    removing project: ${NAMESPACE} in ${TIMEOUT}s
    goodbye cruel world...
  "
  
  sleep "${TIMEOUT}"
  oc delete project "${NAMESPACE}"
}

uninstall_demo(){

  echo "start: uninstall..."

  oc delete datasciencecluster default-dsc
  oc delete dscinitialization default-dsci

  sleep 8

  oc -n istio-system delete --all servicemeshcontrolplanes.maistra.io
  oc -n istio-system delete --all servicemeshmemberrolls.maistra.io
  oc delete --all -A servicemeshmembers.maistra.io

  oc -n knative-serving delete knativeservings.operator.knative.dev knative-serving
  oc delete consoleplugin console-plugin-nvidia-gpu

  oc delete csv -A -l operators.coreos.com/authorino-operator.openshift-operators
  oc delete csv -A -l operators.coreos.com/devworkspace-operator.openshift-operators
  # oc delete csv -A -l operators.coreos.com/openshift-pipelines-operator-rh.openshift-operators
  oc delete csv -A -l operators.coreos.com/servicemeshoperator.openshift-operators
  oc delete csv -A -l operators.coreos.com/web-terminal.openshift-operators

  oc delete -n openshift-operators deploy devworkspace-webhook-server

  GPU_MACHINE_SET=$(oc -n openshift-machine-api get machinesets -o name | grep -E -v 'worker')
  for set in ${GPU_MACHINE_SET}
  do
    oc -n openshift-machine-api delete "$set"
  done

  oc delete -k https://github.com/hemang-rh/openshift-gitops/demo

  xargs -l oc delete ns < namespaces.txt

  xargs -l oc delete --all -A < crds.txt
  xargs -l oc delete crd < crds.txt

  echo "completed: uninstall"
}

uninstall_demo && self_distruct
