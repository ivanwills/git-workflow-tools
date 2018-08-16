#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Amend;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => ["1"],
            mock => [
                { tag => [qw/0.1 1.0 2.0/] },
            ],
            STD => {
                OUT => "0.1\n1.0\n",
                ERR => '',
            },
            option => {},
            name   => 'Default 1',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::TagGrep', $data)
            or return;
    }
}
