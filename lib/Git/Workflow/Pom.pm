package Git::Workflow::Pom;

# Created on: 2014-08-06 19:04:05
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use XML::Tiny;
use Git::Workflow;
use base qw/Exporter/;

our $VERSION     = 0.2;
our @EXPORT_OK   = qw/get_pom_versions pom_version next_pom_version/;
our %EXPORT_TAGS = ();

sub alphanum_sort {
    my $A = $a;
    $A =~ s/(\d+)/sprintf "%014i", $1/egxms;
    my $B = $b;
    $B =~ s/(\d+)/sprintf "%014i", $1/egxms;

    return $A cmp $B;
}

sub get_pom_versions {
    my ($pom) = @_;
    my @branches = Git::Workflow::branches('both');
    my %versions;

    for my $branch (@branches) {
        my $xml = `git show $branch:$pom 2> /dev/null`;
        chomp $xml;
        next if !$xml;

        $branch =~ s{^origin/}{}xms;

        my $numerical = my $version = pom_version($xml);
        # remove snapshots from the end
        $numerical =~ s/-SNAPSHOT$//xms;
        # remove any extranious text from the front
        $numerical =~ s/^\D+//xms;

        $versions{$numerical} ||= {};
        $versions{$numerical}{$branch} = $version;
    }

    return \%versions;
}

sub pom_version {
    my ($xml) = @_;
    my $doc = XML::Tiny::parsefile( $xml !~ /\n/ && -f $xml ? $xml : '_TINY_XML_STRING_' . $xml);

    for my $elem (@{ $doc->[0]{content} }) {
        next if $elem->{name} ne 'version';

        return $elem->{content}[0]{content};
    }

    return;
}

sub next_pom_version {
    my ($pom, $versions) = @_;
    $versions ||= get_pom_versions($pom);

    my ($max) = reverse sort alphanum_sort keys %{$versions};
    my ($primary, $secondary) = split /[.]/, $max;
    $secondary++;

    return "$primary.$secondary.0-SNAPSHOT";
}

1;

__END__

=head1 NAME

Git::Workflow::Pom - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to Git::Workflow::Pom version 0.2


=head1 SYNOPSIS

   use Git::Workflow::Pom;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).


=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.

These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module
provides.

Name the section accordingly.

In an object-oriented module, this section should begin with a sentence (of the
form "An object of this class represents ...") to give the reader a high-level
context to help them understand the methods that are subsequently described.


=head3 C<new ( $search, )>

Param: C<$search> - type (detail) - description

Return: Git::Workflow::Pom -

Description:

=cut


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
<Author name(s)>  (<contact address>)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2014 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
