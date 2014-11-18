#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Recent;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                [qw{ master }],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{ Test User }],
                [q{ Test User }],
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {},
            name   => 'Default',
            todo   => 'Need to work out how to present',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Recent', $data);
    }
}
