#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Watch;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';

run();
done_testing();

sub run {
    my $localdate = localtime 1411592689;
    my @data = (
        {
            ARGV => [qw{--once --sleep 0}],
            mock => [
                [
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [
                    'aaaaaaa Message10',
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [time . ' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'],
                ["  master"],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => <<'STDOUT',
aaaaaaa
  Branches: master
  Files:    file1, file2
  Users:    Ivan Wills

STDOUT
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
            },
            name   => 'Default (show)',
        },
        {
            ARGV => [qw{show --once --sleep 0}],
            mock => [
                [
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [
                    'aaaaaaa Message10',
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [time . ' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'],
                ["  master"],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => <<'STDOUT',
aaaaaaa
  Branches: master
  Files:    file1, file2
  Users:    Ivan Wills

STDOUT
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
            },
            name   => 'Default show',
        },
        {
            ARGV => [qw{show --once --sleep 0 --verbose}],
            mock => [
                [
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [
                    'aaaaaaa Message10',
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                ['1411592689 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'],
                ["  master"],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => <<"STDOUT",
aaaaaaa @ $localdate
  Branches:\x{20}
    master
  Files:   \x{20}
    file1
    file2
  Users:   \x{20}
    Ivan Wills

STDOUT
                ERR => '.',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                verbose  => 1,
            },
            name   => 'Show verbose',
        },
        {
            ARGV => [qw{show --once --sleep 0 --verbose --quiet}],
            mock => [
                [
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [
                    'aaaaaaa Message10',
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                ['1411592689 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'],
                ["  master"],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => <<"STDOUT",
aaaaaaa @ $localdate
STDOUT
                ERR => '.',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                verbose  => 1,
                quiet    => 1,
            },
            name   => 'Show verbose and quiet',
        },
        {
            ARGV => [qw{echo --once --sleep 0 --pull}],
            mock => [
                undef,
                [
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                undef,
                [
                    'aaaaaaa Message10',
                    '9999999 Message9',
                    '8888888 Message8',
                    '7777777 Message7',
                    '6666666 Message6',
                    '5555555 Message5',
                    '4444444 Message4',
                    '3333333 Message3',
                    '2222222 Message2',
                    '1111111 Message1',
                    '0000000 Message0',
                ],
                [time . ' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'],
                ["  master"],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => "\n",
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                pull     => 1,
            },
            skip   => sub { $^O eq 'MSWin32' },
            name   => 'Show with echo and pull',
        },
        {
            ARGV => [qw{--remote --once --sleep 0 --file 3 --branch other}],
            mock => [
                undef,
                [
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                undef,
                [
                    '6666666666666666666666666666666666666666',
                    '5555555555555555555555555555555555555555',
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                [time . ' 6666666666666666666666666666666666666666'],
                [map {"  $_"} qw/master other/],
                <<'SHOW',
commit 6666666666666666666666666666666666666666
Author: Some One <some.one@example.com>
Date:   Wed Sep 24 18:17:18 2014 +1000

    Message10

M   file3
SHOW
                ['Some One'],
                ['some.one@example.com'],
                [time . ' 5555555555555555555555555555555555555555'],
                ["  master"],
                <<'SHOW',
commit 5555555555555555555555555555555555555555
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => <<'STDOUT',
6666666666666666666666666666666666666666
  Branches: master, other
  Files:    file1, file2, file3
  Users:    Ivan Wills, Some One

STDOUT
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                remote   => 1,
                file     => 3,
                branch   => 'other'
            },
            name   => 'show remote with 3 files and other branch',
        },
        {
            ARGV => [qw{--remote --once --sleep 0 --branch other}],
            mock => [
                undef,
                [
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                undef,
                [
                    '6666666666666666666666666666666666666666',
                    '5555555555555555555555555555555555555555',
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                [time . ' 6666666666666666666666666666666666666666'],
                [map {"  $_"} qw/master ~ther/],
                <<'SHOW',
commit 6666666666666666666666666666666666666666
Author: Some One <some.one@example.com>
Date:   Wed Sep 24 18:17:18 2014 +1000

    Message10

M   file3
SHOW
                ['Some One'],
                ['some.one@example.com'],
                [time . ' 5555555555555555555555555555555555555555'],
                ["  master"],
                <<'SHOW',
commit 5555555555555555555555555555555555555555
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                remote   => 1,
                branch   => 'other'
            },
            name   => 'show remote and other branch',
        },
        {
            ARGV => [qw{--all --once --sleep 0 --file qwerty.txt --branch other}],
            mock => [
                undef,
                [
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                undef,
                [
                    '6666666666666666666666666666666666666666',
                    '5555555555555555555555555555555555555555',
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                [time . ' 6666666666666666666666666666666666666666'],
                [map {"  $_"} qw/master other/],
                <<'SHOW',
commit 6666666666666666666666666666666666666666
Author: Some One <some.one@example.com>
Date:   Wed Sep 24 18:17:18 2014 +1000

    Message10

M   file3
SHOW
                ['Some One'],
                ['some.one@example.com'],
                [time . ' 5555555555555555555555555555555555555555'],
                ["  master"],
                <<'SHOW',
commit 5555555555555555555555555555555555555555
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => <<'STDOUT',
6666666666666666666666666666666666666666
  Branches: master, other
  Files:    file1, file2, file3
  Users:    Ivan Wills, Some One

STDOUT
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                all      => 1,
                file     => 'qwerty.txt',
                branch   => 'other'
            },
            name   => 'show all with file qwerty.txt and branch other',
        },
        {
            ARGV => [qw{--remote --once --sleep 0 --file qwerty.txt --branch no-found}],
            mock => [
                undef,
                [
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                undef,
                [
                    '6666666666666666666666666666666666666666',
                    '5555555555555555555555555555555555555555',
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
                [time . ' 6666666666666666666666666666666666666666'],
                [map {"  $_"} qw/master other/],
                <<'SHOW',
commit 6666666666666666666666666666666666666666
Author: Some One <some.one@example.com>
Date:   Wed Sep 24 18:17:18 2014 +1000

    Message10

M   file3
SHOW
                ['Some One'],
                ['some.one@example.com'],
                [time . ' 5555555555555555555555555555555555555555'],
                ["  master"],
                <<'SHOW',
commit 5555555555555555555555555555555555555555
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Wed Sep 24 18:16:18 2014 +1000

    Message10

M   file1
M   file2
SHOW
                ['Ivan Wills'],
                ['ivan.wills@example.com'],
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_options => '',
                once     => 1,
                remote   => 1,
                file     => 'qwerty.txt',
                branch   => 'no-found'
            },
            name   => 'show remote file qwerty.txt and branch that doesn\'t exist',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Watch', $data);
    }
}
