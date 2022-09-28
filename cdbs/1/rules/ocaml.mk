#
# Description: CDBS class for OCaml related packages
#
# Copyright © 2006-2007 Stefano Zacchiroli <zack@debian.org>
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
# $Id: ocaml.mk 4944 2007-12-28 14:50:46Z zack $

# Includes must be in this order: dpatch.mk, debhelper.mk, ocaml.mk

_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
_ocaml_share_path ?= /usr/share/ocaml

ifndef _cdbs_class_ocaml
_cdbs_class_ocaml = 1

# needed by debian/control:: rule below
include $(_cdbs_rules_path)/buildcore.mk$(_cdbs_makefile_suffix)
include $(_ocaml_share_path)/ocamlvars.mk

# Sometimes, one needs to desactivate dh_ocaml. In such cases, you should
# define WITH_DH_OCAML and set it to 0.
# 1: dh_ocaml is activated
# 0: dh_ocaml is desactivated
WITH_DH_OCAML ?= 1

# space separated list of packages matching the naming convention for OCaml
# development libraries, i.e. libXXX-ocaml-dev.
# For debian/rules writers
OCAML_LIBDEV_PACKAGES ?= $(filter lib%-ocaml-dev,$(DEB_PACKAGES))

# as above, but keep packages matching the convention for OCaml runtime
# libraries, i.e. libXX-ocaml
OCAML_LIB_PACKAGES ?= $(filter lib%-ocaml,$(DEB_PACKAGES))

# to ensure invocations and tests on /usr/bin/ocaml* are meaningful
CDBS_BUILD_DEPENDS := $(CDBS_BUILD_DEPENDS), ocaml-nox

ifdef _cdbs_rules_debhelper

# ensure dpkg-gencontrol will fill F:OCamlABI fields with the proper value
DEB_DH_GENCONTROL_ARGS += -- -VF:OCamlABI="$(OCAML_ABI)"
DEB_DH_GENCONTROL_ARGS +=    -VF:OCamlNativeArchs="$(OCAML_NATIVE_ARCHS)"

endif

# post-install hook to invoke dh_ocamldoc
$(patsubst %,binary-install/%,$(DEB_PACKAGES))::
	dh_ocamldoc -p$(cdbs_curpkg)

# Additional flags for dh_ocaml. Usefull to tell that some package do not export
# some modules, or to override the runtime map (dev package -> runtime package)
OCAML_DHOCAML_FLAGS =

# Invoke dh_ocaml before building the deb
common-binary-predeb-arch::
ifeq ($(WITH_DH_OCAML),1)
	dh_ocaml -s $(OCAML_DHOCAML_FLAGS)
endif

common-binary-predeb-indep::
ifeq ($(WITH_DH_OCAML),1)
	dh_ocaml -i $(OCAML_DHOCAML_FLAGS)
endif

clean::
	rm -f debian/*.doc-base.apiref*

# generate .in files counterpars before building, substituting @OCamlABI@
# markers with the proper value; clean stamps after building
ocamlinit-stamp:
	dh_ocamlinit

.PHONY: ocamlinit-clean
ocamlinit-clean:
	dh_ocamlclean

pre-build:: ocamlinit-stamp
clean:: ocamlinit-clean

# Interaction with patch systems
ocamlinit-clean: $(_cdbs_dpatch_unapply_rule) $(_cdbs_patch_system_unapply_rule)
$(_cdbs_dpatch_unapply_rule): ocamlinit-stamp
$(_cdbs_patch_system_unapply_rule): ocamlinit-stamp

# update debian/control substituting @OCamlNativeArchs@
# XXX ASSUMPTION: debian/control has already been generated, i.e. this rule is
# executed after the debian/control:: rule in builcore.mk
ifneq ($(DEB_AUTO_UPDATE_DEBIAN_CONTROL),)

# add required build dependency for dh_ocaml*
CDBS_BUILD_DEPENDS := $(CDBS_BUILD_DEPENDS), dh-ocaml (>= 0.9)

debian/control::
	if test -f debian/control && test -f debian/control.in ; then \
		sed -i \
			-e "s/@OCamlNativeArchs@/$(OCAML_NATIVE_ARCHS)/g" \
			-e "s/@OCamlTeam@/$(OCAML_TEAM)/g" \
			$@ ; \
	fi
endif

endif
