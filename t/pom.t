#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 7 + 1;
use Test::NoWarnings;
use Data::Dumper qw/Dumper/;
use lib 't/lib';
use App::Git::Workflow::Pom;
use Mock::App::Git::Workflow::Repository;

my $git = Mock::App::Git::Workflow::Repository->git;
$git->mock_add(undef);
$ENV{HOME} = undef;
my $pom = App::Git::Workflow::Pom->new( git => $git );

pom();
next_pom();
pom_versions();
undef $pom;

sub pom {
    my @data = (
        ['t/data/good-pom.xml', '1.92.2'],
        ['t/data/bad-pom.xml' , undef],
        ['<project><version>1.0.0-SNAPSHOT</version></project>', '1.0.0-SNAPSHOT'],
        ["<project>\n\t<version></version>\n</project>", undef],
    );

    for my $data (@data) {
        is $pom->pom_version($data->[0]), $data->[1], "Get correct POM version"
            or diag Dumper $data;
    }
}

sub next_pom {
    my @data = (
        [{'1.0.0-SNAPSHOT' => 1, '1.0.0' => 1}, '1.1.0-SNAPSHOT'],
        [{'1.10.0-SNAPSHOT' => 1, '1.9.0' => 1}, '1.11.0-SNAPSHOT'],
    );

    for my $data (@data) {
        is $pom->next_pom_version(undef, $data->[0]), $data->[1], "Get $data->[1] as next version"
            or diag Dumper $data;
    }
}

sub pom_versions {
    my @data = (
        [
            [
                ['* master', '  origin/master', '  origin/veryold'],
                ['1410113841 6ee992acaa81f6c90d9fa7e52898e33b00f6fa90'],
                '<project><version>1.0.0-SNAPSHOT</version></project>',
                ['1410113842 5ee992acaa81f6c90d9fa7e52898e33b00f6fa90'],
                '<project><version>2.0.0-SNAPSHOT</version></project>',
                ['1210113842 5ee992aca381f6c90d9fa7e52898e33b00f6fa90'],
            ],
            {
                '2.0.0' => {master => '2.0.0-SNAPSHOT'},
                '1.0.0' => {master => '1.0.0-SNAPSHOT'}
            }
        ]
    );

    for my $data (@data) {
        $git->mock_add(@{ $data->[0] });
        is_deeply $pom->get_pom_versions('pom.xml'), $data->[1], "Get the correct versions"
            or diag Dumper $data;
    }
}
