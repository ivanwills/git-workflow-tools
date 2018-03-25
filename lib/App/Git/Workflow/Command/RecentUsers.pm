package App::Git::Workflow::Command::RecentUsers;

# Created on: 2014-03-11 20:58:59
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage ();
use English qw/ -no_match_vars /;
use App::Git::Workflow;
use App::Git::Workflow::Command qw/get_options/;
use base qw/App::Git::Workflow::Command::Recent/;

our $VERSION  = 1.0.4;
our $workflow = App::Git::Workflow->new;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;

sub run {
    my $self = shift;

    get_options(
        \%option,
        'all|a',
        'day|d',
        'insensitive|i',
        'month|m',
        'out|o=s',
        'quiet|q',
        'remote|r',
        'since|s=s',
        'week|w',
    );

    # get a list of recent commits
    my @commits = $self->recent_commits(\%option);

    # find the files in each commit
    my %changed = $self->changed_from_shas(@commits);

    # display results
    my $out = 'out_' . ($option{out} || 'text');

    if ($self->can($out)) {
        $self->$out(\%changed);
    }

    return;
}


1;

__DATA__

=head1 NAME

git-recent-users - grep tags

=head1 VERSION

This documentation refers to git-recent-users version 1.0.3

=head1 SYNOPSIS

   git-recent-users [option] regex

 OPTIONS:
  regex         grep's perl (-P) regular expression

  -v --verbose  Show more detailed option
     --version  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-recent-users

=head1 DESCRIPTION

Short hand for running

C<git tag | grep -P 'regex'>

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
