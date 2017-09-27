#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Branches;
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
                { config => undef },
                { branch => [] },
            ],
            STD => {
                OUT => qr//,
                ERR => qr//xms,
            },
            option => {
                exclude => [],
                max_age => 120,
            },
            name   => 'default',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Branches', $data)
            or return;
    }
}
