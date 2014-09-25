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
                pull_cmd => 'pull',
                once     => 1,
            },
            name   => 'Default',
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
                pull_cmd => 'pull',
                once     => 1,
            },
            name   => 'Default',
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
                OUT => <<'STDOUT',
aaaaaaa @ Thu Sep 25 07:04:49 2014
  Branches: 
    master
  Files:    
    file1
    file2
  Users:    
    Ivan Wills

STDOUT
                ERR => '.',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_cmd => 'pull',
                once     => 1,
                verbose  => 1,
            },
            name   => 'Default',
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
                OUT => <<'STDOUT',
aaaaaaa @ Thu Sep 25 07:04:49 2014
STDOUT
                ERR => '.',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_cmd => 'pull',
                once     => 1,
                verbose  => 1,
                quiet    => 1,
            },
            name   => 'Default',
        },
        {
            ARGV => [qw{echo --once --sleep 0}],
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
                OUT => "\n",
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_cmd => 'pull',
                once     => 1,
            },
            name   => 'Default',
        },
        {
            ARGV => [qw{--remote --once --sleep 0}],
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
                    '5555555555555555555555555555555555555555',
                    '4444444444444444444444444444444444444444',
                    '3333333333333333333333333333333333333333',
                    '2222222222222222222222222222222222222222',
                    '1111111111111111111111111111111111111111',
                    '0000000000000000000000000000000000000000',
                ],
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
5555555555555555555555555555555555555555
  Branches: master
  Files:    file1, file2
  Users:    Ivan Wills

STDOUT
                ERR => '',
            },
            option => {
                max      => 10,
                sleep    => 0,
                pull_cmd => 'pull',
                once     => 1,
                remote    => 1,
            },
            name   => 'Default',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Watch', $data);
    }
}
