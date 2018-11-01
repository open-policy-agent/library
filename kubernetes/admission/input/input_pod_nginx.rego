package library.kubernetes.admission_inputs.pod

# kubectl-create on the following resources causes an admission control request to OPA shown below.
# kind: Pod
# apiVersion: v1
# metadata:
#   name: nginx
#   labels:
#     app: nginx
# spec:
#   containers:
#   - image: nginx
#     name: nginx


nginx =
{
    "apiVersion": "admission.k8s.io/v1beta1",
    "kind": "AdmissionReview",
    "request": {
        "kind": {
            "group": "",
            "kind": "Pod",
            "version": "v1"
        },
        "namespace": "opa",
        "object": {
            "metadata": {
                "creationTimestamp": "2018-10-27T02:12:20Z",
                "labels": {
                    "app": "nginx"
                },
                "name": "nginx",
                "namespace": "opa",
                "uid": "bbfee96d-d98d-11e8-b280-080027868e77"
            },
            "spec": {
                "containers": [{
                    "image": "nginx",
                    "imagePullPolicy": "Always",
                    "name": "nginx",
                    "resources": {},
                    "terminationMessagePath": "/dev/termination-log",
                    "terminationMessagePolicy": "File",
                    "volumeMounts": [{
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                        "name": "default-token-tm9v8",
                        "readOnly": true
                    }]
                }],
                "dnsPolicy": "ClusterFirst",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {},
                "serviceAccount": "default",
                "serviceAccountName": "default",
                "terminationGracePeriodSeconds": 30,
                "tolerations": [{
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/not-ready",
                        "operator": "Exists",
                        "tolerationSeconds": 300
                    },
                    {
                        "effect": "NoExecute",
                        "key": "node.kubernetes.io/unreachable",
                        "operator": "Exists",
                        "tolerationSeconds": 300
                    }
                ],
                "volumes": [{
                    "name": "default-token-tm9v8",
                    "secret": {
                        "secretName": "default-token-tm9v8"
                    }
                }]
            },
            "status": {
                "phase": "Pending",
                "qosClass": "BestEffort"
            }
        },
        "oldObject": null,
        "operation": "CREATE",
        "resource": {
            "group": "",
            "resource": "pods",
            "version": "v1"
        },
        "uid": "bbfeef88-d98d-11e8-b280-080027868e77",
        "userInfo": {
            "groups": [
                "system:masters",
                "system:authenticated"
            ],
            "username": "minikube-user"
        }
    }
}
