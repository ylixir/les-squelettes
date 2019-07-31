PROJECT_NAME := $(notdir $(CURDIR))
TSC := node_modules/.bin/tsc --declaration

.PHONY: packages typescript

setup:
	sed -i 's/#project#/${PROJECT_NAME}/' shell.nix
	sed -i 's/#project#/${PROJECT_NAME}/' package.json
	awk '/^setup:$$/{n=5}; n {n--; next}; 1' < Makefile > Makefile.new
	mv Makefile.new Makefile

run: typescript
	node dist/main.js

#todo: get incremental builds working
dist/%.d.ts dist/%.js: src/%.ts typescript

typescript: package-lock.json
	${TSC}

package-lock.json: package.json
	npm install --save-dev

test:
	npm run test
