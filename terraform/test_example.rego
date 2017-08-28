package terraform.test.example

import data.terraform.example
import data.terraform.inputs

test_name = {"small_create", "large_create", "mix"}

failure[x] {
    test_name[x]
    not success[x]
}

success["small_create"] {
    i = inputs.lineage0
    example.authz = true with input as i
    example.score = 11 with input as i
}

success["large_create"] {
    i = inputs.large_create
    example.authz = false with input as i
    example.score = 31 with input as i
}

success["mix"] {
    i = inputs.lineage1
    example.authz = true with input as i
    example.score = 12 with input as i
}

