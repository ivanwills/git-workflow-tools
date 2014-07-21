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

our $VERSION     = 0.1;
our @EXPORT_OK   = qw/branches tags alphanum_sort config match_commits slurp children /;
our %EXPORT_TAGS = ();

sub alphanum_sort {
    my $A = $a;
    $A =~ s/(\d+)/sprintf "%014i", $1/egxms;
    my $B = $b;
    $B =~ s/(\d+)/sprintf "%014i", $1/egxms;

    return $A cmp $B;
}

{
    my %results;
    sub branches {
        my ($type, $contains) = @_;
        $type
            = !defined $type    ? ''
            : $type eq 'local'  ? ''
            : $type eq 'remote' ? '-r'
            : $type eq 'both'   ? '-a'
            :                     confess "Unknown type '$type'!\n";

        if ($contains) {
            $type &&= "$type ";
            $type .= "--contains $contains";
        }

        # assign to or cache
        $results{$type} ||= [
            sort alphanum_sort
            map { /^[*]?\s+(?:remotes\/)?(.*?)\s*$/xms }
            grep {!/HEAD/}
            `git branch $type`
        ];

        return @{ $results{$type} };
    }
}

{
    my $result;
    sub tags {
        # assign to or cache
        $result ||= [
            sort alphanum_sort
            map { /^(.*?)\s*$/xms }
            `git tag`
        ];

        return @{ $result };
    }
}

sub config {
    my ($name, $default) = @_;
    local $SIG{__WARN__} = sub {};
    my $value = `git config $name`;
    chomp $value;

    return $value || $default;
}

sub match_commits {
    my ($type, $regex, $max) = @_;
    my @commits = grep {/$regex/} $type eq 'tag' ? tags() : branches('both');

    my $oldest = @commits > $max ? -$max : -scalar @commits;
    return map { sha_from_show($_) } @commits[ $oldest .. -1 ];
}

sub sha_from_show {
    my ($name) = @_;
    my ($log) = `git rev-list -1 --timestamp $name`;
    chomp $log;
    my ($time, $sha) = split /\s+/, $log;
    return {
        name     => $name,
        sha      => $sha,
        time     => $time,
        branches => { map { $_ => 1 } branches('both', $sha) },
    };
}

sub slurp {
    my ($file) = @_;
    open my $fh, '<', $file or die "Can't open file '$file' for reading: $!\n";

    return wantarray ? <$fh> : dop { local $/; <$fh> };
}

sub children {
    my ($dir) = @_;
    opendir my $dh, $dir or die "Couldn't open directory '$dir' for reading: $!\n";

    return grep { $_ ne '.' && $_ ne '..' } readdir $dh;
}

1;

__END__

=head1 NAME

Git::Workflow - Git workflow tools

=head1 VERSION

This documentation refers to Git::Workflow version 0.1

=head1 SYNOPSIS

   use Git::Workflow qw/branches tags/;

   # Get all local branches
   my @branches = branches();
   # or
   @branches = branches('local');

   # remote branches
   @branches = branches('remote');

   # both remote and local branches
   @branches = branches('both');

   # similarly for tags
   my @tags = tags();

=head1 DESCRIPTION

This module contains helper functions for the command line scripts.

=head1 SUBROUTINES/METHODS

=head2 C<branches ([ $type ])>

Param: C<$type> - one of local, remote or both

Returns a list of all branches of the specified type. (Default type is local)

=head2 C<tags ()>

Returns a list of all tags.

=head2 C<alphanum_sort ()>

Does sorting (for the building C<sort>) in a alpha numerical fashion.
Specifically all numbers are converted for the comparison to 14 digit strings
with leading zeros.

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
