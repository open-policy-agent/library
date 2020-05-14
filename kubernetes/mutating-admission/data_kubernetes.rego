package library.kubernetes.admission.mutating.test

request_default = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1",
	"request": {""},
}

# Using a CRD for a resource called Dog, with a CRD definition as follows:
# apiVersion: apiextensions.k8s.io/v1beta1
# kind: CustomResourceDefinition
# metadata:
#   name: dogs.frens.teq0.com
# spec:
#   group: frens.teq0.com
#   versions:
#     - name: v1
#       served: true
#       storage: true
#   version: v1
#   scope: Cluster
#   names:
#     plural: dogs
#     singular: dog
#     kind: Dog
#     shortNames:
#     - dogue
#   validation:
#     openAPIV3Schema:
#       properties:
#         spec:
#           properties:
#             name:
#               type: string
#             isGood:
#               type: boolean
#             food:
#               type: string

request_dog_good = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo": "bar"},
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo": "bar1"},
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_some_labels_and_annotations = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {
					"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n",
					"allthethings": "automate",
				},
				"labels": {
					"gamma-rays": "on",
					"yobba-rays": "on",
					"moar-labels": "pleez",
				},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_existing_labels_and_annotations = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"dogs.io/rating": "14/10"},
				"labels": {
					"foo": "bar",
					"quuz": "corge",
				},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_no_labels_or_annotations = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_bad = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "rex",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo": "bar1"},
				"name": "rex",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Rex",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo1": "bar1"},
				"name": "rex",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Rex",
			},
		},
		"dryRun": false,
	},
}

# Simple sub-objects for testing the helper functions
object_with_label_foo_bar = {"metadata": {"labels": {"foo": "bar"}}}

object_without_labels = {"metadata": {"annotations": {"foo": "bar"}}}

object_with_annotation_foo_bar = {"metadata": {"annotations": {"foo": "bar"}}}

object_without_annotations = {"metadata": {"labels": {"foo": "bar"}}}

object_without_labels_or_annotations = {"metadata": {}}

# Standard K8s Deployment requests

request_deployment_no_versions = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "7916f3dc-1393-11e9-8ef2-080027da5735",
		"kind": {
			"group": "extensions",
			"version": "v1beta1",
			"kind": "Deployment",
		},
		"resource": {
			"group": "extensions",
			"version": "v1beta1",
			"resource": "deployments",
		},
		"namespace": "default",
		"operation": "CREATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"metadata": {
				"name": "deployment-demo-bad-no-version",
				"namespace": "default",
				"creationTimestamp": null,
				"labels": {
					"demo": "deployment",
					"version": "v1",
				},
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"extensions/v1beta1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{},\"name\":\"deployment-demo-bad-no-version\",\"namespace\":\"default\"},\"spec\":{\"replicas\":2,\"selector\":{\"matchLabels\":{\"demo\":\"deployment\"}},\"strategy\":{\"rollingUpdate\":{\"maxSurge\":1,\"maxUnavailable\":0},\"type\":\"RollingUpdate\"},\"template\":{\"metadata\":{\"labels\":{\"demo\":\"deployment\",\"version\":\"v1\"}},\"spec\":{\"containers\":[{\"command\":[\"sh\",\"-c\",\"while true; do echo $(hostname) v1 \\u003e /data/index.html; sleep 60; done\"],\"image\":\"busybox\",\"name\":\"busybox\",\"volumeMounts\":[{\"mountPath\":\"/data\",\"name\":\"content\"}]},{\"image\":\"nginx\",\"name\":\"nginx\",\"volumeMounts\":[{\"mountPath\":\"/usr/share/nginx/html\",\"name\":\"content\",\"readOnly\":true}]}],\"volumes\":[{\"name\":\"content\"}]}}}}\n"},
			},
			"spec": {
				"replicas": 2,
				"selector": {"matchLabels": {"demo": "deployment"}},
				"template": {
					"metadata": {
						"creationTimestamp": null,
						"labels": {
							"demo": "deployment",
							"version": "v1",
						},
					},
					"spec": {
						"volumes": [{
							"name": "content",
							"emptyDir": {},
						}],
						"containers": [
							{
								"name": "busybox",
								"image": "busybox",
								"command": [
									"sh",
									"-c",
									"while true; do echo $(hostname) v1 > /data/index.html; sleep 60; done",
								],
								"resources": {},
								"volumeMounts": [{
									"name": "content",
									"mountPath": "/data",
								}],
								"terminationMessagePath": "/dev/termination-log",
								"terminationMessagePolicy": "File",
								"imagePullPolicy": "Always",
							},
							{
								"name": "nginx",
								"image": "nginx",
								"resources": {},
								"volumeMounts": [{
									"name": "content",
									"readOnly": true,
									"mountPath": "/usr/share/nginx/html",
								}],
								"terminationMessagePath": "/dev/termination-log",
								"terminationMessagePolicy": "File",
								"imagePullPolicy": "Always",
							},
						],
						"restartPolicy": "Always",
						"terminationGracePeriodSeconds": 30,
						"dnsPolicy": "ClusterFirst",
						"securityContext": {},
						"schedulerName": "default-scheduler",
					},
				},
				"strategy": {
					"type": "RollingUpdate",
					"rollingUpdate": {
						"maxUnavailable": 0,
						"maxSurge": 1,
					},
				},
				"revisionHistoryLimit": 2147483647,
				"progressDeadlineSeconds": 2147483647,
			},
			"status": {},
		},
		"oldObject": null,
		"dryRun": false,
	},
}

