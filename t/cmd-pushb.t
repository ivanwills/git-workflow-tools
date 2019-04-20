#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Pushb;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [""],
            mock => [],
            STD => {
                OUT => '',
                ERR => '',
            },
            error => "git pushb: no other branch\n",
            option => {},
            name   => 'No inputs',
        },
        #{
        #    ARGV => [""],
        #    mock => [
        #        { 'rev-parse' => [qw/.git/] },
        #        { 'rev-parse' => [qw/.git/] },
        #        { checkout    => [qw//] },
        #    ],
        #    STD => {
        #        OUT => '',
        #        ERR => "git pushb: no other branch\n",
        #    },
        #    option => {},
        #    name   => 'Default 1',
        #},
    );

    local $Test::Git::Workflow::Command::workflow = 'App::Git::Workflow::Brs';
    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Pushb', $data)
            or last;
    }
}
