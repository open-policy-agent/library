package aws.test.example

import data.aws.example
import data.aws.inputs

default test_simple_sg = false

test_simple_sg {
	i = inputs.simple_example
	results = example.output with input as i
	results.SecurityGroupScore["sg-1"] = 21
}

