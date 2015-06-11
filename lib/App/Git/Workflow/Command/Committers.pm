package App::Git::Workflow::Command::Committers;

# Created on: 2014-06-11 10:00:36
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use English qw/ -no_match_vars /;
use Time::Piece;
use App::Git::Workflow;
use App::Git::Workflow::Command qw/get_options/;

our $VERSION  = 0.96008;
our $workflow = App::Git::Workflow->new;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;

sub run {
    my ($self) = @_;
    %option = (
        period => 'day',
        fmt    => 'table',
    );
    get_options(
        \%option,
        'remote|r',
        'all|a',
        'fmt|format|f=s',
        'date|d=s',
        'period|p=s',
        'merges|m!',
    );

    my %users;
    my $commits = 0;
    my $date = $option{date};

    if (!$date) {
        my $now = localtime;
        my $period
            = $option{period} eq 'day'   ? 1
            : $option{period} eq 'week'  ? 7
            : $option{period} eq 'month' ? 30
            : $option{period} eq 'year'  ? 365
            :                              die "Unknown period '$option{period}' please choose one of day, week, month or year\n";
        $date
            = $now->wday == 1 ? localtime(time - 3 * $period * 24 * 60 * 60)->ymd
            : $now->wday == 7 ? localtime(time - 2 * $period * 24 * 60 * 60)->ymd
            :                   localtime(time - 1 * $period * 24 * 60 * 60)->ymd;
    }

    my @options;
    push @options, '-r' if $option{remote};
    push @options, '-a' if $option{all};

    for my $branch ($workflow->git->branch(@options)) {
        next if $branch =~ / -> /;
        $branch =~ s/^[*]?\s*//;
        for my $log ($workflow->git->log('--format=format:%h %an', ($option{merges} ? () : '--no-merges'), "--since=$date", $branch)) {
            my ($hash, $name) = split /\s/, $log, 2;
            $users{$name}{$hash} = 1;
            $commits++;
        }
    }

    my $fmt = 'fmt_' . $option{fmt};
    if ($self->can($fmt)) {
        $self->$fmt(\%users, $commits);
    }

    return;
}

sub fmt_table {
    my ($self, $users, $total) = @_;

    print map {sprintf "% 4d $_\n", $users->{$_}}
        reverse sort {$users->{$a} <=> $users->{$b}}
        map { $users->{$_} = scalar keys %{$users->{$_}}; $_ }
        keys %$users;
    print "Total commits = $total\n";

    return;
}

sub fmt_json {
    my ($self, $users, $total) = @_;
    require JSON;

    print JSON::encode_json({ total => $total, users => $users });
}

sub fmt_perl {
    my ($self, $users, $total) = @_;
    require Data::Dumper;

    local $Data::Dumper::Indent = 1;
    print Data::Dumper::Dumper({ total => $total, users => $users });
}

1;

__DATA__

=head1 NAME

git-committers - Stats on the number of commits by committer

=head1 VERSION

This documentation refers to git-committers version 0.96008

=head1 SYNOPSIS

   git-committers [option]

 OPTIONS:
  -r --remote   Committers to remote branches
  -a --all      Committers to any branch (remote or local)
  -d --date=YYYY-MM-DD
                Commits since this date
  -f --format[=](table|json|csv)
                Change how the data is presented
                   - table : shows the data in a simple table
                   - json  : returns the raw data as a json object
                   - perl  : Dump the data structure
                   - csv   : Like table but as a csv
  -p --period=[day|week|month|year]
                If --date is not specified this works out the date for the
                last day/week/month/year
  -m --merges   Count merge commits
     --no-merges
                Don't count merge commits

  -v --verbose  Show more detailed option
     --version  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-committers

=head1 DESCRIPTION

The C<git-committers> command allows to get statistics on who is committing
to the git repository.

=head1 SUBROUTINES/METHODS

=head2 C<run ()>

Executes the git workflow command

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2014 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
