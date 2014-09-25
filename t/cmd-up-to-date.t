#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::UpToDate;
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
                undef,
                undef,
                [map {"  $_"} qw{master origin/master}],
                ['1411637048 0000000000000000000000000000000000000000'],
                [map {"  $_"} qw{master origin/master}],
            ],
            STD => {
                OUT => '',
                ERR => "Missing release origin/master!\n",
            },
            option => {},
            name   => 'Default',
        },
        {
            ARGV => [qw/--quiet/],
            mock => [
                undef,
            ],
            STD => {
                OUT => qr/Usage:/,
                ERR => "Unknown option: quiet\n",
            },
            option => {},
            name   => 'Default',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::UpToDate', $data);
    }
}
