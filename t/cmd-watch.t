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
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Watch', $data);
    }
}
