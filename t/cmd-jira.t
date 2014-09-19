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
        ],
    );

    for my $data (@data) {
        %App::Git::Workflow::Command::Jira::option = ();
        @ARGV = @{ $data->[0] };
        $git->mock_add(@{ $data->[1] });
        my ($stdout, $stderr) = capture { App::Git::Workflow::Command::Jira->run() };
        like $stdout, $data->[2], 'Ran STDOUT ' . join ' ', @{ $data->[0] }
            or diag Dumper $stdout, $data->[2];
        like $stderr, $data->[3], 'Ran STDERR ' . join ' ', @{ $data->[0] }
            or diag Dumper $stderr, $data->[3];
        is_deeply \%App::Git::Workflow::Command::Jira::option, $data->[4], 'Options set correctly'
            or diag Dumper \%App::Git::Workflow::Command::Jira::option, $data->[4];
    }
}
