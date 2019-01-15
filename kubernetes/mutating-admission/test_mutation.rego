package library.kubernetes.admission.mutating

import data.library.kubernetes.admission.mutating.test as k8s

############################################################
# PATCH helper tests 
############################################################

#-----------------------------------------------------------
# Test: hasLabels is true when there are labels
#-----------------------------------------------------------
test_hasLabels_true {
	hasLabels(k8s.object_with_label_foo_bar)
}

#-----------------------------------------------------------
# Test: hasLabels is false when there are no labels
#-----------------------------------------------------------
test_no_labels_true {
	not hasLabels(k8s.object_without_labels)
}

#-----------------------------------------------------------
# Test: hasLabel is true when the label exists
#-----------------------------------------------------------
test_hasLabel_foo {
	hasLabel(k8s.object_with_label_foo_bar, "foo")
}

#-----------------------------------------------------------
# Test: hasLabel is false when the label doesn't exist
#-----------------------------------------------------------
test_not_hasLabel_foo1 {
	not hasLabel(k8s.object_with_label_foo_bar, "foo1")
}

#-----------------------------------------------------------
# Test: hasLabelValue is true when the label has the correct value
#-----------------------------------------------------------
test_hasLabelValue_fooeqbar {
	hasLabelValue(k8s.object_with_label_foo_bar, "foo", "bar")
}

#-----------------------------------------------------------
# Test: hasAnnotations is true when there are annotations
#-----------------------------------------------------------
test_hasAnnotations_true {
	hasAnnotations(k8s.object_with_annotation_foo_bar)
}

#-----------------------------------------------------------
# Test: hasAnnotations is false when there are no annotations
#-----------------------------------------------------------
test_no_annotations_true {
	not hasAnnotations(k8s.object_without_annotations)
}

#-----------------------------------------------------------
# Test: hasAnnotation is true when the annotation exists
#-----------------------------------------------------------
test_hasAnnotation_foo {
	hasAnnotation(k8s.object_with_annotation_foo_bar, "foo")
}

#-----------------------------------------------------------
# Test: hasAnnotation is false when the annotation doesn't exist
#-----------------------------------------------------------
test_not_hasAnnotation_foo1 {
	not hasAnnotation(k8s.object_with_annotation_foo_bar, "foo1")
}

#-----------------------------------------------------------
# Test: hasAnnotationValue is true when the annotation has the correct value
#-----------------------------------------------------------
test_hasAnnotation_fooeqbar {
	hasAnnotationValue(k8s.object_with_annotation_foo_bar, "foo", "bar")
}

#-----------------------------------------------------------
# Test: makeLabelPatch creates a valid patch
#-----------------------------------------------------------
test_makeLabelPatch {
	l := makeLabelPatch("add", "foo", "bar", "") with input as k8s.object_with_label_foo_bar
	l = {"op": "add", "path": "/metadata/labels/foo", "value": "bar"}

	# test pathPrefix e.g. if the label is on the Pod template in a Deployment
	m := makeLabelPatch("add", "foo", "bar", "/spec/template") with input as k8s.object_with_label_foo_bar
	m = {"op": "add", "path": "/spec/template/metadata/labels/foo", "value": "bar"}
}

############################################################
# PATCH tests 
############################################################

#-----------------------------------------------------------
# Sample patch values to test against
#-----------------------------------------------------------
patchCode_labels_base = {
	"op": "add",
	"path": "/metadata/labels",
	"value": {},
}

patchCode_label_foobar = {
	"op": "add",
	"path": "/metadata/labels/foo",
	"value": "bar",
}

patchCode_label_bazquux = {
	"op": "add",
	"path": "/metadata/labels/baz",
	"value": "quux",
}

patchCode_label_quuzcorge = {
	"op": "add",
	"path": "/metadata/labels/quuz",
	"value": "corge",
}

patchCode_annotations_base = {
	"op": "add",
	"path": "/metadata/annotations",
	"value": {},
}

patchCode_annotation_rating = {
	"op": "add",
	"path": "/metadata/annotations/rating",
	"value": "14/10",
}

