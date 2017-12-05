package docker

test_host_mounts {
	paths = host_volume_paths({"Binds": ["/root:", "/root", "/", "root", "root/:"]})
	paths = {"root", ""}
}

