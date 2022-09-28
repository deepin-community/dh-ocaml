DOCS =						\
	policy/ocaml_packaging_policy.txt	\
	policy/ocaml_packaging_policy.html	\
	policy/ocaml_packaging_reference.txt	\
	policy/ocaml_packaging_reference.html	\
	$(NULL)

all: $(DOCS)
	$(MAKE) -C debhelper/ $@
	$(MAKE) -C manpages

policy/%:
	$(MAKE) -C policy/ $*

clean: 
	$(MAKE) -C policy/ clean
	$(MAKE)	-C debhelper/ clean
	$(MAKE)	-C manpages/ clean
