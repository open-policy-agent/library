package library.kubernetes.admission.test_alwayspullimages

import data.library.kubernetes.admission.alwayspullimages
import data.library.kubernetes.inputs.pods

test_admit {
	r = pods.nginx_busybox
	alwayspullimages.admit = false with input as r
}

test_overwrites {
	r = pods.nginx_busybox
	overwrites = alwayspullimages.overwrite with input as r
	count(overwrites, 2)
}

