#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use Capture::Tiny qw/capture/;
use App::Git::Workflow::Command::BranchClean;
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
                undef,
                [map {"  $_"} qw{master feature1 feature2}],
                [time . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master feature1}],
                undef,
                [time . ' 2222222222222222222222222222222222222222'],
                [map {"  $_"} qw{feature2}],
            ],
            STD => {
                OUT => qr//,
                ERR => qr/deleting \s merged \s branch \s feature1/xms,
            },
            option => {
                exclude => [],
                max_age => 120,
                tag_prefix => '',
                tag_suffix => '',
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--unknown}],
            mock => [
            ],
            STD => {
                OUT => qr//,
                ERR => qr/^Unknown \s option: \s unknown$/xms,
            },
            option => {
                exclude => [],
                max_age => 120,
                tag_prefix => '',
                tag_suffix => '',
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--remote}],
            mock => [
                200,
                [map {"  $_"} qw{origin/master origin/feature1 origin/feature2}],
                [time . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{origin/feature1}],
                [time . ' 2222222222222222222222222222222222222222'],
                [map {"  $_"} qw{origin/master origin/feature2}],
                undef,
            ],
            STD => {
                OUT => qr//,
                ERR => qr/deleting \s merged \s branch \s origin\/feature2/xms,
            },
            option => {
                exclude => [],
                max_age => 200,
                tag_prefix => '',
                tag_suffix => '',
                remote     => 1,
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--all --min-age 10 --max-age 30}],
            ENV  => {
                GIT_WORKFLOW_MAX_AGE => 90,
            },
            mock => [
                [map {"  $_"} qw{master origin/master young origin/old}],
                [(time - 60*60*24*50) . ' 1111111111111111111111111111111111111111'],
                undef,
                [(time - 60*60*24*5) . ' 2222222222222222222222222222222222222222'],
            ],
            STD => {
                OUT => qr//,
                ERR => qr/deleting \s old \s branch \s origin\/old/xms,
            },
            option => {
                exclude => [],
                min_age => 10,
                max_age => 30,
                tag_prefix => '',
                tag_suffix => '',
                all        => 1,
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--all --min-age 10 --max-age 0}],
            ENV  => {
                GIT_WORKFLOW_MAX_AGE => 90,
            },
            mock => [
                [map {"  $_"} qw{master origin/master young origin/old}],
                [(time - 60*60*24*50) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{origin/feature1}],
                [(time - 60*60*24*5) . ' 2222222222222222222222222222222222222222'],
                [map {"  $_"} qw{origin/master origin/feature2}],
                undef,
            ],
            STD => {
                OUT => qr//,
                ERR => qr/Deleted \s 0 \s of \s 1 \s branches/xms,
            },
            option => {
                exclude => [],
                min_age => 10,
                max_age => 0,
                tag_prefix => '',
                tag_suffix => '',
                all        => 1,
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--exclude-file t/data/excludes.txt}],
            mock => [
                undef,
                [map {"  $_"} qw{master feature exclude_me}],
                [(time - 60*60*24*50) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master}],
                undef,
            ],
            STD => {
                OUT => qr//,
                ERR => qr/Deleted \s 1 \s of \s 1 \s branches/xms,
            },
            option => {
                exclude => [],
                max_age => 120,
                tag_prefix => '',
                tag_suffix => '',
                exclude_file => 't/data/excludes.txt',
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--tag}],
            mock => [
                undef,
                [map {"  $_"} qw{master feature}],
                [(time - 60*60*24*50) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master}],
                undef,
                undef,
            ],
            STD => {
                OUT => qr//,
                ERR => qr/Deleted \s 1 \s of \s 1 \s branches/xms,
            },
            option => {
                exclude => [],
                max_age => 120,
                tag_prefix => '',
                tag_suffix => '',
                tag        => 1,
            },
            name   => 'default',
        },
        {
            ARGV => [qw{--tag --test}],
            mock => [
                undef,
                [map {"  $_"} qw{master feature}],
                [(time - 60*60*24*50) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master}],
            ],
            STD => {
                OUT => qr//,
                ERR => qr/Deleted \s 1 \s of \s 1 \s branches/xms,
            },
            option => {
                exclude => [],
                max_age => 120,
                tag_prefix => '',
                tag_suffix => '',
                tag        => 1,
                test       => 1,
            },
            name   => 'default',
        },
    );

    for my $data (@data) {
        %App::Git::Workflow::Command::BranchClean::option = ();
        $App::Git::Workflow::Command::BranchClean::workflow = App::Git::Workflow->new(git => $git);
        @ARGV = @{ $data->{ARGV} };
        local %ENV = %ENV;
        if ($data->{ENV}) {
            $ENV{$_} = $data->{ENV}{$_} for keys %{ $data->{ENV} };
        }
        $git->mock_reset();
        $git->mock_add(@{ $data->{mock} });
        my $stdin;
        $data->{STD}{IN} ||= '';
        open $stdin, '<', \$data->{STD}{IN};
        my ($stdout, $stderr) = capture { local *STDIN = $stdin; App::Git::Workflow::Command::BranchClean->run() };
        like $stdout, $data->{STD}{OUT}, "STDOUT Ran $data->{name} \"git branch-clean " . (join ' ', @{ $data->{ARGV} }) .'"'
            or diag Dumper $stdout, $data->{STD}{OUT};
        like $stderr, $data->{STD}{ERR}, "STDERR Ran $data->{name} \"git branch-clean " . (join ' ', @{ $data->{ARGV} }) .'"'
            or diag Dumper $stderr, $data->{STD}{ERR};
        is_deeply \%App::Git::Workflow::Command::BranchClean::option, $data->{option}, 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::BranchClean::option, $data->{option};
    }
}
