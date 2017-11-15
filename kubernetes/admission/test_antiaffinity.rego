package library.kubernetes.admission.test_antiaffinity

import data.library.kubernetes.admission.antiaffinity
import data.library.kubernetes.inputs.pods

test_admit {
	r = pods.affinity1
	antiaffinity.admit = true with input as r
}

test_nonadmit {
	r = pods.affinity2
	antiaffinity.admit = false with input as r
}

