MODULES=gameboard gameloop authors display command ai_medium ai_hard ai_easy ascii rules
OBJECTS=$(MODULES:=.cmo)
MLS=$(MODULES:=.ml)
MLIS=$(MODULES:=.mli)
TEST=test.byte
MAIN=main
OCB_FLAGS = -tag bin_annot
OCB_PKG = -package curses,ANSITerminal,ounit
OCAMLBUILD=ocamlbuild -use-ocamlfind $(OCB_FLAGS)

native:
	$(OCAMLBUILD) $(MAIN).native

byte:
	$(OCAMLBUILD) $(MAIN).byte

test:
	$(OCAMLBUILD) -tag 'debug' $(TEST) && ./$(TEST)

default: build

build:
	$(OCAMLBUILD) $(OBJECTS)

zip: build
	zip battlecaml_src.zip *.ml* _tags Makefile INSTALL.md

play: native 
	./$(MAIN).native

docs: docs-private docs-public

docs-public: build
	mkdir -p doc.public
	ocamlfind ocamldoc -I _build $(OCB_PKG) \
		-html -stars -d doc.public $(MLIS)

docs-private: build
	mkdir -p doc.private
	ocamlfind ocamldoc -I _build $(OCB_PKG) \
		-html -stars -d doc.private \
		-inv-merge-ml-mli -m A $(MLIS) $(MLS)
		
clean:
	ocamlbuild -clean
