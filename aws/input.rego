package aws.inputs

simple_example = {"SecurityGroups": [
	{
		"Description": "Private Networks",
		"GroupId": "sg-1",
		"GroupName": "private",
		"IpPermissions": [
			{
				"FromPort": 80,
				"IpProtocol": "tcp",
				"IpRanges": [
					{
						"CidrIp": "10.23.1.192/26",
						"Description": null,
					},
					{
						"CidrIp": "10.23.1.64/26",
						"Description": null,
					},
				],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 80,
				"UserIdGroupPairs": null,
			},
			{
				"FromPort": null,
				"IpProtocol": "-1",
				"IpRanges": null,
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": null,
				"UserIdGroupPairs": [{
					"Description": null,
					"GroupId": "sg-2",
					"GroupName": null,
					"PeeringStatus": null,
					"UserId": "123456789",
					"VpcId": null,
					"VpcPeeringConnectionId": null,
				}],
			},
			{
				"FromPort": 22,
				"IpProtocol": "tcp",
				"IpRanges": [{
					"CidrIp": "0.0.0.0/0",
					"Description": null,
				}],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 22,
				"UserIdGroupPairs": null,
			},
			{
				"FromPort": 1234,
				"IpProtocol": "udp",
				"IpRanges": [{
					"CidrIp": "0.0.0.0/0",
					"Description": null,
				}],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 7946,
				"UserIdGroupPairs": null,
			},
			{
				"FromPort": 1234,
				"IpProtocol": "tcp",
				"IpRanges": [{
					"CidrIp": "0.0.0.0/0",
					"Description": null,
				}],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 7946,
				"UserIdGroupPairs": null,
			},
			{
				"FromPort": 8089,
				"IpProtocol": "tcp",
				"IpRanges": [
					{
						"CidrIp": "10.23.0.0/22",
						"Description": null,
					},
					{
						"CidrIp": "10.23.4.0/22",
						"Description": null,
					},
					{
						"CidrIp": "10.23.8.0/24",
						"Description": null,
					},
				],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 8089,
				"UserIdGroupPairs": null,
			},
			{
				"FromPort": 9997,
				"IpProtocol": "tcp",
				"IpRanges": [
					{
						"CidrIp": "10.23.0.0/22",
						"Description": null,
					},
					{
						"CidrIp": "10.23.4.0/22",
						"Description": null,
					},
					{
						"CidrIp": "10.23.8.0/24",
						"Description": null,
					},
				],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 9997,
				"UserIdGroupPairs": null,
			},
			{
				"FromPort": 443,
				"IpProtocol": "tcp",
				"IpRanges": [
					{
						"CidrIp": "10.23.9.192/26",
						"Description": null,
					},
					{
						"CidrIp": "10.23.9.64/26",
						"Description": null,
					},
				],
				"Ipv6Ranges": null,
				"PrefixListIds": null,
				"ToPort": 443,
				"UserIdGroupPairs": null,
			},
		],
		"IpPermissionsEgress": [{
			"FromPort": null,
			"IpProtocol": "-1",
			"IpRanges": [{
				"CidrIp": "0.0.0.0/0",
				"Description": null,
			}],
			"Ipv6Ranges": null,
			"PrefixListIds": null,
			"ToPort": null,
			"UserIdGroupPairs": null,
		}],
		"OwnerId": "123456789",
		"Tags": [{
			"Key": "Name",
			"Value": "private",
		}],
		"VpcId": "vpc-a123456",
	},
	{
		"Description": "Security group for public",
		"GroupId": "sg-2",
		"GroupName": "public",
		"IpPermissions": [{
			"FromPort": 22,
			"IpProtocol": "tcp",
			"IpRanges": [{
				"CidrIp": "10.23.10.10/0",
				"Description": null,
			}],
			"Ipv6Ranges": null,
			"PrefixListIds": null,
			"ToPort": 22,
			"UserIdGroupPairs": null,
		}],
		"IpPermissionsEgress": [{
			"FromPort": null,
			"IpProtocol": "-1",
			"IpRanges": [{
				"CidrIp": "0.0.0.0/0",
				"Description": null,
			}],
			"Ipv6Ranges": null,
			"PrefixListIds": null,
			"ToPort": null,
			"UserIdGroupPairs": null,
		}],
		"OwnerId": "123456789",
		"Tags": [{
			"Key": "Name",
			"Value": "private",
		}],
		"VpcId": "vpc-a123456",
	},
]}

