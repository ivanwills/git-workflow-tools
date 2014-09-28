#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Pom;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';
%App::Git::Workflow::Command::Pom::p2u_extra = ( -exitval => 'NOEXIT', );
$Test::Git::Workflow::Command::workflow = 'App::Git::Workflow::Pom';

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [qw{}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
                [map {"  $_"} qw{master origin/master}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
            ],
            STD => {
                OUT => "POM Version 1.0.0-SNAPSHOT is unique\n",
                ERR => '',
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
            },
            name   => 'Default (uniq)',
        },
        {
            ARGV => [qw{uniq}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
                [map {"  $_"} qw{master origin/master other bad_version}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1412911499 1111111111111111111111111111111111111111'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
            ],
            STD => {
                OUT => '',
                ERR => "Following branches are using version 1.0.0\n\tmaster\n\tother\n\t\n",
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
            },
            name   => 'Default uniq non-unique',
        },
        {
            ARGV => [qw{uniq}],
            mock => [
                undef,
                't/data/pom-bad.xml',
                undef,
                [map {"  $_"} qw{master origin/master other bad_version}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>VERSION</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1412911499 1111111111111111111111111111111111111111'],
                "<project>\n\t<version>VERSION</version>\n</project>\n",
            ],
            STD => {
                OUT => '',
                ERR => "Following branches are using version 1.0.0\n\tmaster\n\tother\n\t\n",
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom-bad.xml',
            },
            name   => 'Default uniq non-unique',
            skip   => sub {1},
        },
        {
            ARGV => [qw{next}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
                [map {"  $_"} qw{master origin/master}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
            ],
            STD => {
                OUT => "1.1.0-SNAPSHOT\n",
                ERR => '',
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
            },
            name   => 'next',
        },
        {
            ARGV => [qw{next --update}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
                [map {"  $_"} qw{master origin/master}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
            ],
            STD => {
                OUT => "1.1.0-SNAPSHOT\n",
                ERR => '',
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
                update => 1,
            },
            name   => 'next --update',
            skip   => sub {1},
        },
        {
            ARGV => [qw{whos 2.0.0}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
                [map {"  $_"} qw{master origin/master other}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>2.0.0-SNAPSHOT</version>\n</project>\n",
            ],
            STD => {
                OUT => "other\t2.0.0-SNAPSHOT\n",
                ERR => '',
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
            },
            name   => 'whos',
        },
        {
            ARGV => [qw{whos}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
            ],
            STD => {
                OUT => '',
                ERR => qr{No version supplied!\n},
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
            },
            name   => 'whos no version',
        },
        {
            ARGV => [qw{whos 1}],
            mock => [
                undef,
                't/data/pom.xml',
                undef,
                [map {"  $_"} qw{master origin/master other}],
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>1.0.0-SNAPSHOT</version>\n</project>\n",
                ['1411800388 0000000000000000000000000000000000000000'],
                "<project>\n\t<version>2.0.0-SNAPSHOT</version>\n</project>\n",
            ],
            STD => {
                OUT => "master\t1.0.0-SNAPSHOT\n",
                ERR => '',
            },
            option => {
                fetch => 1,
                pom   => 't/data/pom.xml',
            },
            name   => 'whos no version',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Pom', $data);
    }
}
