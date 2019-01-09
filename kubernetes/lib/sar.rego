package kubernetes.lib

# These functions are intended to be used with the kubernetes proxy doing authentication for you.
# Run something like:
# kubectl proxy --accept-paths='^/apis/authorization.k8s.io/v1/subjectaccessreviews$'

import data.kubernetes.lib

sar_raw(resourceAttributes, user, groups) = output {
	body := {
		"apiVersion": "authorization.k8s.io/v1",
		"kind": "SubjectAccessReview",
		"spec": {
			"resourceAttributes": resourceAttributes,
			"user": user,
			"groups": groups,
		},
	}

	req := {
		"method": "post",
		"url": "http://127.0.0.1:8001/apis/authorization.k8s.io/v1/subjectaccessreviews",
		"headers": {"Content-Type": "application/json"},
		"body": body,
	}

	http.send(req, output)
}

sar_allowed(resourceAttributes, user, groups) = allowed {
	output := sar_raw(resourceAttributes, user, groups)
	output.status_code == 201
	allowed = output.body.status.allowed
}
