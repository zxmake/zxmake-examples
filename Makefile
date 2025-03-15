.PHONY: build
build:
	git lfs pull
	bash scripts/run_xmake_examples.sh

.PHONY: docker
docker:
	bash scripts/docker.sh build
	bash scripts/docker.sh run
