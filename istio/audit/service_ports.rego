package istio.audit.vetter.service_ports

import data.kubernetes.services

warning[result] {
	service = services[namespace][name]
	port = service.spec.ports[_]
	not port.protocol = "udp"
	not is_prefixed(port)
	result = {
		"type": "missing-service-port-prefix",
		"params": {
			"service_name": name,
			"service_namespace": namespace,
		},
	}
}

is_prefixed(port) {
    prefix = service_port_prefixes[port.name]
    startswith(port.name, prefix)
}

service_port_prefixes = {
	"http": "http-",
	"http2": "http2-",
	"grpc": "grpc-",
	"mongo": "mongo-",
	"redis": "redis-",
	"tcp": "tcp-",
}

