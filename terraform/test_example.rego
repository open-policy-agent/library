package terraform.test.example

import data.terraform.example
import data.terraform.inputs

test_small_create {
	i = inputs.lineage0
	example.authz = true with input as i
	example.score = 11 with input as i
}

test_large_create {
	i = inputs.large_create
	example.authz = false with input as i
	example.score = 31 with input as i
}

test_mix {
	i = inputs.lineage1
	example.authz = true with input as i
	example.score = 12 with input as i
}

