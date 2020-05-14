package library.kubernetes.admission.test_loadbalancer

import data.library.kubernetes.admission.example_loadbalancer as loadbalancer
import data.library.kubernetes.admission.input.service

v1beta1 := "admission.k8s.io/v1beta1"

v1 := "admission.k8s.io/v1"

test_clusterip {
	i := service.loadbalancer
	count(loadbalancer.deny) == 0 with input as i
}

test_nodeport {
	i := service.gen_input("NodePort", {}, null, null, v1beta1, null)
	count(loadbalancer.deny) > 0 with input as i
}

test_externalname {
	i := service.gen_input("ExternalName", {}, null, null, v1beta1, null)
	count(loadbalancer.deny) > 0 with input as i
}

test_externalLB {
	i := service.gen_input("LoadBalancer", {}, null, null, v1beta1, null)
	count(loadbalancer.deny) > 0 with input as i
}

test_whitelisted_elb {
	i := service.gen_input("LoadBalancer", {}, "retail", "payment_lb", v1beta1, null)
	count(loadbalancer.deny) == 0 with input as i
}

test_internalLB {
	annot := {"cloud.google.com/load-balancer-type": "Internal"}
	i := service.gen_input("LoadBalancer", annot, null, null, v1beta1, null)
	count(loadbalancer.deny) == 0 with input as i
}

test_externalLB_apiv1 {
	uid := "mock-request-uid"
	i := service.gen_input("LoadBalancer", {}, null, null, v1, uid)
	count(loadbalancer.deny) > 0 with input as i
	result := loadbalancer.main with input as i
	result.apiVersion == v1
	result.response.uid == uid
}
