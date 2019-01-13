package library.kubernetes.admission.mutating

############################################################
# PATCH rules 
#
# Note: All patch rules should start with `isValidRequest` and `isCreateOrUpdate`
############################################################

# add foo label to Dogs if not present
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	not hasLabelValue[["foo", "bar"]] with input as input.request.object
	patchCode = makeLabelPatch("add", "foo", "bar", "")
}

# add baz label if it has label foo=bar
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	hasLabelValue[["foo", "bar"]] with input as input.request.object
	not hasLabelValue[["baz", "quux"]] with input as input.request.object
	patchCode = makeLabelPatch("add", "baz", "quux", "")
}

# add quuz label to Dogs if it's asking
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	hasLabelValue[["moar-labels", "pleez"]] with input as input.request.object
	patchCode = makeLabelPatch("add", "quuz", "corge", "")
}

# Dogs get a rating
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	not hasAnnotation.rating with input as input.request.object
	patchCode = makeAnnotationPatch("add", "rating", "14/10", "")
}
