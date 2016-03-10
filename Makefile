@OPEN_DYLAN_USER_REGISTRIES=$(pwd)/registry:${OPEN_DYLAN_USER_REGISTRIES}

uuid:
	dylan-compiler -BUILD uuid

test: uuid
	dylan-compiler -BUILD uuid-test-suite-app

run-tests: test
	_build/bin/uuid-test-suite-app

clean:
	rm -rf _build

.PHONY: uuid test run-tests clean
