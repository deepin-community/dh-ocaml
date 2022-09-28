#
# Description: Useful Makefile rules for OCaml related packages
#
# Copyright © 2009 Stéphane Glondu <steph@glondu.net>
#           © 2009 Sylvain Le Gall 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 USA.
#

_ocaml_share_path ?= /usr/share/ocaml

ifndef _ocaml_share_ocamlinit
_ocaml_share_ocamlinit = 1

include $(_ocaml_share_path)/ocamlvars.mk

ocamlinit: ocamlinit-stamp
ocamlinit-stamp:
	dh_ocamlinit

ocamlinit-clean:
	dh_ocamlclean

.PHONY: ocamlinit ocamlinit-clean

endif
