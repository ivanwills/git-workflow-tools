#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Feature;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';
$Test::Git::Workflow::Command::workflow = 'App::Git::Workflow::Pom';
run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [],
            mock => [
                undef,
                undef,
                undef,
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
            },
            error => "No JIRA specified!\n",
            name  => 'No branches',
        },
        {
            ARGV => [],
            mock => [
                undef,
                'a/pom.xml',
                undef,
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'a/pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
            },
            error => "No JIRA specified!\n",
            name  => 'No branches (set pom)',
        },
        {
            ARGV => [qw{feature_1}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                'branch=release',
                undef,
                [map {"  $_"} qw{origin/master origin/release}],
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
            },
            name  => 'Simple create feature branch',
        },
        {
            ARGV => [qw{feature_1 -v}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                'branch=release',
                undef,
                [map {"  $_"} qw{origin/master origin/release}],
                undef,
            ],
            STD => {
                OUT => "Created feature_1\n",
                ERR => '',
            },
            option => {
                pom   => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
                verbose => 1,
            },
            name  => 'Simple create feature branch (verbose)',
        },
        {
            ARGV => [qw{feature_1 --push}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                'branch=release',
                undef,
                [map {"  $_"} qw{origin/master origin/release}],
                undef,
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
                push  => 1,
            },
            name  => 'Simple create feature branch, pushed',
        },
        {
            ARGV => [qw{feature_1 --no-fetch}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                'branch=release',
                [map {"  $_"} qw{origin/master origin/release}],
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
                fetch => 0,
            },
            name  => 'Simple create feature branch, fetching',
        },
        {
            ARGV => [qw{feature_1 --tag release}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                undef,
                [qw{v1 v2 release}],
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
                tag   => 'release',
            },
            name  => 'Simple create feature branch, fetching',
        },
        {
            ARGV => [qw{feature_1 --branch release}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                undef,
                [map {"  $_"} qw{origin/master origin/release}],
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
                branch => 'release',
            },
            name  => 'Simple create feature branch, pushed',
        },
        {
            ARGV => [qw{feature_1 --local}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                undef,
                undef,
                [map {"  $_"} qw{master release}],
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
                local => 1,
            },
            name  => 'Simple create feature branch',
        },
        {
            ARGV => [qw{feature_1}],
            mock => [
                undef,
                undef,
                undef,
                undef,
                undef,
                undef,
                [map {"  $_"} qw{origin/master origin/release}],
                undef,
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {
                pom => 'pom.xml',
                local => undef,
                fetch => 1,
                url   => undef,
            },
            name  => 'Simple create feature branch',
        },
    );

    for my $data (@data) {
        # add mock for max age
        $Test::Git::Workflow::Command::git->mock_add(undef);
        command_ok('App::Git::Workflow::Command::Feature', $data);
    }
}
