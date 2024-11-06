# Demo Kueue on OpenShift

This is an example of how to use kueue with OpenShift AI

## TODO

- [ ] Change `main` to `main`
- [ ] Change `https://github.com/hemang-rh/openshift-gitops` to `https://github.com/hemang-rh/openshift-gitops`

## Quickstart

Run Demo

```sh
until oc apply -k demo; do : ; done
```

With Argo

```sh
until oc apply -k bootstrap; do : ; done
```

## Watch Jobs

```sh
# A cronjob re-starts jobs every few mins
watch oc -n demo-kueue get jobs,queues
```

## Uninstall

```sh
oc apply -k demo/uninstall
```
