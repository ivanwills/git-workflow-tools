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

our $VERSION  = 0.13;
our $workflow = App::Git::Workflow->new;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;

sub run {
    %option = (
        period => 'day',
    );
    get_options(
        \%option,
        'remote|r',
        'all|a',
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
        $branch =~ s/^[*]?\s*//;
        for my $log ($workflow->git->log('--format=format:%h %an', ($option{merges} ? () : '--no-merges'), "--since=$date", $branch)) {
            my ($hash, $name) = split /\s/, $log, 2;
            $users{$name}{$hash} = 1;
            $commits++;
        }
    }

    print map {sprintf "% 4d $_\n", $users{$_}}
        reverse sort {$users{$a} <=> $users{$b}}
        map { $users{$_} = scalar keys %{$users{$_}}; $_ }
        keys %users;
    print "Total commits = $commits\n";

    return;
}

1;

__DATA__

=head1 NAME

git-committers - Stats on the number of commits by committer

=head1 VERSION

This documentation refers to git-committers version 0.13

=head1 SYNOPSIS

   git-committers [option]

 OPTIONS:
  -d --date=YYYY-MM-DD
                Commits since this date
  -p --period=[day|week|month|year]
                If --date is not specified this works out the date for the
                last day/week/month/year
  -m --merges   Count merge commits
     --no-merges
                Don't count merge commits

  -v --verbose  Show more detailed option
     --VERSION  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-committers

=head1 DESCRIPTION

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
