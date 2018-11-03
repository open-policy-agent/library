package library.kubernetes.admission.alwayspullimages

# https://github.com/kubernetes/kubernetes/blob/master/plugin/pkg/admission/alwayspullimages/admission.go
# https://github.com/kubernetes/kubernetes/blob/master/plugin/pkg/admission/alwayspullimages/admission_test.go

# Allow only if all containers have PullPolicy set to Always
default admit = false

admit {
	not deny
}

deny {
	overwrite[path]
}

# Overwrite imagePullPolicy so it is always "Always"
overwrite[path] = "Always" {
	input.kind = "Pod"
	input.spec.containers[i].imagePullPolicy != "Always"
	path = sprintf("spec.containers[%v].imagePullPolicy", [i])
}

overwrite[path] = "Always" {
	input.kind = "Pod"
	container = input.spec.containers[i]
	not container.imagePullPolicy
	path = sprintf("spec.containers[%v].imagePullPolicy", [i])
}

overwrite[path] = "Always" {
	input.kind = "Pod"
	input.spec.initContainers[i].imagePullPolicy != "Always"
	path = sprintf("spec.initContainers[%v].imagePullPolicy", [i])
}

overwrite[path] = "Always" {
	input.kind = "Pod"
	container = input.spec.initContainers[i]
	not container.imagePullPolicy
	path = sprintf("spec.initContainers[%v].imagePullPolicy", [i])
}
