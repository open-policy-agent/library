package kubernetes.audit.pods

import data.kubernetes.audit.warn_images
import data.kubernetes.pods

error[result] {
	containers[[namespace, name, container]]
	missing_resources(container)
	result = {
		"type": "missing-resources",
		"name": name,
		"container_name": container.name,
		"namespace": namespace,
	}
}

error[result] {
	pod = pods[namespace][name]
	not pod.metadata.labels.app
	result = {
		"type": "missing-app-label",
		"name": name,
		"namespace": namespace,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	container.securityContext.privileged
	result = {
		"type": "privileged-security-context",
		"name": name,
		"container_name": container.name,
		"namespace": namespace,
	}
}

warning[result] {
	pod = pods[namespace][name]
	pod.spec.hostNetwork
	result = {
		"type": "connects-to-host-network",
		"name": name,
		"namespace": namespace,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	not container.securityContext.allowPrivilegeEscalation = false
	result = {
		"type": "bad-privilege-escalation",
		"name": name,
		"container_name": container.name,
		"namespace": namespace,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	dropped = {cap | cap = container.securityContext.capabilities.drop[_]}
	remaining = recommended_cap_drop - dropped
	count(remaining) > 0
	result = {
		"type": "bad-cap-not-dropped",
		"name": name,
		"container_name": container.name,
		"namespace": namespace,
		"not_dropped": remaining,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	added = {cap | cap = container.securityContext.capabilities.add[_]}
	remaining = recommended_cap_drop & added
	count(remaining) > 0
	result = {
		"type": "bad-cap-added",
		"name": name,
		"container_name": container.name,
		"namespace": namespace,
		"not_dropped": remaining,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	[image_name, image_tag] = split_image(container.image)
	warn_images[image_name][_] = image_tag
	result = {
		"type": "bad-image",
		"name": name,
		"namespace": namespace,
		"container_name": container.name,
		"image_name": image_name,
		"image_tag": image_tag,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	[image_name, "latest"] = split_image(container.image)
	result = {
		"type": "bad-latest-image",
		"name": name,
		"namespace": namespace,
		"container_name": container.name,
		"image_name": image_name,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	not container.securityContext.readOnlyRootFilesystem = true
	result = {
		"type": "read-only-root-fs",
		"name": name,
		"namespace": namespace,
		"container_name": container.name,
	}
}

warning[result] {
	containers[[namespace, name, container]]
	not container.securityContext.runAsNonRoot = true
	result = {
		"type": "run-as-non-root",
		"name": name,
		"namespace": namespace,
		"container_name": container.name,
	}
}

containers[[namespace, name, container]] {
	pod = pods[namespace][name]
	cs = pod_containers(pod)
	container = cs[_]
}

pod_containers(pod) = cs {
	keys = {"containers", "initContainers"}
	cs = [c | keys[k]; c = pod.spec[k][_]]
}

split_image(image) = [image, "latest"] {
	not contains(image, ":")
}

split_image(image) = [name, tag] {
	[name, tag] = split(image, ":")
}

missing_resources(container) {
	not container.resources.limits.cpu
}

recommended_cap_drop = {
	"AUDIT_WRITE",
	"CHOWN",
	"DAC_OVERRIDE",
	"FOWNER",
	"FSETID",
	"KILL",
	"MKNOD",
	"NET_BIND_SERVICE",
	"NET_RAW",
	"SETFCAP",
	"SETGID",
	"SETUID",
	"SETPCAP",
	"SYS_CHROOT",
}

missing_resources(container) {
	not container.resources.limits.memory
}

missing_resources(container) {
	not container.resources.requests.cpu
}

missing_resources(container) {
	not container.resources.requests.memory
}
