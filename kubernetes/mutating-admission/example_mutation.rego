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
	not hasLabelValue(input.request.object, "foo", "bar")
	patchCode = makeLabelPatch("add", "foo", "bar", "")
}

# add baz label if it has label foo=bar
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	hasLabelValue(input.request.object, "foo", "bar")
	not hasLabelValue(input.request.object, "baz", "quux")
	patchCode = makeLabelPatch("add", "baz", "quux", "")
}

# add quuz label to Dogs if it's asking
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	hasLabelValue(input.request.object, "moar-labels", "pleez")
	patchCode = makeLabelPatch("add", "quuz", "corge", "")
}

# Dogs get a rating
patch[patchCode] {
	isValidRequest
	isCreateOrUpdate
	input.request.kind.kind == "Dog"
	not hasAnnotation(input.request.object, "dogs.io/rating")
	patchCode = makeAnnotationPatch("add", "dogs.io/rating", "14/10", "")
}