hasPatch(patches, patch) {
	patches[_] = patch
}

isPatchResponse(res) {
	res.response.patchType = "JSONPatch"
	res.response.patch
}

#-----------------------------------------------------------
# Test: patches are created for Dogs with no labels
#-----------------------------------------------------------
test_main_dog_no_labels_or_annotations {
	res := main with input as k8s.request_dog_no_labels_or_annotations
	res.response.allowed = true
	isPatchResponse(res)
	patches = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf("[test_main_dog_no_labels] patches = '%s'", [patches]))
	hasPatch(patches, patchCode_labels_base)
	hasPatch(patches, patchCode_label_foobar)
	hasPatch(patches, patchCode_annotations_base)
	hasPatch(patches, patchCode_annotation_rating)
}

#-----------------------------------------------------------
# Test: patches are created for Dogs with existing labels but not foo
#-----------------------------------------------------------
test_main_dog_some_labels {
	res := main with input as k8s.request_dog_some_labels_and_annotations
	res.response.allowed = true
	isPatchResponse(res)
	patches = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf("[test_main_dog_some_labels] patches = '%s'", [patches]))
	not hasPatch(patches, patchCode_labels_base)
	hasPatch(patches, patchCode_label_foobar)
	not hasPatch(patches, patchCode_annotations_base)
	hasPatch(patches, patchCode_annotation_rating)
}

#-----------------------------------------------------------
# Test: patches are not created for Dogs with existing labels foo and quuz and annotation rating
# We need to test for either no patches at all are created, or
# if some other rule creates some patches, it's not trying to 
# add any that already exist
#-----------------------------------------------------------
test_main_dog_existing_labels_and_annotations {
	res := main with input as k8s.request_dog_existing_labels_and_annotations
	trace(sprintf("[test_main_dog_existing_labels_and_annotations] res = '%s'", [res]))
	res.response.allowed = true
	t_main_dog_existing_labels_and_annotations_detail with input as res
}

t_main_dog_existing_labels_and_annotations_detail {
	not input.response.patchType
	trace("[t_main_dog_existing_labels_and_annotations] patchType not set")
}

t_main_dog_existing_labels_and_annotations_detail {
	input.response.patchType = "JSONPatch"
	input.response.patch
	patches = json.unmarshal(base64url.decode(input.response.patch))
	trace(sprintf("[t_main_dog_existing_labels_and_annotations] patches = '%s'", [patches]))
	not hasPatch(patches, patchCode_labels_base)
	not hasPatch(patches, patchCode_label_foobar)
	not hasPatch(patches, patchCode_label_quuzcorge)
	not hasPatch(patches, patchCode_annotations_base)
	not hasPatch(patches, patchCode_annotation_rating)
}

#-----------------------------------------------------------
# Test: patches are created for Dogs wanting more labels
#-----------------------------------------------------------
test_main_dog_missing_label_quuzcorge {
	res := main with input as k8s.request_dog_some_labels_and_annotations
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	patches = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf("[test_main_dog_good_missing_label_quuzcorge] patches = '%s'", [patches]))
	hasPatch(patches, patchCode_label_quuzcorge)
}

#-----------------------------------------------------------
# Test: patches are created for Dogs with no anotations
#-----------------------------------------------------------
test_main_dog_add_first_annotation {
	res := main with input as k8s.request_dog_no_labels_or_annotations
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	patches = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf("[test_main_dog_add_first_annotation] patches = '%s'", [patches]))
	hasPatch(patches, patchCode_annotations_base)
	hasPatch(patches, patchCode_annotation_rating)
}

#-----------------------------------------------------------
# Test: patches are created for Dogs with existing annotation
#-----------------------------------------------------------
test_main_dog_add_subsequent_annotation {
	res := main with input as k8s.request_dog_some_labels_and_annotations
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	patches = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf("[test_main_dog_add_subsequent_annotation] patches = '%s'", [patches]))
	not hasPatch(patches, patchCode_annotations_base)
	hasPatch(patches, patchCode_annotation_rating)
}
