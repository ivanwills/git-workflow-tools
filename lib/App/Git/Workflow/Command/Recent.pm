package App::Git::Workflow::Command::Recent;

# Created on: 2014-03-11 20:58:59
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage ();
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use App::Git::Workflow;
use App::Git::Workflow::Command qw/get_options/;

our $VERSION  = 0.91;
our $workflow = App::Git::Workflow->new;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;

sub run {
    my $self = shift;

    get_options(
        \%option,
        'since|s=s',
        'day|d',
        'week|w',
        'month|m',
        'quiet|q',
    );

    # get a list of recent commits
    my @commits = $self->recent_commits(\%option);

    # find the files in each commit
    my %changed = $self->changed_from_shas(@commits);

    # display results
    warn Dumper \%changed;

    return;
}

sub recent_commits {
    my ($self, $option) = @_;

    my @args = ('--since', $option->{since} );

    if (!@args) {
        @args = $option->{week} ? ('--max-age', time - 7  * 24 * 60 * 60 )
            : $option->{month}  ? ('--max-age', time - 31 * 24 * 60 * 60 )
            :                     ('--max-age', time - 1  * 24 * 60 * 60 );
    }

    return $workflow->git->rev_list('--all', @args);
}

sub changed_from_shas {
    my ($self, @commits) = @_;
    my %changed;

    for my $sha (@commits) {
        my $changed = $workflow->commit_details($sha, branches => 1, files => 1, user => 1);
        for my $file (keys %{ $changed->{files} }) {
            $changed{$file} ||= {};
            $changed{$file}{users} = $changed->{user};
        }
    }

    return %changed;
}

1;

__DATA__

=head1 NAME

git-recent - checkout whitespace only changed files

=head1 VERSION

This documentation refers to git-recent version 0.91

=head1 SYNOPSIS

   git-recent [option]

 OPTIONS:
  -q --quiet    Suppress notifying of files changed

  -v --verbose  Show more detailed option
     --VERSION  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-recent

=head1 DESCRIPTION

C<git-recent> resets any files that only contain whitespace changes.
This is done by finding all files modified (as shown by a C<git status>) and
run them through C<git diff -w>. If any file results in no out put is shown
(i.e. the changes are only white spaces) the file is then C<git checkout>ed to
remove those changes.

This makes it easier make your commits clean of pointless whitespace only
changes and makes others work easier.

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
