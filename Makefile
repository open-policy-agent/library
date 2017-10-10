VERSION ?= latest
REPOSITORY ?= openpolicyagent/opa
IMAGE := $(REPOSITORY):$(VERSION)

all: test check

.PHONY: test
test:
	@./build/test.sh --docker-image=$(IMAGE)-alpine --base-dir=$(PWD)

.PHONY: check
check:
	@./build/check.sh --docker-image=$(IMAGE)-alpine --base-dir=$(PWD)
