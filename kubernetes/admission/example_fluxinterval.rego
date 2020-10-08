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
	split_interval := split(arg, "--git-poll-interval=")
	interval := split_interval[1]
	seconds := convert_to_seconds(interval)

	# Ensure value is at least 10 minutes
	seconds < 600
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
	split_interval := split(arg, "--sync-interval=")
	interval := split_interval[1]
	seconds := convert_to_seconds(interval)

	# Ensure value is at least 10 minutes
	seconds < 600
	msg := "--sync-interval must be at least 10m"
}

convert_to_seconds(interval) = result {
	len := count(interval)
	number := to_number(substring(interval, 0, len - 1))
	unit := substring(interval, len - 1, len)
	result := convert_to_seconds_aux(number, unit)
}

convert_to_seconds_aux(number, "s") = number

convert_to_seconds_aux(number, "m") = number * 60

convert_to_seconds_aux(number, "h") = number * 3600
