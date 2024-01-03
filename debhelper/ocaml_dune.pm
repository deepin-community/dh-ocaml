# A build system class for handling ocaml-dune based projects.
#
# Copyright: © 2023 Stéphane Glondu
# License: GPL-2+

package Debian::Debhelper::Buildsystem::ocaml_dune;

use strict;
use warnings;

use parent qw(Debian::Debhelper::Buildsystem);
use Config;

sub DESCRIPTION {
    "OCaml Dune";
}

sub new {
    my $class = shift;
    my $this  = $class->SUPER::new(@_);
    return $this;
}

sub check_auto_buildable {
    my ( $this, $step ) = @_;
    return -e $this->get_sourcepath("debian/debian-dune");
}

sub get_dune_package_names {
    my $this = shift;
    my @names;
    open( FH, "<", $this->get_sourcepath("debian/debian-dune") );
    while (<FH>) {
        chomp;
        push( @names, $_ );
    }
    close(FH);
    return @names;
}

sub get_dune_package_name_list {
    my $this = shift;
    return join( ",", $this->get_dune_package_names() );
}

sub get_dune_parallel {
    my $this     = shift;
    my $parallel = $this->get_parallel();
    my @result;
    if ( $parallel > 0 ) {
        push( @result, "-j" );
        push( @result, $parallel );
    }
    return @result;
}

sub build {
    my $this = shift;
    $this->doit_in_sourcedir( "dune", "build", $this->get_dune_parallel(),
        "-p", $this->get_dune_package_name_list(), @_ );
}

sub test {
    my $this = shift;
    $this->doit_in_sourcedir( "dune", "runtest", $this->get_dune_parallel(),
        "-p", $this->get_dune_package_name_list() );
}

sub install {
    my $this = shift;
    $this->doit_in_sourcedir( "dune", "install", "--destdir=debian/tmp",
        "--prefix=/usr", "--libdir=/usr/lib/ocaml",
        $this->get_dune_package_names() );
}

sub clean {
    my $this = shift;
    $this->doit_in_sourcedir( "dune", "clean" );
}

1
