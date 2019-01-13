# Validating + Mutating Kubernetes Admission Controller in pure Rego

`main.rego` implements a simple framework that combines both validating and mutating admission controller rules, as well as some common helpers for working with labels and annotations.

It was based on the existing examples at [Kubernetes Admission Control](https://www.openpolicyagent.org/docs/kubernetes-admission-control.html) and [MutatingAdmissionWebhook Example with OPA](https://gist.github.com/tsandall/a9b2b57f7c6768f49b25271776b72dee).

