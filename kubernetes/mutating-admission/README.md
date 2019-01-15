# Validating + Mutating Kubernetes Admission Controller in pure Rego

`main.rego` implements a simple framework that combines both validating and mutating admission controller rules, as well as some common helpers for working with labels and annotations.

It was based on the existing examples at [Kubernetes Admission Control](https://www.openpolicyagent.org/docs/kubernetes-admission-control.html) and [MutatingAdmissionWebhook Example with OPA](https://gist.github.com/tsandall/a9b2b57f7c6768f49b25271776b72dee).

## A note about labels and annotationsd

When adding a label or annotation to some object's metadata Kubernetes requires that the `.../metadata/labels` or `.../metadata/annotations` node exists. The patch framework manages this through the `ensureParentPathsExist()` function, which will create the base `labels` or `annotations` nodes where required.

## Helper functions

A common use case for mutating admission controllers is adding or modifying labels and annotations, so a small set of helper functions is provided to aid readability. See `example_mutation.rego` for some examples.
