package istio.audit.vetter.mesh_version

import data.istio.audit.util
import data.kubernetes.deployments

info[result] {
	istio_version = "latest"
	result = {"type": "missing-version"}
}

warning[result] {
	istio_version != pilot_version
	result = {
		"type": "istio-component-mismatch",
		"name": "pilot",
		"version": pilot_version,
		"istio_version": istio_version,
	}
}

warning[result] {
	pod = util.sidecar_injected_pods[namespace][name]
	v = proxy_version(pod)
	v != "latest"
	v != istio_version
	result = {
		"type": "sidecar-mismatch",
		"name": name,
		"namespace": namespace,
		"proxy_version": v,
		"istio_version": istio_version,
	}
}

pilot_version = v {
	container = deployments["istio-system"]["istio-pilot"].spec.template.spec.containers[_]
	container.name = "discovery"
	v = get_version(container.image)
}

istio_version = v {
	container = deployments["istio-system"]["istio-mixer"].spec.template.spec.containers[_]
	container.name = "mixer"
	v = get_version(container.image)
}

proxy_version(pod) = v {
	container = proxy_container(pod)
	v = get_version(container.image)
}

proxy_container(pod) = container {
	pod.spec.containers[_] = container
	container.name = "istio-proxy"
}

get_version(image) = v {
	parts = split(image, ":")
	v = parts[1]
}

get_version(image) = "latest" {
	parts = split(image, ":")
	num_parts = count(parts)
	num_parts < 2
}

