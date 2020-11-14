

default:
	mkdir -p build
	cd build && cmake -DENABLE_UNIT_TESTS=true -DCMAKE_VERBOSE_MAKEFILE=1 -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DOSAL_SYSTEM_BSPTYPE=generic-linux -DOSAL_SYSTEM_OSTYPE=posixmacos --graphviz=test.dot ..
	dot -Tpng build/test.dot -o build/graph.png
	cd build && make

test: default
	cd build && make test

