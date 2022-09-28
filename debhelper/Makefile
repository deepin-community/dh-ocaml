
PAGES=dh_ocaml.1 dh_ocamlinit.1 dh_ocamlclean.1 dh_ocamldoc.1 ocaml-md5sums.1 ocaml-lintian.1

all:
	for i in $(PAGES); do \
		pod2man $${i%.1} > $$i; \
	done

clean:
	rm -f $(PAGES)
