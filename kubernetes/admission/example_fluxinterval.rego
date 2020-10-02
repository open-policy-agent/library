# This example demonstrates how to ensure consumers of your kubernetes cluster don't slam
# your cluster's API or git repositories by configuring [flux](https://fluxcd.io/) to sync too frequently.
package library.kubernetes.validating.fluxinterval

image := "fluxcd/flux"

deny[msg] {
	some i

	# Ensure only applies to flux images
	container := input.spec.template.spec.containers[i]
	contains(container.image, image)

	some j
	arg := container.args[j]

	# Extract interval argument value
	interval := split(arg, "--git-poll-interval=")[1]

	# Ensure values is not of seconds and is at least 2 digits with minutes
	regex.match("^([0-9]{1,}s|[0-9]{1}m)$", interval)
	msg := "--git-poll-interval must be at least 10m"
}

deny[msg] {
	some i

	# Ensure only applies to flux images
	container := input.spec.template.spec.containers[i]
	contains(container.image, image)

	some j
	arg := container.args[j]

	# Extract interval argument value
	interval := split(arg, "--sync-interval=")[1]

	# Ensure values is not of seconds and is at least 2 digits with minutes
	regex.match("^([0-9]{1,}s|[0-9]{1}m)$", interval)
	msg := "--sync-interval must be at least 10m"
}
