
XMLFILES = $(wildcard *.xml)
INSTALL_STUFF =				\
	ocaml_packaging_policy.html	\
	ocaml_packaging_policy.txt	\
	ocaml_packaging_reference.html  \
	ocaml_packaging_reference.txt   \
	$(NULL)
INSTALL_HOST = alioth.debian.org
INSTALL_DIR = /org/alioth.debian.org/chroot/home/groups/pkg-ocaml-maint/htdocs/

all: $(INSTALL_STUFF)

check: $(patsubst %.xml,%.check,$(XMLFILES))

%.check: %.xml included.ent
	xmllint --noout --nonet --xinclude --postvalid $<
	touch $@

%.txt: %.html
	LC_ALL=C.UTF-8 lynx -nolist -dump $< > $@

%.html: %.xml $(XMLFILES) check 
	xsltproc --xinclude --nonet -o $@ \
	  /usr/share/xml/docbook/stylesheet/nwalsh/xhtml/docbook.xsl \
	  $<

upload: all
	scp -r $(INSTALL_STUFF) $(INSTALL_HOST):$(INSTALL_DIR)
	ssh $(INSTALL_HOST) "cd $(INSTALL_DIR) && chmod -R g+w $(INSTALL_STUFF)"

clean:
	-$(RM) ocaml_packaging_policy.html
	-$(RM) ocaml_packaging_policy.txt
	-$(RM) ocaml_packaging_reference.html
	-$(RM) ocaml_packaging_reference.txt
	-$(RM) *.check

.PHONY: clean all upload clean check
