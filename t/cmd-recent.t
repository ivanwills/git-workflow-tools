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
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
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
        {
            ARGV => [qw/--out text/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
            ],
            STD => {
                OUT => <<'OUT',
file1
  Changed by : Test User
  In branches: master
OUT
                ERR => '',
            },
            option => { out => 'text' },
            name   => 'Text',
        },
        {
            ARGV => [qw/--out json/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
            ],
            STD => {
                OUT => {
                    file1 => {
                        branches => ['master'],
                        users    => ['Test User'],
                    }
                },
                OUT_PRE => sub { JSON::decode_json($_[0]) },
                ERR => '',
            },
            option => { out => 'json' },
            name   => 'JSON',
            skip   => sub { !eval { require JSON; }; },
        },
        {
            ARGV => [qw/--out perl/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
            ],
            STD => {
                OUT => {
                    file1 => {
                        branches => ['master'],
                        users    => ['Test User'],
                    }
                },
                OUT_PRE => sub { my $VAR1; eval $_[0] },
                ERR => '',
            },
            option => { out => 'perl' },
            name   => 'Perl',
        },
        {
            ARGV => [qw/--out unknown/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => { out => 'unknown' },
            name   => 'Unknown',
        },
        {
            ARGV => [qw/--out json --since 2014-11-10/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
            ],
            STD => {
                OUT => {
                    file1 => {
                        branches => ['master'],
                        users    => ['Test User'],
                    }
                },
                OUT_PRE => sub { JSON::decode_json($_[0]) },
                ERR => '',
            },
            option => {
                out => 'json',
                since => '2014-11-10',
            },
            name   => 'JSON Since',
            skip   => sub { !eval { require JSON; }; },
        },
        {
            ARGV => [qw/--out json --month/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
            ],
            STD => {
                OUT => {
                    file1 => {
                        branches => ['master'],
                        users    => ['Test User'],
                    }
                },
                OUT_PRE => sub { JSON::decode_json($_[0]) },
                ERR => '',
            },
            option => {
                out => 'json',
                month => 1,
            },
            name   => 'JSON Month',
            skip   => sub { !eval { require JSON; }; },
        },
        {
            ARGV => [qw/--out json --week/],
            mock => [
                [
                    '0000000000000000000000000000000000000000',
                    '1111111111111111111111111111111111111111',
                ],
                ['1414997088 0000000000000000000000000000000000000000',],
                ['  master'],
                <<'STATUS_0',
commit 0000000000000000000000000000000000000000
Author: Test User <test.user@example.com>
Date:   Mon Nov 3 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test User}],
                [q{test.user@example.com}],
                ['1414997089 1111111111111111111111111111111111111111',],
                ['  master'],
                <<'STATUS_0',
commit 1111111111111111111111111111111111111111
Author: Test Other <test.other@example.com>
Date:   Mon Nov 4 17:44:48 2014 +1100

    Remember lists are 0 based!

M   file1
STATUS_0
                [q{Test Other}],
                [q{test.other@example.com}],
            ],
            STD => {
                OUT => {
                    file1 => {
                        branches => ['master'],
                        users    => ['Test Other', 'Test User'],
                    }
                },
                OUT_PRE => sub { JSON::decode_json($_[0]) },
                ERR => '',
            },
            option => {
                out => 'json',
                week => 1,
            },
            name   => 'JSON Week',
            skip   => sub { !eval { require JSON; }; },
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Recent', $data);
    }
}
