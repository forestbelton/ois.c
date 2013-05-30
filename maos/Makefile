.PHONY: clean

parser.js: parser.g node_modules
	@node_modules/pegjs/bin/pegjs $< > $@

node_modules: package.json
	@npm install

clean:
	@rm -rf parser.js node_modules
