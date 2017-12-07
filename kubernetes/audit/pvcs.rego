package kubernetes.audit.pvcs

import data.kubernetes.pods

warning[result] {
	pod = pods[namespace][name]
	volume = pod.volumes[_]
	volume.persistent_volume_clain
	container = pod.spec.containers[_]
	mount = container.volume_mounts[_]
	mount.name = volume.name
	not mount.sub_path
	result = {
		"type": "missing-pvc-sub-path",
		"name": name,
		"container_name": container.name,
		"namespace": namespace,
	}
}

