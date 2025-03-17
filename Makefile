.PHONY: build
build:
	bash scripts/run_cmake_examples.sh
	bash scripts/run_xmake_examples.sh

.PHONY: docker
docker:
	bash scripts/docker.sh build
	bash scripts/docker.sh run
