#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use App::Git::Workflow::Command::Cows;
use lib 't/lib';
use Mock::App::Git::Workflow::Repository;

my $stdout;
my $git = Mock::App::Git::Workflow::Repository->git;
$App::Git::Workflow::Command::Cows->{git}{git} = $git;

run();
done_testing();

sub run {
    my @data = (
        [
            # @ARGV
            [qw/--VERSION/],
            # Mock Git
            [],
            # STDOUT
            undef,
        ],
        #[
        #    # @ARGV
        #    [qw/--VERSION/],
        #    # Mock Git
        #    [],
        #    # STDOUT
        #    '',
        #],
    );

    for my $data (@data) {
        push @ARGV, @{ $data->[0] };
        $git->mock_add(@{ $data->[1] });
        App::Git::Workflow::Command::Cows->run();
        is $stdout, $data->[2], 'Ran ' . ( $data->[3] ? $data->[3] : 'App::Git::Workflow::Command::Cows' )
            or diag Dumper $stdout, $data->[2];
    }
}
