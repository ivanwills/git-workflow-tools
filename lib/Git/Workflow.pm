package Git::Workflow;

# Created on: 2014-03-11 22:09:32
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use base qw/Exporter/;

our $VERSION     = 0.001;
our @EXPORT_OK   = qw/branches/;
our %EXPORT_TAGS = ();

sub branches {
    my ($type) = @_;
    $type
        = !defined $type    ? ''
        : $type eq 'local'  ? ''
        : $type eq 'remote' ? '-r'
        : $type eq 'both'   ? '-b'
        :                     confess "Unknown type '$type'!\n";

    return grep {/^(\w+_)?$jira/}
        map {/^[*]?\s+(.*?)\n/}
        `git branch $type`;
}

1;

__END__

=head1 NAME

Git::Workflow - Git workflow tools

=head1 VERSION

This documentation refers to Git::Workflow version 0.0.1

=head1 SYNOPSIS

   use Git::Workflow qw/branches/;

   # Get all local branches
   my @branches = branches();
   # or
   @branches = branches('local');

   # remote branches
   @branches = branches('remote');

   # both remote and local branches
   @branches = branches('both');

=head1 DESCRIPTION

This module contains helper functions for the command line scripts.

=head1 SUBROUTINES/METHODS

=head2 C<branches ([ $type ])>

Param: C<$type> - one of local, remote or both

Returns a list of all branches the the specified type. (Default type is local)

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
