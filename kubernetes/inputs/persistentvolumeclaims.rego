package library.kubernetes.inputs.persistentvolumeclaims

attributes = {
	"plugin": "AWS",
	"old": {"pvc": {
		"spec": {"size": 10},
		"status": {"phase": "ClaimBound"},
	}},
	"new": {"pvc": {"spec": {"size": 100}}},
}

attributes_fail_1 = {
	"plugin": "SomethingElse",
	"metadata": {
		"name": "nginx",
		"namespace": "default",
	},
}

attributes_fail_2 = {
	"plugin": "AWS",
	"old": {"pvc": {
		"spec": {"size": 1000},
		"status": {"phase": "ClaimBound"},
	}},
	"new": {"pvc": {"spec": {"size": 100}}},
}

attributes_fail_3 = {
	"plugin": "AWS",
	"old": {"pvc": {
		"spec": {"size": 1000},
		"status": {"phase": "Unbound"},
	}},
}

