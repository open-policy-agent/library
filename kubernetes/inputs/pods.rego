package library.kubernetes.inputs.pods

nginx_busybox = {
   "apiVersion": "v1",
   "kind": "Pod",
   "metadata": {
      "name": "nginx",
      "namespace": "default"
   },
   "spec": {
      "containers": [
         {
            "name": "nginx",
            "image": "nginx",
            "imagePullPolicy": "Always",
            "volumeMounts": [{
                  "name": "test",
                  "mountPath": "/data"
               }],
            "ports": [{"containerPort": 80}]
         },
         {
            "name": "busybox",
            "image": "busybox",
            "imagePullPolicy": "IfNotPresent",
            "ports": [{"containerPort": 8080}]
         }
      ],
      "initContainers": [
         {
            "name": "nginx",
            "image": "nginx",
            "imagePullPolicy": "Always",
            "volumeMounts": [{
                  "name": "test",
                  "mountPath": "/data"
               }],
            "ports": [{"containerPort": 80}]
         },
         {
            "name": "busybox",
            "image": "busybox",
            "imagePullPolicy": "IfNotPresent",
            "ports": [{"containerPort": 8080}]
         }
      ]   }
}

affinity1 = {
   "apiVersion": "v1",
   "kind": "Pod",
   "metadata": {
      "name": "with-pod-affinity"
   },
    "spec": {
      "affinity": {
         "podAntiAffinity": {
            "requiredDuringSchedulingIgnoredDuringExecution": [
               {
                  "weight": 100,
                  "podAffinityTerm": {
                     "labelSelector": {
                        "matchExpressions": [
                           {
                              "key": "security",
                              "operator": "In",
                              "values": [
                                 "S2"
                              ]
                           }
                        ]
                     },
                     "topologyKey": "kubernetes.io/hostname"
                  }
               }
            ]
         }
      },
      "containers": [
         {
            "name": "with-pod-affinity",
            "image": "gcr.io/google_containers/pause:2.0"
         }
      ]
   }
}

# spec.affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution
affinity2 = {
   "apiVersion": "v1",
   "kind": "Pod",
   "metadata": {
      "name": "with-pod-affinity"
   },
    "spec": {
      "affinity": {
         "podAntiAffinity": {
            "requiredDuringSchedulingIgnoredDuringExecution": [
               {
                  "weight": 100,
                  "podAffinityTerm": {
                     "labelSelector": {
                        "matchExpressions": [
                           {
                              "key": "security",
                              "operator": "In",
                              "values": [
                                 "S2"
                              ]
                           }
                        ]
                     },
                     "topologyKey": "failure-domain.beta.kubernetes.io/zone"
                  }
               }
            ]
         }
      },
      "containers": [
         {
            "name": "with-pod-affinity",
            "image": "gcr.io/google_containers/pause:2.0"
         }
      ]
   }
}