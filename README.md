# Demo Kueue on OpenShift

This is an example of how to use kueue with OpenShift AI

## TODO

- [ ] Change `peer-review` to `main`
- [ ] Change `https://github.com/codekow/demo-kueue` to `https://github.com/hemang-rh/openshift-gitops`

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
