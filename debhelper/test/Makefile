
ALL_PKG:=$(shell find `ocamlc -where` /usr/lib/ocsigen \
  -name "*.cma" -o -name "*.cmo" -o -name "*.cmi" -o -name "*.cmxa" -o -name "*.cmx" -o -name "*.cmxs" | \
  xargs dpkg -S | cut -f 1-1 -d: | sort -u | \
  grep -v -E "(ocaml-base|camlp4-extra|ocaml-interp|ocsigen$$)")

OCAML_MD5SUMS=../../ocaml-md5sums --md5sums-dir ./

all: $(foreach ext,.md5sums .dump .provides .dep,$(addsuffix $(ext),$(ALL_PKG))) 

clean:
	-$(RM) *.md5sums
	-$(RM) *.dump
	-$(RM) *.provides
	-$(RM) *.dep

ALL_SUFFIX=.md5sums .dump .provides .dep

$(addprefix libfileutils-ocaml-dev,$(ALL_SUFFIX)): FLAGS=\
  --nodefined Unix --nodefined UnixLabels --nodefined Str
$(addprefix libvorbis-ocaml-dev,$(ALL_SUFFIX)): FLAGS=\
  --nodefined Unix --nodefined UnixLabels --nodefined Str
$(addprefix libmad-ocaml-dev,$(ALL_SUFFIX)): FLAGS=\
  --nodefined Unix --nodefined UnixLabels
$(addprefix libcothreads-ocaml-dev,$(ALL_SUFFIX)): FLAGS=\
  --nodefined Thread --nodefined ThreadUnix --nodefined Event \
  --nodefined Condition --nodefined Mutex
$(addprefix ocsigen-dev,$(ALL_SUFFIX)): RUNTIME=ocsigen

ocaml.md5sums ocaml.dump ocaml.provides:
	version=$$(apt-cache show ocaml | sed -n "s/Version: //p" | head -n1); \
	dpkg -L ocaml ocaml-base | grep -E '.*\.cm[iaox][as]?$$' | \
	$(OCAML_MD5SUMS) compute \
	--package ocaml --runtime ocaml-base --version $$version \
	--dump-info ocaml.dump --dump-provides ocaml.provides \
	$(FLAGS) | sort > ocaml.md5sums;
	sort -o ocaml.dump ocaml.dump

FILES=$(shell dpkg -L $1 | grep -E '.*\.cm[aox][as]?$$')

%.md5sums %.dump %.provides:
	version=$$(apt-cache show $* | sed -n "s/Version: //p" | head -n1); \
	$(OCAML_MD5SUMS) compute \
	  --package $* \
	  $(if $(RUNTIME),--runtime $(RUNTIME)) \
	  --version $$version \
	  --dump-info $*.dump --dump-provides $*.provides \
	  $(FLAGS) $(call FILES,$(EXTRA_PKG) $(RUNTIME) $*) > $*.md5sums;

%.dep: %.dump $(addsuffix .md5sums,$(ALL_PKG))
	$(OCAML_MD5SUMS) dep --load-info $< | sort > $@


