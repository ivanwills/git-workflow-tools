package App::Git::Workflow::Command::Amend;

# Created on: 2014-03-11 20:58:59
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use English qw/ -no_match_vars /;
use Term::ANSIColor qw/colored/;
use App::Git::Workflow;
use App::Git::Workflow::Command qw/get_options/;

our $VERSION  = version->new(1.1.20);
our $workflow = App::Git::Workflow->new;
our ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;

sub run {
    get_options(
        \%option,
        'colour|color|c',
        'insensitive|i',
    );

}

1;

__DATA__

=head1 NAME

git-amend - Help amend many commits

=head1 VERSION

This documentation refers to git-amend version 1.1.20

=head1 SYNOPSIS

   git-amend [option]

 OPTIONS:

  -v --verbose  Show more detailed option
     --version  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-amend

=head1 DESCRIPTION

Short hand for running

C<git commit --amend>

Over more than one commit in the history

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
