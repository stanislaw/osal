

test: test.unit test.integration

test.unit: build.cmake
	cd build.commandline.dir && ./osal_core_UT
	cd build.commandline.dir && ./osal_file_UT
	cd build.commandline.dir && ./osal_filesys_UT
	cd build.commandline.dir && ./osal_loader_UT
	cd build.commandline.dir && ./osal_timer_UT
	cd build.commandline.dir && ./osal_network_UT 

test.integration: build.cmake
	cd build.commandline.dir && ./bin-sem-flush-test
	cd build.commandline.dir && ./bin-sem-test
	cd build.commandline.dir && ./bin-sem-timeout-test
	cd build.commandline.dir && ./count-sem-test
	cd build.commandline.dir && ./file-api-test
	cd build.commandline.dir && ./mutex-test
	cd build.commandline.dir && ./osal-core-test
	cd build.commandline.dir && ./queue-timeout-test
	cd build.commandline.dir && ./sem-speed-test
	cd build.commandline.dir && ./symbol-api-test
	cd build.commandline.dir && ./timer-test

build.cmake:
	mkdir -p build.commandline.dir
	cd build.commandline.dir && cmake -G Ninja \
		-DENABLE_UNIT_TESTS=1 \
		-DOSAL_SYSTEM_OSTYPE=posix \
		-DOSAL_SYSTEM_BSPTYPE=pc-linux \
		..
	cd build.commandline.dir && ninja

