package library.kubernetes.admission.loadbalancer


# case: exposing to world via NodePort or ExternalName
is_external_lb {
    # https://kubernetes.io/docs/concepts/services-networking/service/#nodeport
    # https://kubernetes.io/docs/concepts/services-networking/service/#externalname
    types := {"NodePort", "ExternalName"}
    types[input.request.object.spec.type]
}
# case: exposing externalIPs directly
is_external_lb {
    # https://kubernetes.io/docs/concepts/services-networking/service/#external-ips
    count(input.request.object.externalIPs) > 0
}

# case: external load balancer (not overridden to be internal load balancer
is_external_lb {
    # https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer
    # Using contains(....) instead of == based on recommendations from the field
    contains(input.request.object.spec.type, "LoadBalancer")
    not is_internal_lb
}

is_internal_lb {
    # https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer
    # iterate over all the annotations
    input.request.object.metadata.annotations[key] = value
    # check if the annotation indicates the LB is internal-only
    # TODO: how forgiving is k8s about the format of the values of annotations:
    #    IP, case-sensitive, booleans versus strings?
    internal_annotations[key] == value
}

# define dictionary of annotations that make a loadbalancer private
internal_annotations = {
    "service.beta.kubernetes.io/aws-load-balancer-internal": "0.0.0.0/0",   # aws
    "cloud.google.com/load-balancer-type": "Internal",                      # gcp
    "service.beta.kubernetes.io/azure-load-balancer-internal": "true",      # azure
    "service.beta.kubernetes.io/openstack-internal-load-balancer": "true"   # openstack
}

