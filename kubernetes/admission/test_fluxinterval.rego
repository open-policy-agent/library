package library.kubernetes.validating.fluxinterval

test_ten_minutes_allowed {
	count(deny) == 0 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=10m", "--sync-interval=10m"]}]}}}}
}

test_one_hour_allowed {
	count(deny) == 0 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=1h", "--sync-interval=1h"]}]}}}}
}

test_five_minutes_denied {
	count(deny) == 2 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=5m", "--sync-interval=5m"]}]}}}}
}

test_seconds_denied {
	count(deny) == 2 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=1s", "--sync-interval=10s"]}]}}}}
}

test_five_minutes_denied_git_poll {
	count(deny) == 1 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=5m", "--sync-interval=10m"]}]}}}}
}

test_five_minutes_denied_sync_interval {
	count(deny) == 1 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=10m", "--sync-interval=5m"]}]}}}}
}

test_denied_multiple_containers {
	count(deny) == 2 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=10m", "--sync-interval=5m"]}, {"image": "fluxcd/flux:latest", "args": ["--git-poll-interval=1s"]}]}}}}
}

test_allowed_multiple_containers {
	count(deny) == 0 with input as {"spec": {"template": {"spec": {"containers": [{"image": "fluxcd/flux:1.20.2", "args": ["--git-poll-interval=10m", "--sync-interval=10m"]}, {"image": "foo:latest", "args": ["--git-poll-interval=1s"]}]}}}}
}

test_convert {
	convert_to_seconds("10m") == 600
	convert_to_seconds("10s") == 10
	convert_to_seconds("10h") == 36000
}
