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

  # xargs -l oc delete --all -A < crds.txt

  CSVS=(
    operators.coreos.com/authorino-operator.openshift-operators
    operators.coreos.com/devworkspace-operator.openshift-operators
    operators.coreos.com/gpu-operator-certified.nvidia-gpu-operator
    operators.coreos.com/openshift-pipelines-operator-rh.openshift-operators
    operators.coreos.com/nfd.openshift-nfd
    operators.coreos.com/rhods-operator.redhat-ods-operator
    operators.coreos.com/servicemeshoperator.openshift-operators
    operators.coreos.com/serverless-operator.openshift-serverless
    operators.coreos.com/web-terminal.openshift-operators
  )

  for csv in ${CSVS[@]}
  do
    # set csvs to cleanup
    oc get csv -A -l "${csv}" -o yaml | \
      sed 's/^    enabled: false/    enabled: true/' | \
        oc apply -f -
    oc delete csv -A -l ${csv}
  done

  oc delete -n openshift-operators deploy devworkspace-webhook-server

  GPU_MACHINE_SET=$(oc -n openshift-machine-api get machinesets -o name | grep -E -v 'worker')
  for set in ${GPU_MACHINE_SET}
  do
    oc -n openshift-machine-api delete "$set"
  done

  WEBHOOK=$(oc get validatingwebhookconfiguration,mutatingwebhookconfiguration -o name | grep -E 'tekton.dev')
  for set in ${WEBHOOK}
  do
    oc -n openshift-machine-api delete "$set"
  done

  oc delete -k https://github.com/hemang-rh/openshift-gitops/demo

  xargs -l oc delete ns < namespaces.txt

  # xargs -l oc delete --all -A < crds.txt
  # xargs -l oc delete crd < crds.txt

  echo "completed: uninstall"
}

uninstall_demo && self_distruct
