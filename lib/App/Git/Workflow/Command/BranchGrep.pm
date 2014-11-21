package App::Git::Workflow::Command::BranchGrep;

# Created on: 2014-03-11 20:58:59
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use English qw/ -no_match_vars /;
use App::Git::Workflow;
use App::Git::Workflow::Command qw/get_options/;

our $VERSION  = 0.95;
our $workflow = App::Git::Workflow->new;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;

sub run {
    get_options(
        \%option,
        'remote|r',
        'all|a',
        'insensitive|i',
    );

    $ARGV[0] ||= '';
    my @options;
    push @options, '-r' if $option{remote};
    push @options, '-a' if $option{all};
    my $grep = $option{insensitive} ? "(?i:$ARGV[0])" : $ARGV[0];

    print join "\n", sort {_sorter()} grep {/$grep/} $workflow->git->branch(@options);
    print "\n";
}

sub _sorter {
    no warnings;
    my $A = $a;
    my $B = $b;
    $A =~ s/(\d+)/sprintf "%06d", $1/egxms;
    $B =~ s/(\d+)/sprintf "%06d", $1/egxms;
    $A cmp $B;
}

1;

__DATA__

=head1 NAME

git-branch-grep - grep for branch names

=head1 VERSION

This documentation refers to git-branch-grep version 0.95

=head1 SYNOPSIS

   git-branch-grep [--remote|-r|--all|-a] regex

 OPTIONS:
  regex         grep's perl (-P) regular expression
  -r --remote   List all remote branches
  -a --all      List all branches

  -v --verbose  Show more detailed option
     --VERSION  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-branch-grep

=head1 DESCRIPTION

Short hand for running

C<git branch (-r|-a)? | grep -P 'regex'>

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
