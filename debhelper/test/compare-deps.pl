#!/usr/bin/perl 

# compare-deps.pl: 
# Copyright (C) 2009 Sylvain Le Gall <gildor@debian.org>
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
# MA 02110-1301, USA.

use strict;
use warnings;

my $pkg_list = "/var/lib/apt/lists/ftp.debian.org_debian_dists_unstable_main_binary-i386_Packages";
my $pkgname;

foreach (`grep-dctrl -F Package -e "lib.*-ocaml-dev" -s Package,Depends $pkg_list`) 
{
  if (/Package: (.*)/)
  {
    $pkgname = $1;
  }
  elsif (/Depends: (.*)/)
  {
    # Extract real dependencies
    my %ocamldeps_real;
    foreach (split /\s*,\s*/)
    {
      if (/(\S*ocaml\S*)/)
      {
        if ($1 =~ /(ocaml-findlib|lib.*-ocaml)$/)
        {
        }
        elsif ($1 =~ /ocaml(-base)?-nox/)
        {
          $ocamldeps_real{"ocaml-nox"} = 1;
        }
        else
        {
          $ocamldeps_real{$1} = 1;
        }
      };
    };

    # Extract computed dependencies
    my %ocamldeps_computed;
    open(FH,"<","$pkgname.dep") || warn "Cannot open $pkgname.dep";
    foreach(<FH>)
    {
      if (/(\S+)/)
      {
        $ocamldeps_computed{$1} = 1 unless ($1 =~ /(lib.*-ocaml$|fileutils|mad|vorbis|ocaml-base-nox|cothreads)/);
      };
    };

    # Diff 
    foreach (keys %ocamldeps_real)
    {
      if (exists $ocamldeps_computed{$_})
      {
        delete($ocamldeps_real{$_});
        delete($ocamldeps_computed{$_});
      };
    };

    # Print difference
    my @diff = ((map { "-$_" } keys(%ocamldeps_real)), (map { "+$_" } keys(%ocamldeps_computed)));
    print (join (" ", "$pkgname:", @diff), "\n") if @diff > 0;
  };
};
