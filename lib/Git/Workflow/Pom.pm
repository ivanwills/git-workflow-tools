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
use Git::Workflow qw/branches runner/;
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
    my @branches = branches('both');
    my %versions;

    for my $branch (@branches) {
        my $xml = runner("git show $branch:$pom 2> /dev/null");
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

Git::Workflow::Pom - Tools for maven POM files with git

=head1 VERSION

This documentation refers to Git::Workflow::Pom version 0.2

=head1 SYNOPSIS

   use Git::Workflow::Pom;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.


=head1 DESCRIPTION

This library provides tools for looking at POM files in different branches.

=head1 SUBROUTINES/METHODS

=over 4

=item C<get_pom_versions ($pom_file)>

Find all POM versions used in all branches.

=item C<pom_version ($xml_text_or_file)>

Extract the version number from C$xml_text_or_file>

=item C<next_pom_version ($pom, $versions)>

Find the next available POM version number.

=back

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
