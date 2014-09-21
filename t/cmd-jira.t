#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use Capture::Tiny qw/capture/;
use App::Git::Workflow::Command::Jira;
use lib 't/lib';
use Mock::App::Git::Workflow::Repository;

our $name = 'test';
my $git = Mock::App::Git::Workflow::Repository->git;
$App::Git::Workflow::Command::Jira::workflow->{git} = $git;
%App::Git::Workflow::Command::p2u_extra = ( -exitval => 'NOEXIT', );
*App::Git::Workflow::Command::Jira::exit = sub { die "Exited with $_[0]\n"; };

run();
done_testing();

sub run {
    my @data = (
        [
            # @ARGV
            [],
            # Mock Git
            [
            ],
            # STDOUT
            qr/Usage:/,
            # STDERR
            qr/\ANo \s JIRA \s specified!\n/xms,
            {help => 1},
            'No Jira',
        ],
        [
            # @ARGV
            [qw/ABC-123/],
            # Mock Git
            [
                [map {"  $_"} qw/master abc_123/],
                undef,
            ],
            # STDOUT
            qr/^Switched to branch 'abc_123'$/,
            # STDERR
            qr/^$/,
            {},
            'Find local branch',
        ],
        [
            # @ARGV
            [qw/DEF-123/],
            # Mock Git
            [
                [],
                [],
            ],
            # STDOUT
            qr/^$/,
            # STDERR
            qr/git \s feature \s DEF-123/xms,
            {},
            'No local or remote branch',
        ],
        [
            # @ARGV
            [qw/ABC-123/],
            # Mock Git
            [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                undef,
            ],
            # STDOUT
            qr/^Switched to branch 'abc_123'$/,
            # STDERR
            qr/^$/,
            {},
            'Find remote branch',
        ],
        [
            # @ARGV
            [qw/ABC-123 -q/],
            # Mock Git
            [
                [map {"  $_"} qw/master abc_123/],
                undef,
            ],
            # STDOUT
            qr/^$/,
            # STDERR
            qr/^$/,
            {quiet => 1},
            'Find quiet local branch',
        ],
        [
            # @ARGV
            [qw/DEF-123 --quiet/],
            # Mock Git
            [
                [],
                [],
            ],
            # STDOUT
            qr/^$/,
            # STDERR
            qr//xms,
            {quiet => 1},
            'Quiet, No local or remote branch',
        ],
        [
            # @ARGV
            [qw/ABC-123 --quiet/],
            # Mock Git
            [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                undef,
            ],
            # STDOUT
            qr/^$/,
            # STDERR
            qr/^$/,
            {quiet => 1},
            'Find quiet remote branch',
        ],
        [
            # @ARGV
            [qw/ABC-123 --list/],
            # Mock Git
            [
                [map {"  $_"} qw/master abc_123/],
            ],
            # STDOUT
            qr/^abc_123$/,
            # STDERR
            qr/^$/,
            {list => 1},
            'List local branches',
        ],
    );

    for my $data (@data) {
        %App::Git::Workflow::Command::Jira::option = ();
        $App::Git::Workflow::Command::Jira::workflow->{branches} = {};
        @ARGV = @{ $data->[0] };
        $git->mock_reset();
        $git->mock_add(@{ $data->[1] });
        my ($stdout, $stderr) = capture { App::Git::Workflow::Command::Jira->run() };
        like $stdout, $data->[2], "STDOUT Ran $data->[5] \"git jira " . (join ' ', @{ $data->[0] }) .'"'
            or diag Dumper $stdout, $data->[2];
        like $stderr, $data->[3], "STDERR Ran $data->[5] \"git jira " . (join ' ', @{ $data->[0] }) .'"'
            or diag Dumper $stderr, $data->[3];
        is_deeply \%App::Git::Workflow::Command::Jira::option, $data->[4], 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::Jira::option, $data->[4];
    }
}
