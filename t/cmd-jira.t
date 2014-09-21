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
%App::Git::Workflow::Command::p2u_extra = ( -exitval => 'NOEXIT', );

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [],
            mock => [
            ],
            STD => {
                OUT => qr/Usage:/,
                ERR => qr/\ANo \s JIRA \s specified!\n/xms,
            },
            option => {help => 1},
            name   => 'No Jira',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123/],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123'$/,
                ERR => qr/^$/,
            },
            option => {},
            name   => 'Find local branch',
        },
        {
            ARGV => [qw/DEF-123/],
            mock => [
                [],
                [],
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/git \s feature \s DEF-123/xms,
            },
            option => {},
            name   => 'No local or remote branch',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123'$/,
                ERR => qr/^$/,
            },
            option => {},
            name   => 'Find remote branch',
        },
        {
            ARGV => [qw/ABC-123 -q/],
            mock => [
                [map {"  $_"} qw/master abc_123/],
                undef,
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/^$/,
            },
            option => {quiet => 1},
            name   => 'Find quiet local branch',
        },
        {
            ARGV => [qw/DEF-123 --quiet/],
            mock => [
                [],
                [],
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr//xms,
            },
            option => {quiet => 1},
            name   => 'Quiet, No local or remote branch',
        },
        {
            ARGV => [qw/ABC-123 --quiet/],
            mock => [
                [map {"  $_"} qw/master /],
                [map {"  $_"} qw{origin/master origin/abc_123}],
                undef,
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/^$/,
            },
            option => {quiet => 1},
            name   => 'Find quiet remote branch',
        },
        {
            ARGV => [qw/ABC-123 --list/],
            mock => [
                [map {"  $_"} qw/master abc_123/],
            ],
            STD => {
                OUT => qr/^abc_123$/,
                ERR => qr/^$/,
            },
            option => {list => 1},
            name   => 'List local branches',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123 abc_123_v2/],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123'$/,
                ERR => qr/^Which \s branch:$/xms,
                IN  => "1\n",
            },
            option => {},
            name   => 'Find local branches (choose 1)',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123 abc_123_v2/],
                undef,
            ],
            STD => {
                OUT => qr/^Switched to branch 'abc_123_v2'$/,
                ERR => qr/^Which \s branch:$/xms,
                IN  => "2\n",
            },
            option => {},
            name   => 'Find local branches (choose 2)',
        },
        {
            ARGV => [qw/ABC-123/],
            mock => [
                [map {"  $_"} qw/master abc_123 abc_123_v2/],
                undef,
            ],
            STD => {
                OUT => qr/^$/,
                ERR => qr/^Unknown \s branch!$/xms,
                IN  => "3\n",
            },
            option => {},
            name   => 'Find local branches (choose 2)',
        },
    );

    for my $data (@data) {
        %App::Git::Workflow::Command::Jira::option = ();
        $App::Git::Workflow::Command::Jira::workflow = App::Git::Workflow::Pom->new(git => $git);
        @ARGV = @{ $data->{ARGV} };
        $git->mock_reset();
        $git->mock_add(@{ $data->{mock} });
        my $stdin;
        $data->{STD}{IN} ||= '';
        open $stdin, '<', \$data->{STD}{IN};
        my ($stdout, $stderr) = capture { local *STDIN = $stdin; App::Git::Workflow::Command::Jira->run() };
        like $stdout, $data->{STD}{OUT}, "STDOUT Ran $data->{name} \"git jira " . (join ' ', @{ $data->{ARGV} }) .'"'
            or diag Dumper $stdout, $data->{STD}{OUT};
        like $stderr, $data->{STD}{ERR}, "STDERR Ran $data->{name} \"git jira " . (join ' ', @{ $data->{ARGV} }) .'"'
            or diag Dumper $stderr, $data->{STD}{ERR};
        is_deeply \%App::Git::Workflow::Command::Jira::option, $data->{option}, 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::Jira::option, $data->{option};
    }
}
