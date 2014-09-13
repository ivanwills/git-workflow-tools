#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 3 + 1;
use Test::NoWarnings;
use Data::Dumper qw/Dumper/;
use lib 't/lib';
use Git::Workflow;
use Mock::Git::Workflow::Repository;

my $git = Mock::Git::Workflow::Repository->git;
my $pom = Git::Workflow->new( git => $git );

test_branches();
test_tags();
test_children();
test_config();
test_current();
test_match_commits();
test_release();
test_releases();
test_runner();
test_commit_details();
test_files_from_sha();
test_slurp();
test_spew();
test_settings();
test_save_settings();

sub test_branches {
}

sub test_tags {
    my @data = (
        [
            [qw/
                1.0
                10.0
                0.1
                v0.1
            /],
            [qw/
                0.1
                1.0
                10.0
                v0.1
            /],
        ]
    );

    for my $data (@data) {
        $git->mock_add($data->[0]);
        is_deeply [$pom->tags()], $data->[1], "Get the sorted tags"
            or diag Dumper [$pom->tags()], $data->[1];
    }
}

sub test_children {
}

sub test_config {
}

sub test_current {
}

sub test_match_commits {
    return;
    my @data = (
        [
            [
                [qw{1.0 2.0 3.0}],
                [qw{master origin/master}],
            ],
            [qw/tag ./],
            [{
                branches => {},
                sha      => undef,
                user     => 'test user',
                email    => 'test@example.com',
                files    => {},
                name     => '3.0',
                time     => time,
            }],
        ],
        [
            [
                [qw{master origin/master}],
            ],
            [qw/branch ./],
            [{
                branches => {},
                sha      => undef,
                user     => 'test user',
                email    => 'test@example.com',
                files    => {},
                name     => '3.0',
                time     => time,
            }],
        ],
    );

    TODO:
    for my $data (@data) {
        local $TODO = 'Need to decide if this even needs to exits';
        $git->mock_reset();
        $git->mock_add(@{ $data->[0] });
        $pom->{branches} = {};
        $pom->{tags}     = [];
        my $ans = [$pom->match_commits(@{$data->[1]})];
        is_deeply $ans, $data->[2], "Get the commits for $data->[1][0]"
            or diag Dumper $ans, $data->[2];
    }
}

sub test_release {
    my @data = (
        [
            [
                [qw{1.0 10.0 2.0 3.0 ZZZ}],
            ],
            [qw/tag local/, qr/^\d+/],
            '10.0',
        ],
        [
            [
                [map {"  $_"} qw{origin/other origin/master}],
            ],
            [qw/branch remote/, qr/master/],
            'origin/master',
        ],
    );

    for my $data (@data) {
        $git->mock_reset();
        $git->mock_add(@{ $data->[0] });
        $pom->{branches} = {};
        $pom->{tags}     = [];
        my $ans = $pom->release(@{$data->[1]});
        is_deeply $ans, $data->[2], "Get the commits for $data->[1][0]"
            or diag Dumper $ans, $data->[2];
    }
}

sub test_releases {
}

sub test_runner {
}

sub test_commit_details {
}

sub test_files_from_sha {
}

sub test_slurp {
}

sub test_spew {
}

sub test_settings {
}

sub test_save_settings {
}
