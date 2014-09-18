#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use Capture::Tiny qw/capture/;
use App::Git::Workflow::Command::Cows;
use lib 't/lib';
use Mock::App::Git::Workflow::Repository;

our $name = 'test';
my $git = Mock::App::Git::Workflow::Repository->git;
$App::Git::Workflow::Command::Cows::workflow->{git} = $git;
%App::Git::Workflow::Command::p2u_extra = ( -exitval => 'NOEXIT', );

run();
done_testing();

sub run {
    my @data = (
        [
            # @ARGV
            [],
            # Mock Git
            [
                [
                    "#  modified: file1\n",
                    "#  modified: file2\n",
                ],
                "file1 differs\n",
                "",
                undef,
            ],
            # STDOUT
            '',
            # STDERR
            "\tfile2\n",
            {},
        ],
        [
            # @ARGV
            [qw/--quiet/],
            # Mock Git
            [
                [
                    "#  modified: file1\n",
                    "#  modified: file2\n",
                ],
                "file1 differs\n",
                "",
                undef,
            ],
            # STDOUT
            '',
            # STDERR
            '',
            { quiet => 1 },
        ],
    );

    for my $data (@data) {
        @ARGV = @{ $data->[0] };
        $git->mock_add(@{ $data->[1] });
        my ($stdout, $stderr) = capture { App::Git::Workflow::Command::Cows->run() };
        is $stdout, $data->[2], 'Ran STDOUT ' . join ' ', @{ $data->[0] }
            or diag Dumper $stdout, $data->[2];
        is $stderr, $data->[3], 'Ran STDERR ' . join ' ', @{ $data->[0] }
            or diag Dumper $stderr, $data->[3];
        is_deeply \%App::Git::Workflow::Command::Cows::option, $data->[4], 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::Cows::option, $data->[4];
    }
}
