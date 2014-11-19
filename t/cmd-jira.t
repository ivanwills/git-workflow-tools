#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Jira;
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
            ],
            STD => {
                OUT => qr/Usage:/,
                ERR => qr/\ANo \s JIRA \s specified!\n/xms,
            },
            option => {help => 1},
            name   => 'No Jira',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123/],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123'$/,
                ERR => qr/^$/,
            },
            option => {},
            name   => 'Find local branch',
        },
        {
            ARGV => [qw/DEF-123/],
            mock => [
                [],
                [],
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/git \s feature \s DEF-123/xms,
            },
            option => {},
            name   => 'No local or remote branch',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123'$/,
                ERR => qr/^$/,
            },
            option => {},
            name   => 'Find remote branch',
        },
        {
            ARGV => [qw/ABC-123 -l/],
            mock => [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                ['1416341516 75c7e676ea83792dafd918c4213ebbdb292299ce'],
                ['Test User'],
                ['test.user@example.com'],
            ],
            STD => {
                OUT => qr{^origin/abc_123 [(]Test User at [^)]+[)]$},
                ERR => qr/^$/,
            },
            option => {list => 1},
            name   => 'Find remote branch',
        },
        {
            ARGV => [qw/ABC-123 -q/],
            mock => [
                [map {"  $_"} qw/master abc_123/],
                undef,
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/^$/,
            },
            option => {quiet => 1},
            name   => 'Find quiet local branch',
        },
        {
            ARGV => [qw/DEF-123 --quiet/],
            mock => [
                [],
                [],
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr//xms,
            },
            option => {quiet => 1},
            name   => 'Quiet, No local or remote branch',
        },
        {
            ARGV => [qw/ABC-123 --quiet/],
            mock => [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                undef,
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/^$/,
            },
            option => {quiet => 1},
            name   => 'Find quiet remote branch',
        },
        {
            ARGV => [qw/ABC-124 --list/],
            mock => [
                [map {"  $_"} qw/master abc_124/],
                ['1416341516 75c7e676ea83792dafd918c4213ebbdb292299ce'],
                ['Test User'],
                ['test.user@example.com'],
            ],
            STD => {
                OUT => qr/^abc_124 [(]Test User at [^)]+[)]$/,
                ERR => qr/^$/,
            },
            option => {list => 1},
            name   => 'List local branches',
        },
        {
            ARGV => [qw/ABC-123 --list --quiet/],
            mock => [
                [map {"  $_"} qw/master abc_123/],
            ],
            STD => {
                OUT => qr/^abc_123$/,
                ERR => qr/^$/,
            },
            option => {list => 1, quiet => 1},
            name   => 'List local branches',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123 abc_123_v2/],
                ['1416341516 0000000000000000000000000000000000000000'],
                ['Test User'],
                ['test.user@example.com'],
                ['1416345516 1111111111111111111111111111111111111111'],
                ['Test User'],
                ['test.user@example.com'],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123'$/,
                ERR => qr/^Which \s branch:$/xms,
                IN  => "1\n",
            },
            option => {},
            name   => 'Find local branches (choose 1)',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123 abc_123_v2/],
                ['1416341516 0000000000000000000000000000000000000000'],
                ['Test User'],
                ['test.user@example.com'],
                ['1416345516 1111111111111111111111111111111111111111'],
                ['Test User'],
                ['test.user@example.com'],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123_v2'$/,
                ERR => qr/^Which \s branch:$/xms,
                IN  => "2\n",
            },
            option => {},
            name   => 'Find local branches (choose 2)',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123 abc_123_v2/],
                ['1416341516 0000000000000000000000000000000000000000'],
                ['Test User'],
                ['test.user@example.com'],
                ['1416345516 1111111111111111111111111111111111111111'],
                ['Test User'],
                ['test.user@example.com'],
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/^Unknown \s branch!$/xms,
                IN  => "3\n",
            },
            option => {},
            name   => 'Find local branches (choose 2)',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Jira', $data) or last;
    }
}
