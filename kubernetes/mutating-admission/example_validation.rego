package library.kubernetes.admission.mutating

############################################################
# DENY rules
############################################################

# Check for bad dogs
deny[msg] {
	isCreateOrUpdate
	input.request.kind.kind = "Dog"
	input.request.object.spec.isGood = false
	msg = sprintf("%s is a good dog, Brent", [input.request.object.spec.name])
}

# Don't allow container images with no version tag, or a version tag that doesn't contain at least one digit

missingImageVersion(imageName) {
	not re_match(`.*:.*\d.*$`, imageName)
}

deny[msg] {
	input.request.kind.kind = "Deployment"
	badImages = {image |
		image = input.request.object.spec.template.spec.containers[_].image
		missingImageVersion(image, true)
	}

	count(badImages) > 0
	names = concat(", ", badImages)
	msg = sprintf("Container images must specify a version (%s)", [names])
}
