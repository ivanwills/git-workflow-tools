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
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Recent', $data);
    }
}
