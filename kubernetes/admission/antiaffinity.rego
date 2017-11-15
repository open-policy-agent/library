package library.kubernetes.admission.antiaffinity

# https://github.com/kubernetes/kubernetes/blob/master/plugin/pkg/admission/antiaffinity/admission.go
# https://github.com/kubernetes/kubernetes/blob/master/plugin/pkg/admission/antiaffinity/admission_test.go

default admit = false

admit {
	not invalid_anti_affinity
}

invalid_anti_affinity {
	input.kind = "Pod"
	terms = input.spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution
	key = terms[_][_].topologyKey
	not allowed_topology_keys[key]
}

allowed_topology_keys = {"kubernetes.io/hostname"}

