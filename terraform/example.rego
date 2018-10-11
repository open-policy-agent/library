package terraform.example

import data.terraform.library

import input as tfplan

########################
# Parameters for Policy
########################

# acceptable score for automated authorization
blast_radius = 30

# weights assigned for each operation on each resource-type
weights = {
	"aws_autoscaling_group": {"delete": 100, "create": 10, "modify": 1},
	"aws_instance": {"delete": 10, "create": 1, "modify": 1},
}

#########
# Policy
#########

# Authorization holds if score for the plan is acceptable and no changes are made to IAM
default authz = false

authz {
	score < blast_radius
	not touches_iam
}

# Compute the score for a Terraform plan as the weighted sum of deletions, creations, modifications
score = s {
	all := [x |
		weights[resource_type] = crud
		del = crud.delete * library.num_deletes_of_type[resource_type]
		new = crud.create * library.num_creates_of_type[resource_type]
		mod = crud.modify * library.num_modifies_of_type[resource_type]
		x1 = del + new
		x = x1 + mod
	]

	sum(all, s)
}

# Whether there is any change to IAM
touches_iam {
	all := library.instance_names_of_type.aws_iam
	count(all, c)
	c > 0
}

