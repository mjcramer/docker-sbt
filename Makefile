
DOCKER_REPOSITORY := sbt
DOCKER_TAG ?= $(shell git describe --tags)
DOCKER_REGISTRY ?= mjcramer

# make sure docker is installed
DOCKER_EXISTS := @echo "Found docker..."
DOCKER_WHICH := $(shell which docker)
ifeq ($(strip $(DOCKER_WHICH)),)
	DOCKER_EXISTS := @echo "\nERROR: docker not found.\nSee: https://docs.docker.com/" && exit 1
endif

.PHONY: check build tag push clean

check:
	$(DOCKER_EXISTS)

build: check
	@echo "Building docker image ${DOCKER_REPOSITORY}:${DOCKER_TAG}..."
	@docker buildx build \
		--tag $(DOCKER_REPOSITORY):$(DOCKER_TAG) \
		.

run: build
	@echo "Running docker image $(DOCKER_REPOSITORY):$(DOCKER_TAG)..."
	@docker run --rm -it \
		--volume $(pwd -P):/home/$(basename $(dirname $(pwd -P))) \
		$(DOCKER_REPOSITORY):$(DOCKER_TAG)

tag: build
	@echo "Tagging docker image ${DOCKER_REPOSITORY}:${DOCKER_TAG}..."
	@docker tag $(DOCKER_REPOSITORY):$(DOCKER_TAG) $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$(DOCKER_TAG)

push: tag
	@docker push $(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$(DOCKER_TAG)

clean:
	@docker rm $(shell docker ps -a -q)
