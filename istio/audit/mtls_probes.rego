package istio.audit.vetter.mtls_probes

import data.istio.audit.util
import data.kubernetes.configmaps

error[result] {
	mtls_enabled
	pod = util.sidecar_injected_pods[namespace][name]
	container = pod.spec.containers[_]
	container.livenessProbe
	not container.livenessProbe.exec
	result = {
		"type": "mtls-probes-incompatible",
		"probe": "liveness",
		"name": name,
		"namespace": namespace,
	}
}

error[result] {
	mtls_enabled
	pod = util.sidecar_injected_pods[namespace][name]
	container = pod.spec.containers[_]
	container.readinessProbe
	not container.readinessProbe.exec
	result = {
		"type": "mtls-probes-incompatible",
		"probe": "readiness",
		"name": name,
		"namespace": namespace,
	}
}

mtls_enabled {
	cm = configmaps["istio-system"].istio
	mesh_config = yaml.unmarshal(cm.data.mesh)
	mesh_config.authPolicy = "MUTUAL_TLS"
}

