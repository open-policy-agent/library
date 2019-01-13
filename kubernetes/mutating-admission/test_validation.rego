package library.kubernetes.admission.mutating

import data.library.kubernetes.admission.mutating.test as k8s

############################################################
# DENY tests 
############################################################

#-----------------------------------------------------------
# Test: the default validation rule is ALLOW
#-----------------------------------------------------------
test_main_default_allow {
	res := main with input as k8s.request_default
	res.response.allowed
}

#-----------------------------------------------------------
# Test: Dogs with isGood = true are allowed
#-----------------------------------------------------------
test_main_dog_good_allow {
	res := main with input as k8s.request_dog_good
	res.response.allowed = true
}

#-----------------------------------------------------------
# Test: Dogs with isGood = false are rejected (They're good dogs, Brent)
#-----------------------------------------------------------
test_main_dog_bad_deny {
	res := main with input as k8s.request_dog_bad
	res.response.allowed = false
}

#-----------------------------------------------------------
# Test: Deployment container images must have version tags
#-----------------------------------------------------------
test_container_images_must_have_versions {
	res := main with input as k8s.request_deployment_no_versions
	trace(sprintf("[test_container_images_must_have_versions] msg = %s", [res.response.status.reason]))
	res.response.allowed = false
}

#-----------------------------------------------------------
# Test: Deployment container images with valid version tags are allowed
#-----------------------------------------------------------
test_container_images_with_versions_are_allowed {
	res := main with input as k8s.request_deployment_with_versions
	res.response.allowed = true
}
