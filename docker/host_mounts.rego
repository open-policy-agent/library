package docker

host_volume_paths(host_config) = {trimmed |
	host_config.Binds[_] = bind
	split(bind, ":", parts)
	trim(parts[0], "/", trimmed)
}
