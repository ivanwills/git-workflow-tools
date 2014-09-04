#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 6 + 1;
use Test::NoWarnings;
use Data::Dumper qw/Dumper/;

use Git::Workflow::Pom qw/pom_version next_pom_version/;

pom();
next_pom();

sub pom {
    my @data = (
        ['t/good-pom.xml', '1.92.2'],
        ['t/bad-pom.xml' , undef],
        ['<project><version>1.0.0-SNAPSHOT</version></project>', '1.0.0-SNAPSHOT'],
        ["<project>\n\t<version></version>\n</project>", undef],
    );

    for my $data (@data) {
        is pom_version($data->[0]), $data->[1], "Get correct POM version"
            or diag Dumper $data;
    }
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
