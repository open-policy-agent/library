package istio.audit.vetter.pods_in_mesh

import data.istio.audit.util
import data.kubernetes.pods

info[result] {
	counts = [num | num = count(pods[namespace]); util.system_namespaces[namespace]]
	num_system_pods = sum(counts)
	result = {
		"type": "system-pod-count",
		"num_system_pods": num_system_pods,
	}
}

info[result] {
	total_counts = [num | num = count(pods[namespace]); not util.system_namespaces[namespace]]
	in_mesh_counts = [num | num = count(util.sidecar_injected_pods[namespace])]
	num_total_pods = sum(total_counts)
	num_in_mesh_pods = sum(in_mesh_counts)
	result = {
		"type": "user-pod-count",
		"num_user_pods": num_total_pods,
		"num_in_mesh_pods": num_in_mesh_pods,
	}
}
