package library.kubernetes.admission.example_loadbalancer

import data.library.kubernetes.admission.loadbalancer

# Deny requests that include external-facing load balancer whose name is not
#   whitelisted
deny[explanation] {
    input.request.kind.kind == "Service"
    input.request.operation = "CREATE"
    loadbalancer.is_external_lb
    namespace := input.request.namespace
    name := input.request.object.metadata.name
    not whitelisted[{"namespace": namespace, "name": name}]
    explanation = sprintf("Service %v/%v is an external load balancer but has not been whitelisted", [namespace, name])
}

# Simple white list.
#   WHITELISTED is a set of dictionaries each of which have a NAMESPACE and a NAME field.
whitelisted[{"namespace": "retail", "name": "payment_lb"}]
whitelisted[{"namespace": "retail", "name": "frontdoor_lb"}]


############################################################
# Boilerplate--implementation of the k8s admission control external webhook interface.
# No need to modify the code below.
main = {
  "apiVersion": "admission.k8s.io/v1beta1",
  "kind": "AdmissionReview",
  "response": response,
}

default response = {"allowed": true}

response = x {
    x := {
      "allowed": false,
      "status": {"reason": reason}}
    reason = concat(", ", deny)
    reason != ""
}


