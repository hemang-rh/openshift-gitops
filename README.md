# Demo Kueue on OpenShift

This is an example of how to use kueue with OpenShift AI

## TODO

- [ ] Change `main` to `main`
- [ ] Change `https://github.com/hemang-rh/openshift-gitops` to `https://github.com/hemang-rh/openshift-gitops`

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
# A cronjob re-starts jobs every 2 mins
watch oc -n demo-kueue get jobs,queues
```

## Uninstall

```sh
oc delete -k demo
```
