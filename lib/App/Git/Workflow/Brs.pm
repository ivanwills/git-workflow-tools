package App::Git::Workflow::Brs;

# Created on: 2019-04-20 08:37:44
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp;
use English qw/ -no_match_vars /;
use base 'App::Git::Workflow';

our $VERSION  = version->new(1.1.2);

sub get_brs {
    my ($self) = @_;
    my $git_dir = $self->git->rev_parse("--show-toplevel");
    chomp $git_dir;
    my $brs = "$git_dir/$self->{GIT_DIR}/brs";

    if ( ! -f $brs ) {
        return;
    }

    open my $fh, '<', $brs or die "Could not open '$brs': $!\n";
    my @branches = map {/^(.*?)\n\Z/; $1} <$fh>;
    close $fh;

    return @branches;
}

sub set_brs {
    my ($self, @branches) = @_;

    my $git_dir = $self->git->rev_parse("--show-toplevel");
    chomp $git_dir;
    my $brs = "$git_dir/$self->{GIT_DIR}/brs";
    open my $fh, '>', $brs or die "Could not open '$brs' for writing: $!\n";
    print {$fh} map {"$_\n"} @branches;
}

1;

__END__

=head1 NAME

App::Git::Workflow::Brs - Common methods for branch stack operations

=head1 VERSION

This documentation refers to App::Git::Workflow::Brs version 0.0.1


=head1 SYNOPSIS

   use App::Git::Workflow::Brs;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head2 C<get_brs ()>

Gets the current branch stack

=head2 C<set_brs ( @branches )>

Sets the new branch stack

=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2019 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
