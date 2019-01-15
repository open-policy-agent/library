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
		"patch": base64url.encode(json.marshal(fullPatches)),
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

hasLabels {
	input.metadata.labels
}

hasLabel(label) {
	input.metadata.labels[label]
}

hasLabelValue(key, val) {
	input.metadata.labels[key] = val
}

hasAnnotations {
	input.metadata.annotations
}

hasAnnotation(annotation) {
	input.metadata.annotations[annotation]
}

hasAnnotationValue(key, val) {
	input.metadata.annotations[key] = val
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
		"path": concat("/", [pathPrefix, "metadata/labels", key]),
		"value": value,
	}
}

makeAnnotationPatch(op, key, value, pathPrefix) = patchCode {
	patchCode = {
		"op": op,
		"path": concat("/", [pathPrefix, "metadata/annotations", key]),
		"value": value,
	}
}

# Given array of JSON patches create and prepend new patches that create missing paths.
ensureParentPathsExist(patches) = result {
	paths := {p.path | p := patches[_]}
	newPatches := {makePath(prefixArray) |
		paths[path]
		fullLength := count(path)
		pathArray := split(path, "/")

		# Need a slice of the path_array with all but the last element.
		# No way to do that with arrays, but we can do it with strings.
		arrayLength := count(pathArray)
		lastElementLength := count(pathArray[minus(arrayLength, 1)])

		# this assumes paths starts with '/'
		prefixPath := substring(path, 1, (fullLength - lastElementLength) - 2)
		prefixArray := split(prefixPath, "/")
		not inputPathExists(prefixArray) with input as input.request.object
	}

	result := array.concat(cast_array(newPatches), patches)
}

# Create the JSON patch to ensure the @path_array exists
makePath(pathArray) = result {
	pathStr := concat("/", array.concat([""], pathArray))

	result = {
		"op": "add",
		"path": pathStr,
		"value": {},
	}
}

# Check that the given @path exists as part of the input object.
inputPathExists(path) {
	walk(input, [path, _])
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
