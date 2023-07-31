#
# Description: Useful CDBS variables for OCaml related packages
#
# Copyright © 2006-2007 Stefano Zacchiroli <zack@debian.org>
#           © 2009      Stéphane Glondu <steph@glondu.net>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# $Id: ocaml-vars.mk 4643 2007-10-18 00:21:51Z gildor $

_ocaml_share_path ?= /usr/share/ocaml

ifndef _ocaml_share_vars
_ocaml_share_vars = 1

# current OCaml ABI version (e.g. 3.10.0).
# Used internally by ocaml.mk (substituted for @OCamlABI@ in $(OCAML_IN_FILES)
# below), may be useful to debian/rules writers as well
OCAML_ABI ?= $(shell /usr/bin/ocamlc -version | { read a && echo $${a%%_*}; })

# OCaml standard library location.
# Used internally by ocaml.mk (substituted for @OCamlStdlibDir@ in
# $(OCAML_IN_FILES) below), may be useful to debian/rules writers as well
OCAML_STDLIB_DIR ?= $(shell /usr/bin/ocamlc -where)

# OCaml stublibs (i.e. DLLs) location.
# Used internally by ocaml.mk (substituted for @OCamlDllDir@) in
# $(OCAML_IN_FILES) below), may be useful to debian/rules writers as well
OCAML_DLL_DIR ?= $(OCAML_STDLIB_DIR)/stublibs

# 'yes' if native code compilation is available on the build architecture, 'no' otherwise.
# For debian/rules writers.
OCAML_HAVE_OCAMLOPT ?= $(if $(wildcard /usr/bin/ocamlopt),yes,no)

# space separated list of Debian architectures supporting OCaml native code
# compilation.
# Used internally by ocaml.mk and substituted in debian/control.in for the
# @OCamlNativeArchs@ marker; may be useful to debian/rules writers as well
OCAML_NATIVE_ARCHS ?= $(shell cat $(OCAML_STDLIB_DIR)/native-archs)

# OCAML_OPT_ARCH will (should?) be non-empty on native architectures
# This allows to use directly the if function of make
# ...should we enforce coherence with OCAML_HAVE_OCAMLOPT?
DEB_HOST_GNU_TYPE   ?= $(shell dpkg-architecture -qDEB_HOST_GNU_TYPE)
DEB_BUILD_GNU_TYPE  ?= $(shell dpkg-architecture -qDEB_BUILD_GNU_TYPE)
DEB_BUILD_ARCH      ?= $(shell dpkg-architecture -qDEB_BUILD_ARCH)

# Variable which is empty on bytecode architectures (useful with make's
# $(if ...))
ifeq ($(OCAML_HAVE_OCAMLOPT),yes)
OCAML_OPT_ARCH      ?= $(DEB_BUILD_ARCH)
endif

# Variable set to yes on architectures with native dynlink
ifneq (,$(wildcard $(OCAML_STDLIB_DIR)/dynlink.cmxa))
  OCAML_NATDYNLINK ?= yes
else
  OCAML_NATDYNLINK ?= no
endif

# OCAML_BEST will be 'opt' on native architectures and 'byte' otherwise.
OCAML_BEST ?= $(if $(OCAML_OPT_ARCH),opt,byte)

# OCAMLBUILD_BEST will be 'native' on native architectures and 'byte'
# otherwise.
OCAMLBUILD_BEST ?= $(if $(OCAML_OPT_ARCH),native,byte)

# OCAML_RUNTIME and OCAML_RUNTIME_NOX are runtime dependencies needed of
# bytecode OCaml programs. OCAML_RUNTIME is ocaml-base-$(OCAML_ABI) and
# OCAML_RUNTIME_NOX is ocaml-base-nox-$(OCAML_ABI).
OCAML_RUNTIME ?= $(if $(OCAML_OPT_ARCH),,ocaml-base-$(OCAML_ABI))
OCAML_RUNTIME_NOX ?= $(if $(OCAML_OPT_ARCH),,ocaml-base-nox-$(OCAML_ABI))

# comma separated list of members of the OCaml team.
# Substituted in debian/control.in for the @OCamlTeam@ marker
OCAML_TEAM =

OCAML_TEAM += Ralf Treinen <treinen@debian.org>,
OCAML_TEAM += Remi Vanicat <vanicat@debian.org>,
OCAML_TEAM += Samuel Mimram <smimram@debian.org>,
OCAML_TEAM += Stefano Zacchiroli <zack@debian.org>,
OCAML_TEAM += Sven Luther <luther@debian.org>,
OCAML_TEAM += Sylvain Le Gall <gildor@debian.org>
# no trailing "," (comma) on the last name

# Best ocamldoc for the architecture
OCAML_OCAMLDOC ?= $(if $(wildcard /usr/bin/ocamldoc.opt),/usr/bin/ocamldoc.opt,/usr/bin/ocamldoc)

# ocamlfind flags which must be used in order to generate
# correctly the ocamldoc documentation
# For debian/rules writers
OCAML_OCAMLDOC_OCAMLFIND_FLAGS =

# generic (i.e. non backend specific) flags to be passed to ocamldoc
# For debian/rules writers
OCAML_OCAMLDOC_FLAGS = -stars -m A

# html-specific flags to be passed to ocamldoc (in addition to -html -d DESTDIR)
# For debian/rules writers
OCAML_OCAMLDOC_FLAGS_HTML =

# man-specific flags to be passed to ocamldoc (in addition to -man -d DESTDIR)
# For debian/rules writers
OCAML_OCAMLDOC_FLAGS_MAN = -man-mini

# where to install HTML version of the ocamldoc generated API reference. You
# can use "$(cdbs_curpkg)" stem there, it will be expanded to the current
# package name by CDBS
# For debian/rules writers
OCAML_OCAMLDOC_DESTDIR_HTML ?= $(shell $(_ocaml_share_path)/ocamldoc-api-ref-config --html-directory $(cdbs_curpkg))

# Avoid embedding of build path in binaries (for reproducible builds)
export BUILD_PATH_PREFIX_MAP ?= .=$(CURDIR)

# Replace -custom with -output-complete-exe semantics (OCaml >= 4.11.1)
export OCAML_CUSTOM_USE_OUTPUT_COMPLETE_EXE := 1

endif
