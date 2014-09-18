#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;
use Capture::Tiny qw/capture/;
use App::Git::Workflow;
use App::Git::Workflow::Command qw/get_options/;
use lib 't/lib';
use Mock::App::Git::Workflow::Repository;

our $name = 'test';
my $git = Mock::App::Git::Workflow::Repository->git;
%App::Git::Workflow::Command::p2u_extra = ( -exitval => 'NOEXIT', );

options();
done_testing();

sub options {
    my @data = (
        [
            # @ARGV
            [qw/--VERSION/],
            # Mock Git
            [],
            # STDOUT
            qr/\Atest Version = $App::Git::Workflow::VERSION\n\Z/,
            { VERSION => 1 },
        ],
        [
            # @ARGV
            [qw/--help/],
            # Mock Git
            [],
            # STDOUT
            qr/\AUsage:\n     Stuff\n\n\Z/,
            { help => 1 },
        ],
        [
            # @ARGV
            [qw/--man/],
            # Mock Git
            [],
            # STDOUT
            qr/Test/xms,
            { man => 1 },
        ],
        [
            # @ARGV
            [qw/--unknown/],
            # Mock Git
            [],
            # STDOUT
            qr/\AUsage:\n     Stuff\n\n\Z/,
            {},
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
        @ARGV = @{ $data->[0] };
        $git->mock_add(@{ $data->[1] });
        my $option = {};
        my ($stdout) = capture { get_options($option) };
        like $stdout, $data->[2], 'Ran ' . join ' ', @{ $data->[0] }
            or diag Dumper $stdout, $data->[2], [ $stdout =~ /$data->[2]/ ];
        is_deeply $option, $data->[3], 'Options set correctly'
            or diag Dumper $option, $data->[3];
    }
}

=head1 NAME

Test

=head1 SYNOPSIS

 Stuff

=cut
