package docker.example

import data.docker.host_volume_paths

valid_volume_mapping_whitelist {
	paths = host_volume_paths(input.Body.HostConfig)
	invalid_paths = paths - valid_host_volume_paths
	count(invalid_paths, 0)
}

valid_volume_mapping_blacklist {
	paths = host_volume_paths(input.Body.HostConfig)
	invalid_paths = paths & invalid_host_volume_paths
	count(invalid_paths, 0)
}

valid_host_volume_paths[host_path] {
	paths = host_volume_paths(input.Body.HostConfig)
	paths[host_path]
	startswith(host_path, valid_host_path_prefixes[_])
}

invalid_host_volume_paths[host_path] {
	paths = host_volume_paths(input.Body.HostConfig)
	paths[host_path]
	startswith(host_path, invalid_host_path_prefixes[_])
}

valid_host_path_prefixes = {"allowed", "also/allowed"}

invalid_host_path_prefixes = {"forbidden", "also/forbidden"}

