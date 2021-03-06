all: compile-all

test-parse:
	@$(MAKE) -s -C tests/regression $@

test-ada:
	@$(MAKE) -s -C tests/regression $@

test-llvm:
	@$(MAKE) -s -C tests/regression $@

benchmark:
	@$(MAKE) -s -C tests/regression $@

benchmark-O1:
	@$(MAKE) -s -C tests/regression $@

benchmark-O2:
	@$(MAKE) -s -C tests/regression $@

benchmark-O3:
	@$(MAKE) -s -C tests/regression $@

coverage:
	@$(MAKE) -s -C tests/regression $@

flake8:
	@echo Generating flake8_report file
	@flake8 opengeode.py Pr.py sdlSymbols.py genericSymbols.py ogParser.py \
	        AdaGenerator.py Renderer.py Clipboard.py Lander.py ogAST.py \
	        undoCommands.py  Connectors.py Asn1scc.py Helper.py \
	        Statechart.py TextInteraction.py > flake8_report

compile-all:
	@pyside-rcc opengeode.qrc -o icons.py
	@if [ ! -f antlr-3.1.3.tar.bz2 ] ; \
		then wget http://download.tuxfamily.org/taste/misc/antlr-3.1.3.tar.bz2 ; \
		tar jxvf antlr-3.1.3.tar.bz2 ; \
	fi
	@CLASSPATH=$$PWD/antlr-3.1.3/lib/antlr-3.1.3.jar java org.antlr.Tool sdl92.g

install: compile-all
	@mkdir -p opengeode
	@for f in AdaGenerator.py __init__.py Pr.py genericSymbols.py icons.py \
	          ogAST.py ogParser.py opengeode.py Renderer.py samnmax.py \
	          sdl92Lexer.py sdl92Parser.py sdlSymbols.py undoCommands.py \
	          Clipboard.py Statechart.py LlvmGenerator.py Lander.py Helper.py \
	          Connectors.py Asn1scc.py TextInteraction.py ; \
	    do echo Installing $$f && cp $$f opengeode ; \
	done
	@python setup.py install

publish: install
	@python setup.py sdist upload

clean:
	@$(MAKE) -s -C tests/regression $@
	@find . -name '*~' | xargs rm -f
	@find . -name '*.o' | xargs rm -f

.PHONY: all test-parse test-ada test-llvm benchmark benchmark-O1 benchmark-O2 \
	    benchmark-O3 flake8 coverage compile-all install publish clean
