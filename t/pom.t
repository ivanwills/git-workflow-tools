#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 6 + 1;
#use Test::NoWarnings;
use Data::Dumper qw/Dumper/;
use lib 't/lib';
use Git::Workflow::Pom qw/get_pom_versions pom_version next_pom_version/;
use Mock::Git::Workflow::Repository;

$Git::Workflow::Pom::git = Mock::Git::Workflow::Repository->git;
$Git::Workflow::git = Mock::Git::Workflow::Repository->git;

pom();
next_pom();
pom_versions();

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

sub pom_versions {
    my @data = (
        [
            [
                ['* master', '  origin/master', '  origin/veryold'],
                'http://mock.example.com/test.git',
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
        for my $mock (@{ $data->[0] }) {
            Mock::Git::Workflow::Repository->_add($mock);
        }
        is_deeply get_pom_versions('pom.xml'), $data->[1], "Get the correct versions"
            or diag Dumper $data;
    }
}