request_deployment_with_versions = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "7916f3dc-1393-11e9-8ef2-080027da5735",
		"kind": {
			"group": "extensions",
			"version": "v1beta1",
			"kind": "Deployment",
		},
		"resource": {
			"group": "extensions",
			"version": "v1beta1",
			"resource": "deployments",
		},
		"namespace": "default",
		"operation": "CREATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"metadata": {
				"name": "deployment-demo-bad-no-version",
				"namespace": "default",
				"creationTimestamp": null,
				"labels": {
					"demo": "deployment",
					"version": "v1",
				},
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"extensions/v1beta1\",\"kind\":\"Deployment\",\"metadata\":{\"annotations\":{},\"name\":\"deployment-demo-bad-no-version\",\"namespace\":\"default\"},\"spec\":{\"replicas\":2,\"selector\":{\"matchLabels\":{\"demo\":\"deployment\"}},\"strategy\":{\"rollingUpdate\":{\"maxSurge\":1,\"maxUnavailable\":0},\"type\":\"RollingUpdate\"},\"template\":{\"metadata\":{\"labels\":{\"demo\":\"deployment\",\"version\":\"v1\"}},\"spec\":{\"containers\":[{\"command\":[\"sh\",\"-c\",\"while true; do echo $(hostname) v1 \\u003e /data/index.html; sleep 60; done\"],\"image\":\"busybox\",\"name\":\"busybox\",\"volumeMounts\":[{\"mountPath\":\"/data\",\"name\":\"content\"}]},{\"image\":\"nginx\",\"name\":\"nginx\",\"volumeMounts\":[{\"mountPath\":\"/usr/share/nginx/html\",\"name\":\"content\",\"readOnly\":true}]}],\"volumes\":[{\"name\":\"content\"}]}}}}\n"},
			},
			"spec": {
				"replicas": 2,
				"selector": {"matchLabels": {"demo": "deployment"}},
				"template": {
					"metadata": {
						"creationTimestamp": null,
						"labels": {
							"demo": "deployment",
							"version": "v1",
						},
					},
					"spec": {
						"volumes": [{
							"name": "content",
							"emptyDir": {},
						}],
						"containers": [
							{
								"name": "busybox",
								"image": "busybox:1.30.0",
								"command": [
									"sh",
									"-c",
									"while true; do echo $(hostname) v1 > /data/index.html; sleep 60; done",
								],
								"resources": {},
								"volumeMounts": [{
									"name": "content",
									"mountPath": "/data",
								}],
								"terminationMessagePath": "/dev/termination-log",
								"terminationMessagePolicy": "File",
								"imagePullPolicy": "Always",
							},
							{
								"name": "nginx",
								"image": "nginx:1.15.8",
								"resources": {},
								"volumeMounts": [{
									"name": "content",
									"readOnly": true,
									"mountPath": "/usr/share/nginx/html",
								}],
								"terminationMessagePath": "/dev/termination-log",
								"terminationMessagePolicy": "File",
								"imagePullPolicy": "Always",
							},
						],
						"restartPolicy": "Always",
						"terminationGracePeriodSeconds": 30,
						"dnsPolicy": "ClusterFirst",
						"securityContext": {},
						"schedulerName": "default-scheduler",
					},
				},
				"strategy": {
					"type": "RollingUpdate",
					"rollingUpdate": {
						"maxUnavailable": 0,
						"maxSurge": 1,
					},
				},
				"revisionHistoryLimit": 2147483647,
				"progressDeadlineSeconds": 2147483647,
			},
			"status": {},
		},
		"oldObject": null,
		"dryRun": false,
	},
}
