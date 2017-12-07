package kubernetes.audit.deployments

import data.kubernetes.deployments

warning[result] {
	deployment = deployments[namespace][name]
	volume = deployment.spec.template.spec.volumes[_]
	volume.persistent_volume_claim
	not deployment.spec.strategy.type = "Recreate"
	result = {
		"type": "bad-update-strategy",
		"name": name,
		"namespace": namespace,
	}
}

