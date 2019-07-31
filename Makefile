PROJECT_NAME := $(notdir $(CURDIR))
setup:
	sed -i 's/#project#/${PROJECT_NAME}/' shell.nix
	sed -i 's/#project#/${PROJECT_NAME}/' package.json
	awk '/^setup:$$/{n=5}; n {n--; next}; 1' < Makefile > Makefile.new
	mv Makefile.new Makefile

test:
	npm run test
