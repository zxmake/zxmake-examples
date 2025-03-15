.PHONY: build
build:
	git lfs pull

	# FIXME: 遍历所有的 build.sh / build_xmake.sh 然后运行
	bash cmake/03-code-generation/B-protobuf/build_xmake.sh

	bash xmake/01-basic/B-cuda-target/build.sh
	bash xmake/02-cross-build/aarch64-none-linux-gnu/build.sh
	bash xmake/02-cross-build/arm-none-linux-gnueabihf/build.sh
	bash xmake/02-cross-build/clang-sysroot-target/build.sh
	bash xmake/02-cross-build/g++-aarch64-linux-gnu/build.sh
	bash xmake/02-cross-build/llvm-14/build.sh
	bash xmake/02-cross-build/zig/build.sh
	bash xmake/02-cross-build/muslcc/build.sh

.PHONY: docker
docker:
	bash scripts/docker.sh build
	bash scripts/docker.sh run
