#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use Capture::Tiny qw/capture/;
use App::Git::Workflow::Command::Committers;
use lib 't/lib';
use Mock::App::Git::Workflow::Repository;

our $name = 'test';
my $git = Mock::App::Git::Workflow::Repository->git;
$App::Git::Workflow::Command::Committers::workflow->{git} = $git;
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
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'day' },
        ],
        [
            # @ARGV
            [qw/--period day/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'day' },
        ],
        [
            # @ARGV
            [qw/--period week/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'week' },
        ],
        [
            # @ARGV
            [qw/--period month/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'month' },
        ],
        [
            # @ARGV
            [qw/--period year/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'year' },
        ],
        [
            # @ARGV
            [qw/--period date/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'date' },
        ],
        [
            # @ARGV
            [qw/--date 2014-09-19/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'day', date => '2014-09-19' },
        ],
        [
            # @ARGV
            [qw/--all/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'day', all => 1 },
        ],
        [
            # @ARGV
            [qw/--remote/],
            # Mock Git
            [
                ['master'],
                ['abc123 User Name', '123abc User Name', 'a1b2c3 Other Name'],
            ],
            # STDOUT
            "   2 User Name\n   1 Other Name\nTotal commits = 3\n",
            # STDERR
            '',
            { period => 'day', remote => 1 },
        ],
    );

    for my $data (@data) {
        %App::Git::Workflow::Command::Committers::option = ();
        @ARGV = @{ $data->[0] };
        $git->mock_add(@{ $data->[1] });
        my ($stdout, $stderr) = capture { App::Git::Workflow::Command::Committers->run() };
        is $stdout, $data->[2], 'Ran STDOUT ' . join ' ', @{ $data->[0] }
            or diag Dumper $stdout, $data->[2];
        is $stderr, $data->[3], 'Ran STDERR ' . join ' ', @{ $data->[0] }
            or diag Dumper $stderr, $data->[3];
        is_deeply \%App::Git::Workflow::Command::Committers::option, $data->[4], 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::Committers::option, $data->[4];
    }
}
