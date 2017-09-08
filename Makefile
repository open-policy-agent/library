# using tip for alpine image.
# once 0.5.8 is released, can move back to latest/stable.
VERSION ?= 0.5.8-dev
REPOSITORY ?= openpolicyagent/opa
IMAGE := $(REPOSITORY):$(VERSION)

all: test check

.PHONY: test
test:
	@./build/test.sh --docker-image=$(IMAGE)-alpine --base-dir=$(PWD)

.PHONY: check
check:
	@./build/check.sh --docker-image=$(IMAGE)-alpine --base-dir=$(PWD)
