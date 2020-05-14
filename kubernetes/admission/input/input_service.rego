package library.kubernetes.admission.input.service

# kubectl-create on the following resources causes an admission control request to OPA shown below.

# kind: Service
# apiVersion: v1
# metadata:
#   name: my-service
# spec:
#   selector:
#     app: MyApp
#   ports:
#   - protocol: TCP
#     port: 80
#     targetPort: 9376
#   type: LoadBalancer

loadbalancer = {
	"apiVersion": "admission.k8s.io/v1beta1",
	"kind": "AdmissionReview",
	"request": {
		"kind": {
			"group": "",
			"kind": "Service",
			"version": "v1",
		},
		"namespace": "opa",
		"object": {
			"metadata": {
				"annotations": {"cloud.google.com/load-balancer-type": "Internal"},
				"creationTimestamp": "2018-10-30T23:30:00Z",
				"name": "my-service",
				"namespace": "opa",
				"uid": "b82becfa-dc9b-11e8-9aa6-080027ca3112",
			},
			"spec": {
				"clusterIP": "10.97.228.185",
				"externalTrafficPolicy": "Cluster",
				"ports": [{
					"nodePort": 30431,
					"port": 80,
					"protocol": "TCP",
					"targetPort": 9376,
				}],
				"selector": {"app": "MyApp"},
				"sessionAffinity": "None",
				"type": "LoadBalancer",
			},
			"status": {"loadBalancer": {}},
		},
		"oldObject": null,
		"operation": "CREATE",
		"resource": {
			"group": "",
			"resource": "services",
			"version": "v1",
		},
		"uid": "b82bef5f-dc9b-11e8-9aa6-080027ca3112",
		"userInfo": {
			"groups": [
				"system:masters",
				"system:authenticated",
			],
			"username": "minikube-user",
		},
	},
}

endpoint = {
	"apiVersion": "admission.k8s.io/v1beta1",
	"kind": "AdmissionReview",
	"request": {
		"kind": {
			"group": "",
			"kind": "Endpoints",
			"version": "v1",
		},
		"namespace": "opa",
		"object": {"metadata": {
			"creationTimestamp": "2018-10-30T22:27:53Z",
			"name": "my-service",
			"namespace": "opa",
			"uid": "0aa3ffe1-dc93-11e8-9aa6-080027ca3112",
		}},
		"oldObject": null,
		"operation": "CREATE",
		"resource": {
			"group": "",
			"resource": "endpoints",
			"version": "v1",
		},
		"uid": "0aa40243-dc93-11e8-9aa6-080027ca3112",
		"userInfo": {
			"groups": [
				"system:serviceaccounts",
				"system:serviceaccounts:kube-system",
				"system:authenticated",
			],
			"uid": "1c8daa54-dc91-11e8-9aa6-080027ca3112",
			"username": "system:serviceaccount:kube-system:endpoint-controller",
		},
	},
}

gen_input(type, annotations, namespace, name, apiVersion, uid) = x {
	x = {
		"apiVersion": apiVersion,
		"kind": "AdmissionReview",
		"request": {
			"kind": {
				"group": "",
				"kind": "Service",
				"version": "v1",
			},
			"namespace": namespace,
			"object": {
				"metadata": {
					"annotations": annotations,
					"creationTimestamp": "2018-10-30T22:27:53Z",
					"name": name,
					"namespace": namespace,
					"uid": "0aa31220-dc93-11e8-9aa6-080027ca3112",
				},
				"spec": {
					"clusterIP": "10.106.113.106",
					"externalTrafficPolicy": "Cluster",
					"ports": [{
						"nodePort": 32153,
						"port": 80,
						"protocol": "TCP",
						"targetPort": 9376,
					}],
					"selector": {"app": "MyApp"},
					"sessionAffinity": "None",
					"type": type,
				},
				"status": {"loadBalancer": {}},
			},
			"oldObject": null,
			"operation": "CREATE",
			"resource": {
				"group": "",
				"resource": "services",
				"version": "v1",
			},
			"uid": uid,
			"userInfo": {
				"groups": [
					"system:masters",
					"system:authenticated",
				],
				"username": "minikube-user",
			},
		},
	}
}
