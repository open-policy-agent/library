# Validating + Mutating Kubernetes Admission Controller in pure Rego

`main.rego` implements a simple framework that combines both validating and mutating admission controller rules, as well as some common helpers for working with labels and annotations.

It was based on the existing examples at [Kubernetes Admission Control](https://www.openpolicyagent.org/docs/kubernetes-admission-control.html) and [MutatingAdmissionWebhook Example with OPA](https://gist.github.com/tsandall/a9b2b57f7c6768f49b25271776b72dee).

## A note about labels and annotations

When adding a label or annotation to some object's metadata Kubernetes requires that the `.../metadata/labels` or `.../metadata/annotations` node exists. The patch framework manages this through the `ensureParentPathsExist()` function, which will create the base `labels` or `annotations` nodes where required.

## Helper functions

A common use case for mutating admission controllers is adding or modifying labels and annotations, so a small set of helper functions is provided to aid readability. See `example_mutation.rego` for some examples, and `test_mutation.rego` for examples of unit tests.

Note that the `makeLabelPatch()` and `makeAnnotationPatch()` helper functions also handle the common case where labels or annotations may have a slash in the key name, for example `kubernetes.io/role`. This needs to be escaped to `kubernetes.io~1role`, and this is handled automatically in the helper functions.

## Mutating vs Validating Admission Controllers

Mutating Admission Controllers can also return `allowed=false` statuses, to deny the request. This can be handy in simple cases, but be aware that in this library the validation policies (the `deny` rules) will override any patches. In some use cases the mutations applied might be the thing that fixes up raw requests in order to pass validation (adding required labels, for example). In that case you would need to configure two separate OPA instances, one for validation and one for mutation, as Kubernetes will call any mutating controllers before calling any validating controllers.