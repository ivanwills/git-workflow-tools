#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use Capture::Tiny qw/capture/;
use App::Git::Workflow::Command::TagGrep;
use lib 't/lib';
use Mock::App::Git::Workflow::Repository;

our $name = 'test';
my $git = Mock::App::Git::Workflow::Repository->git;
$App::Git::Workflow::Command::TagGrep::workflow->{git} = $git;
%App::Git::Workflow::Command::p2u_extra = ( -exitval => 'NOEXIT', );

run();
done_testing();

sub run {
    my @data = (
        [
            # @ARGV
            ["1"],
            # Mock Git
            [
                [qw/0.1 1.0 2.0/],
            ],
            # STDOUT
            "0.1\n1.0\n",
            # STDERR
            '',
            {},
        ],
        [
            # @ARGV
            ["3"],
            # Mock Git
            [
                [qw/1.0 2.0/],
            ],
            # STDOUT
            "\n",
            # STDERR
            '',
            {},
        ],
        [
            # @ARGV
            [qw/-i a/],
            # Mock Git
            [
                [qw/A b c/],
            ],
            # STDOUT
            "A\n",
            # STDERR
            '',
            { insensitive => 1 },
        ],
        [
            # @ARGV
            [],
            # Mock Git
            [
                [qw/A b c/],
            ],
            # STDOUT
            "A\nb\nc\n",
            # STDERR
            '',
            {},
        ],
    );

    for my $data (@data) {
        %App::Git::Workflow::Command::TagGrep::option = ();
        @ARGV = @{ $data->[0] };
        $git->mock_add(@{ $data->[1] });
        my ($stdout, $stderr) = capture { App::Git::Workflow::Command::TagGrep->run() };
        is $stdout, $data->[2], 'Ran STDOUT ' . join ' ', @{ $data->[0] }
            or diag Dumper $stdout, $data->[2];
        is $stderr, $data->[3], 'Ran STDERR ' . join ' ', @{ $data->[0] }
            or diag Dumper $stderr, $data->[3];
        is_deeply \%App::Git::Workflow::Command::TagGrep::option, $data->[4], 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::TagGrep::option, $data->[4];
    }
}
