package library.kubernetes.admission.persistentvolumeclaimresize

# https://github.com/kubernetes/kubernetes/tree/master/plugin/pkg/admission/persistentvolume/resize/admission.go
# https://github.com/kubernetes/kubernetes/tree/master/plugin/pkg/admission/persistentvolume/resize/admission_test.go

# plugins supporting resize
plugins = {
    "GlusterFS", "Cinder", "AWS", "GCE", "RDS"
}

# volume plugin needs to support resize
supportsResize = true {
    plugins[input.plugin]
}

# we can only expand the size of a pvc
allowSizeIncrease = true {
    oldSize = input.old.pvc.spec.size
	newSize = input.new.pvc.spec.size
	oldSize <= newSize
}

# Only bound persistent volume claims can be expanded
boundClaim = true {
    input.old.pvc.status.phase = "ClaimBound"
}

verify = true {
    supportsResize
    allowSizeIncrease
    boundClaim
}
