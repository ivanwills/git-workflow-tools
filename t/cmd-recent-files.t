#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::RecentFiles;
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
                { 'rev-list' =>  [
                    '0000000000000000000000000000000000000000',
                ]},
                { 'rev-list' => ['1414997088 0000000000000000000000000000000000000000',] },
                { branch => ['  master'] },
                { show   => <<'SHOW_0' },
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
SHOW_0
                { log    => [q{Test User}] },
                { log    => [q{test.user@example.com}] },
            ],
            STD => {
                OUT => <<'OUT',
file1
  Changed by : Test User
  In branches: master
OUT
                ERR => '',
            },
            option => {},
            name   => 'Default',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::RecentFiles', $data)
            or return;
    }
}
