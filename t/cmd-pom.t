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
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Pom', $data);
    }
}
