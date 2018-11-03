# The Terraform library provides analysis capabilities over Terraform plans.
# In particular, it identifies resources, their types, and whether each
#   resource is being created, deleted, or modified.  It also provides
#   aggregate information for creations, deletions, and modifications,
#   optionally organized by the type of resource.
# This library was designed to make it easy to compute a risk score
#   for a plan.  That score could depend on weights assigned to
#   each create/delete/modification of each resource-type, who
#   authored the changes in the plan, the state of the resources being
#   impacted, and so on.
package terraform.library

# This library expects a single, global Terraform plan as input named tfplan.
#   All functions and virtual documents are computed using that Terraform plan.
# tfplan is a dictionary mapping the name of an instance to its plan entry.
# If you're using Terraform modules, you need to flatten the resource hierarchy
#   before handing it to OPA.
import input as tfplan

# Set of all the types of resources appearing in the plan
# Note: written as a comprehension to eliminate duplicates proactively
#  https://github.com/open-policy-agent/opa/issues/429
resource_types = all {
	all := {y | tfplan[name]; split(name, ".", outs); y = outs[0]}
}

# Dictionary that maps the instance name to its full object
instance[name] = obj {
	tfplan[name] = obj
	name != "destroy"
}

# Dictionary mapping each resource-type into all the instance names with that type
instance_names_of_type[resource_type] = all {
	resource_types[resource_type]
	all := {name |
		tfplan[name] = _
		has_type(name, resource_type, true)
	}
}

# Function that checks if a given resource-instance name has a given type
has_type(name, resource_type) {
	startswith(name, resource_type)
}

# Total number of deletions
num_deletes = num {
	count(deletes, num)
}

# Set of all the resource-instance names being deleted
deletes = deletions {
	deletions := {name | obj = instance[name]; is_delete(obj, true)}
}

# Dictionary mapping each resource-type to the number of deletions of that type
num_deletes_of_type[resource_type] = num {
	count(deletes_of_type[resource_type], num)
}

# Dictionary mapping each resource-type to the list of deleted resource-instance names
deletes_of_type[resource_type] = deletions {
	resource_types[resource_type]
	deletions := {name | name = deletes[_]; has_type(name, resource_type, true)}
}

# Function defining whether a resource-instance is a deletion.
is_delete(obj) {
	obj.destroy = true
}

# Total number of creations
num_creates = num {
	count(creates, num)
}

# Set of created resource-instance names
creates = makes {
	makes = {name | obj = instance[name]; is_create(obj, true)}
}

# Dictionary mapping each resource-type to the number of creations of that type 
num_creates_of_type[resource_type] = num {
	count(creates_of_type[resource_type], num)
}

# Dictionary mapping each resource-type to the list of created resource-instance names
creates_of_type[resource_type] = makes {
	all := instance_names_of_type[resource_type]
	makes := {name | all[_] = name; obj = instance[name]; is_create(obj, true)}
}

# Function defining whether a resource-instance is a creation
is_create(obj) {
	obj.id = ""
}

# Total number of modifications (other than creates and deletes)
num_modifies = num {
	count(modifies, num)
}

# Set of resource-instance names being modified
modifies = mods {
	mods = {name | obj = instance[name]; is_modify(obj, true)}
}

# Dictionary mapping each resource-type to the number of modified resource-instances
num_modifies_of_type[resource_type] = num {
	count(modifies_of_type[resource_type], num)
}

# Dictionary mapping each resource-type to the list of modified resource-instance names
modifies_of_type[resource_type] = mods {
	all := instance_names_of_type[resource_type]
	mods := {name | all[_] = name; obj = instance[name]; is_modify(obj, true)}
}

# Function defining whether a resource-instance is a modification
is_modify(obj) {
	obj.destroy = false
	not obj.id
}
