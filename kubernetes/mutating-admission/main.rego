package library.kubernetes.admission.mutating

###########################################################################
# Implementation of the k8s admission control external webhook interface,
# combining validating and mutating admission controllers
###########################################################################

main = {
	"apiVersion": "admission.k8s.io/v1beta1",
	"kind": "AdmissionReview",
	"response": response,
}

default response = {"allowed": true}

# non-patch response i.e. validation response
response = x {
	count(patch) = 0

	x := {
		"allowed": false,
		"status": {"reason": reason},
	}

	reason = concat(", ", deny)
	reason != ""
}

# patch response i.e. mutating respone
response = x {
	count(patch) > 0

	# if there are missing leaves e.g. trying to add a label to something that doesn't
	# yet have any, we need to create the leaf nodes as well

	fullPatches := ensureParentPathsExist(cast_array(patch))

	x := {
		"allowed": true,
		"patchType": "JSONPatch",
		"patch": base64.encode(json.marshal(fullPatches)),
	}
}

isValidRequest {
	# not sure if this might be a race condition, it might get called before
	# all the validation rules have been run
	count(deny) = 0
}

isCreateOrUpdate {
	isCreate
}

isCreateOrUpdate {
	isUpdate
}

isCreate {
	input.request.operation == "CREATE"
}

isUpdate {
	input.request.operation == "UPDATE"
}

###########################################################################
# PATCH helpers
# Note: These rules assume that the input is an object
# not an AdmissionRequest, because labels and annotations
# can apply to various sub-objects within a request
# So from the context of an AdmissionRequest they need to
# be called like
#   hasLabelValue("foo", "bar") with input as input.request.object
# or
#   hasLabelValue("foo", "bar") with input as input.request.oldObject
###########################################################################

hasLabels(obj) {
	obj.metadata.labels
}

hasLabel(obj, label) {
	obj.metadata.labels[label]
}

hasLabelValue(obj, key, val) {
	obj.metadata.labels[key] = val
}

hasAnnotations(obj) {
	obj.metadata.annotations
}

hasAnnotation(obj, annotation) {
	obj.metadata.annotations[annotation]
}

hasAnnotationValue(obj, key, val) {
	obj.metadata.annotations[key] = val
}

###########################################################################
# makeLabelPatch creates a label patch
# Labels can exist on numerous child objects e.g. Deployment.template.metadata
# Use pathPrefix to specify a lower level object, or pass "" to select the
# top level object
# Note: pathPrefix should have a leading '/' but no trailing '/'
###########################################################################

makeLabelPatch(op, key, value, pathPrefix) = patchCode {
	patchCode = {
		"op": op,
		"path": concat("/", [pathPrefix, "metadata/labels", replace(key, "/", "~1")]),
		"value": value,
	}
}

makeAnnotationPatch(op, key, value, pathPrefix) = patchCode {
	patchCode = {
		"op": op,
		"path": concat("/", [pathPrefix, "metadata/annotations", replace(key, "/", "~1")]),
		"value": value,
	}
}

# Given array of JSON patches create and prepend new patches that create missing paths.
ensureParentPathsExist(patches) = result {
	# Convert patches to a set
	paths := {p.path | p := patches[_]}
	# Compute all missing subpaths.
	#    Iterate over all paths and over all subpaths
	#    If subpath doesn't exist, add it to the set after making it a string
	missingPaths := {sprintf("/%s", [concat("/", prefixPath)]) |
		paths[path]
		pathArray := split(path, "/")
		pathArray[i]  # walk over path
		i > 0    # skip initial element
		# array of all elements in path up to i
		prefixPath := [pathArray[j] | pathArray[j]; j < i; j > 0]  # j > 0: skip initial element
		walkPath := [toWalkElement(x) | x := prefixPath[_]]
		not inputPathExists(walkPath) with input as input.request.object
	}
	# Sort paths, to ensure they apply in correct order
	ordered_paths := sort(missingPaths)

	# Return new patches prepended to original patches.
	#  Don't forget to prepend all paths with a /
	new_patches := [{"op": "add", "path": p, "value": {}} |
			         p := ordered_paths[_] ]
	result := array.concat(new_patches, patches)
}

# Check that the given @path exists as part of the input object.
inputPathExists(path) {
	walk(input, [path, _])
}

toWalkElement(str) = str {
	not re_match("^[0-9]+$", str)
}
toWalkElement(str) = x {
	re_match("^[0-9]+$", str)
	x := to_number(str)
}

# Dummy deny and patch to please the compiler

deny[msg] {
	input.request.kind == "AdmissionReview"
	msg = "Input must be Kubernetes AdmissionRequest"
}

patch[patchCode] {
	input.kind == "ThisHadBetterNotBeARealKind"
	patchCode = {}
}
