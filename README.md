# Demo Kueue on OpenShift

This is an example of how to use kueue with OpenShift AI

## Quickstart

Run Demo

```sh
oc apply -k demo
```

With Argo

```sh
oc apply -k bootstrap
```

## Watch Jobs

```sh
oc create -f demo-kueue/adhoc-job.yaml

watch oc get queues,job
```
