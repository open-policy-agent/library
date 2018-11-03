package istio.audit.util

import data.kubernetes.pods

system_namespaces = {
	"kube-system",
	"kube-public",
	"istio-system",
}

sidecar_injected_pods[namespace] = result {
	pods_in_namespace = pods[namespace]
	result = {name: pod | pods_in_namespace[name] = pod; is_sidecar_injected(pod)}
}

is_sidecar_injected(pod) {
	pod.metadata.annotations["sidecar.istio.io/status"]
	pod.spec.containers[_].name = "istio-proxy"
}
