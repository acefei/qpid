.PHONY: help build-container container run
.DEFAULT_GOAL := help

IMAGE_NAME := $(shell basename `git rev-parse --show-toplevel`)
DOCKER_COMMON_ARGS := --rm -it --name $(IMAGE_NAME) $(IMAGE_NAME):latest

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

container: build-container ## enter dev mode container
	docker run $(DOCKER_COMMON_ARGS) bash

build-container: Dockerfile
	docker build -t $(IMAGE_NAME) $(<D)                       

run: build-container ## run qpid broker
	docker run -p 5672:5672 $(DOCKER_COMMON_ARGS) 
