package istio.audit

import data.istio.audit.vetter

all[result] {
	info[result]
}

all[result] {
	warning[result]
}

all[result] {
	error[result]
}

info[result] {
	vetter[_].info[result]
}

warning[result] {
	vetter[_].warning[result]
}

error[result] {
	vetter[_].error[result]
}

