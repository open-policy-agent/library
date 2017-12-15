package library.kubernetes.admission.test_persistentvolumeclaimresize

import data.library.kubernetes.admission.persistentvolumeclaimresize
import data.library.kubernetes.inputs.persistentvolumeclaims

test_verify {
	r = persistentvolumeclaims.attributes
	persistentvolumeclaimresize.verify with input as r
}

# check resize support policy
test_fail1 {
	r = persistentvolumeclaims.attributes_fail_1
	not persistentvolumeclaimresize.supportsResize with input as r
}

# check resize increase policy
test_fail2 {
	r = persistentvolumeclaims.attributes_fail_2
	not persistentvolumeclaimresize.allowSizeIncrease with input as r
}

# check claimbound policy
test_fail3 {
	r = persistentvolumeclaims.attributes_fail_3
	not persistentvolumeclaimresize.boundClaim with input as r
}

