package library.kubernetes.admission.example_loadbalancer2

import data.library.kubernetes.admission.loadbalancer

# Note: same as example_loadbalancer, but define whitelist differently

# Deny requests that include external-facing load balancer whose name is not
#   whitelisted
deny[explanation] {
    input.request.kind.kind == "Service"
    input.request.operation = "CREATE"
    loadbalancer.is_external_lb
    not whitelisted
    namespace := input.request.namespace
    name := input.request.object.metadata.name
    explanation = sprintf("Service %v/%v is an external load balancer but has not been whitelisted", [namespace, name])
}

#   WHITELISTED is a boolean
whitelisted {
    input.request.namespace != "prod"
}
whitelisted {
    input.request.userInfo.username == "alice_root"
}


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


