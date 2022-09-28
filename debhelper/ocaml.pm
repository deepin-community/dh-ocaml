#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_before ("dh_gencontrol"    , "dh_ocaml"     );
insert_before ("dh_auto_configure", "dh_ocamlinit" );
insert_before ("dh_clean"         , "dh_ocamlclean");
insert_before ("dh_installdocs"   , "dh_ocamldoc"  );

1;
