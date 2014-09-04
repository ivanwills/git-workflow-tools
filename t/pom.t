#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 2 + 1;
use Test::NoWarnings;
use Data::Dumper qw/Dumper/;

use Git::Workflow::Pom qw/pom_version next_pom_version/;

pom();
next_pom();

sub pom {
}

sub next_pom {
    my @data = (
        [{'1.0.0-SNAPSHOT' => 1, '1.0.0' => 1}, '1.1.0-SNAPSHOT'],
        [{'1.10.0-SNAPSHOT' => 1, '1.9.0' => 1}, '1.11.0-SNAPSHOT'],
    );

    for my $data (@data) {
        is next_pom_version(undef, $data->[0]), $data->[1], "Get $data->[1] as next version"
            or diag Dumper $data;
    }
}
