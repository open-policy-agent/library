package library.kubernetes.admission.test_loadbalancer
import data.library.kubernetes.admission.example_loadbalancer as loadbalancer
import data.library.kubernetes.admission.input.service

test_clusterip {
  # i := service.gen_input("ClusterIP", {}, null, null)
  i := service.loadbalancer
  count(loadbalancer.deny) == 0 with input as i
}

test_nodeport {
  i := service.gen_input("NodePort", {}, null, null)
  count(loadbalancer.deny) > 0 with input as i
}

test_externalname {
  i := service.gen_input("ExternalName", {}, null, null)
  count(loadbalancer.deny) > 0 with input as i
}

test_externalLB {
  i := service.gen_input("LoadBalancer", {}, null, null)
  count(loadbalancer.deny) > 0 with input as i
}

test_whitelisted_elb {
  i := service.gen_input("LoadBalancer", {}, "retail", "payment_lb")
  count(loadbalancer.deny) == 0 with input as i
}

test_internalLB {
  annot := {"cloud.google.com/load-balancer-type": "Internal"}
  i := service.gen_input("LoadBalancer", annot, null, null)
  count(loadbalancer.deny) == 0 with input as i
}

