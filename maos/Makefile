.PHONY: clean

node_modules: package.json
	@npm install

parser.js: parser.g
	@node_modules/pegjs/bin/pegjs $< > $@

clean:
	@rm -rf parser.js node_modules
