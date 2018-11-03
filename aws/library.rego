# The AWS library provides analysis capabilities of Security Groups discovered from an AWS environment.
# This is designed to audit the objects for compliance with some rules like the ones defined in NIST 800-53 (e.g. CM-8(3))

package aws.library

# This Library expects a single document named aws.

import input as aws

# List of ports that should not appear in rules
bad_ports = {23, 69, 87, 111, 21}

security_groups[groupid] = obj {
	aws.SecurityGroups[_] = obj
	obj.GroupId = groupid
}

# create a map of all security groups with their score
# For example
# {
#   "sg-123456": 11
# }
score_threshold = 1

score_for_sg[sgid] = score {
	security_groups[sgid] = obj
	wildcard_ingress_count(obj, i)
	wildcard_egress_count(obj, e)
	wide_egress_count(obj, we)
	wide_ingress_count(obj, wi)
	prohibited_ingress_count(obj, pi)
	prohibited_egress_count(obj, pe)
	sum([i, e, we, wi, pi, pe], score)
	score > score_threshold
}

# Count the number of ingress Permissions with wildcards
# Input : SecurityGroup

wildcard_ingress_count(obj) = num {
	wildcards = {r | x = obj.IpPermissions[r]; is_wildcard_permission(x, true)}
	count(wildcards, c)
	num = c * 10
}

# Count the number of ingress Permissions with prohibited ports
# Input : SecurityGroup

prohibited_ingress_count(obj) = num {
	prohibited = {r | x = obj.IpPermissions[r]; has_prohibited_port_open(x, true)}
	count(prohibited, c)
	num = c * 10
}

# Count the number of ingress Permissions with wide port range
# Input : SecurityGroup

wide_ingress_count(obj) = num {
	wide = {r | x = obj.IpPermissions[r]; is_broad_permission(x, true)}
	count(wide, c)
	num = c * 10
}

# Count the number of egress Permissions with wide port range
# Input : SecurityGroup

wide_egress_count(obj) = num {
	wide = {r | x = obj.IpPermissionsEgress[r]; is_broad_permission(x, true)}
	count(wide, c)
	num = c * 1
}

# Count the number of egress Permissions with wildcards
# Input : SecurityGroup

wildcard_egress_count(obj) = num {
	wildcards = {r | x = obj.IpPermissionsEgress[r]; is_wildcard_permission(x, true)}
	count(wildcards, c)
	num = c * 1
}

# Count the number of egress Permissions with prohibited ports
# Input : SecurityGroup

prohibited_egress_count(obj) = num {
	prohibited = {r | x = obj.IpPermissionsEgress[r]; has_prohibited_port_open(x, true)}
	count(prohibited, c)
	num = c * 1
}

# Check if security group permission has a wildcard CIDR
# Input : IpPermissions

has_wildcard_cidr(obj) {
	obj.IpRanges[_].CidrIp = "0.0.0.0/0"
}

# Check if security group permission has wildcard protocol and ports
# Input : IpPermissions

has_wildcard_ports(obj) {
	obj.ToPort = null
	obj.FromPort = null
	obj.IpProtocol = "-1"
}

# Check if rule has more than one port open - Eventually the number of ports could be returned instead of boolean
# Input : IpPermissions

has_wide_range(obj) {
	obj.ToPort != null
	obj.FromPort != null

	x = obj.ToPort - obj.FromPort
	x > 0
}

# Check if security group permission is allowing all traffic on all ports
# looking like this in AWS Security groups :
#      {
#        "FromPort": null,
#        "IpProtocol": "-1",
#        "IpRanges": [
#          {
#            "CidrIp": "0.0.0.0/0",
#          }
#        ],
#        "ToPort": null,
#      }
# Input : IpPermissions

is_wildcard_permission(obj) {
	has_wildcard_ports(obj, true)
	has_wildcard_cidr(obj, true)
}

# Check if security group permission is allowing all traffic on too many ports
# looking like this in AWS Security groups :
#      {
#        "FromPort": 0,
#        "IpProtocol": "tcp",
#        "IpRanges": [
#          {
#            "CidrIp": "0.0.0.0/0",
#          }
#        ],
#        "ToPort": 65535,
#      }
# Input : IpPermissions

is_broad_permission(obj) {
	has_wide_range(obj, true)
	has_wildcard_cidr(obj, true)
}

ipperm_key = {"IpPermissions", "IpPermissionsEgress"}

# Check if any of the prohibited ports are opened in either ingress or egress
# Input : SecurityGroup

has_prohibited_port_open(obj) {
	from = obj[perm_key][j].FromPort # instead of _, using a variable name
	to = obj[perm_key][j].ToPort
	ipperm_key[perm_key] # check if perm_key is "IpPermissionEgress" or "IpPermissionsIngress"
	bad_ports[port]
	from <= port
	port <= to
}
