PROJECT_NAME := $(notdir $(CURDIR))

ELM := npx elm
setup:
	sed -i 's/#project#/${PROJECT_NAME}/' shell.nix
	sed -i 's/#project#/${PROJECT_NAME}/' package.json
	awk '/^setup:$$/{n=6}; n {n--; next}; 1' < Makefile > Makefile.new
	mv Makefile.new Makefile
	make

go: package-lock.json
	${ELM} reactor

index.html: src/Main.elm elm.json package-lock.json
	${ELM} make

package-lock.json: package.json
	npm install --save-dev
