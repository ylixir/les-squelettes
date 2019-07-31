PROJECT_NAME := $(notdir $(CURDIR))

TSC := node_modules/.bin/tsc -p tsfull.json
JEST := node_modules/.bin/jest
BABEL := node_modules/.bin/babel --out-dir bin --extensions .ts --source-maps inline

.PHONY: \
	all \
	bin \
	clean \
	packages \
	run \
	types \
	types-check \

setup:
	sed -i 's/#project#/${PROJECT_NAME}/' shell.nix
	sed -i 's/#project#/${PROJECT_NAME}/' package.json
	awk '/^setup:$$/{n=5}; n {n--; next}; 1' < Makefile > Makefile.new
	mv Makefile.new Makefile

all: types-check tests types bin
clean:
	rm -rf \
		bin \
		node_modules \
		package-lock.json \
		tsconfig.json \
		tsfull.tsbuildinfo \
		types \

bin: bin/main.js

run: bin
	node bin/main.js

types-check: package-lock.json tsconfig.json
	${TSC} --noEmit

types/%.d.ts: src/%.ts types

bin/%.js: src/%.ts
	${BABEL} $<

types: package-lock.json tsconfig.json
	${TSC} --emitDeclarationOnly

tsconfig.json: tsconfig
	rm -f tsconfig.json
	npx tsc --init @tsconfig

package-lock.json: package.json
	npm install --save-dev

tests:
	${JEST}
