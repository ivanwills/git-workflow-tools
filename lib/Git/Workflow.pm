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

our $VERSION     = 0.2;
our @EXPORT_OK   = qw/
    branches
    children
    config
    current
    match_commits
    release
    releases
    runner
    settings
    sha_from_show
    slurp
    tags
/;
our %EXPORT_TAGS = ();
our $VERBOSE     = 0;
our $TEST        = 0;

sub _alphanum_sort {
    no warnings qw/once/;
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
            sort _alphanum_sort
            map { /^[*]?\s+(?:remotes\/)?(.*?)\s*$/xms }
            grep {!/HEAD/}
            runner("git branch $type")
        ];

        return @{ $results{$type} };
    }
}

{
    my $result;
    sub tags {
        # assign to or cache
        $result ||= [
            sort _alphanum_sort
            map { /^(.*?)\s*$/xms }
            runner("git tag")
        ];

        return @{ $result };
    }
}

sub current {
    # get the git directory
    my $git_dir = runner("git rev-parse --show-toplevel");
    chomp $git_dir;

    # read the HEAD file to find what branch or id we are on
    open my $fh, '<', "$git_dir/.git/HEAD" or die "Can't open '$git_dir/.git/HEAD' for reading: $!\n";
    my $head = <$fh>;
    close $fh;
    chomp $head;

    if ($head =~ m{ref: refs/heads/(.*)$}) {
        return ('branch', $1);
    }

    # try to identify the commit as it's not a local branch
    open $fh, '<', "$git_dir/.git/FETCH_HEAD" or die "Can't open '$git_dir/.git/FETCH_HEAD' for reading: $!\n";
    while (my $line = <$fh>) {
        next if $line !~ /^$head/;

        my ($type, $name, $remote) = $line =~ /(tag|branch) \s+ '([^']+)' \s+ of \s+ (.*?) $/xms;
        # TODO calculate the remote's alias rather than assume that it is "origin"
        return ($type, $type eq 'branch' ? "origin/$name" : $name);
    }

    # not on a branch or commit
    return ('sha', $head);
}

sub config {
    my ($name, $default) = @_;
    local $SIG{__WARN__} = sub {};
    my $value = runner("git config $name");
    chomp $value;

    return $value || $default;
}

sub match_commits {
    my ($type, $regex, $max) = @_;
    $max ||= 1;
    my @commits = grep {/$regex/} $type eq 'tag' ? tags() : branches('both');

    my $oldest = @commits > $max ? -$max : -scalar @commits;
    return map { sha_from_show($_) } @commits[ $oldest .. -1 ];
}

sub release {
    my ($tag_or_branch, $local, $search) = @_;
    my ($release) = reverse grep {/$search/}
        $tag_or_branch eq 'branch'
        ? branches($local ? 'local' : 'remote')
        : tags();
    chomp $release;

    return $release;
}

sub releases {
    my %option = @_;
    my ($type, $regex);
    if ($option{tag}) {
        $type = 'tag';
        $regex = $option{tag};
    }
    elsif ($option{branch}) {
        $type = 'branch';
        $regex = $option{branch};
    }
    elsif ( !$option{tag} && !$option{branch} ) {
        my $prod = Git::Workflow::config('workflow.prod') || ( $option{local} ? 'branch=^master$' : 'branch=^origin/master$' );
        ($type, $regex) = split /\s*=\s*/, $prod;
        if ( !$regex ) {
            $type = 'branch';
            $regex = '^origin/master$';
        }
    }

    my @releases = Git::Workflow::match_commits($type, $regex, $option{max_history});
    die "Could not find any historic releases for $type /$regex/!\n" if !@releases;
    return @releases;
}

sub sha_from_show {
    my ($name, $no_branches) = @_;
    my ($log) = runner("git rev-list -1 --timestamp $name");
    chomp $log;
    my ($time, $sha) = split /\s+/, $log;
    return {
        name     => $name,
        sha      => $sha,
        time     => $time,
        branches => $no_branches ? {} : { map { $_ => 1 } branches('both', $sha) },
    };
}

sub slurp {
    my ($file) = @_;
    open my $fh, '<', $file or die "Can't open file '$file' for reading: $!\n";

    return wantarray ? <$fh> : do { local $/; <$fh> };
}

sub spew {
    my ($file, @out) = @_;
    open my $fh, '>', $file or die "Can't open file '$file' for writing: $!\n";

    print $fh @out;
}

sub children {
    my ($dir) = @_;
    opendir my $dh, $dir or die "Couldn't open directory '$dir' for reading: $!\n";

    return grep { $_ ne '.' && $_ ne '..' } readdir $dh;
}

sub runner {
    my @cmd = @_;

    print join ' ', @cmd, "\n" if $VERBOSE;
    return if $TEST;

    return system @cmd if !defined wantarray;

    carp "Too many arguments!\n" if @cmd != 1;

    return qx/$cmd[0]/;
}

{
    my ($settings, $file);
    sub settings {
        my $git_dir = runner("git rev-parse --show-toplevel");
        chomp $git_dir;

        if ($settings) {
            $settings->{$git_dir} ||= {};
            return $settings->{$git_dir};
        }
        $ENV{HOME} ||= "/tmp/";
        $file = "$ENV{HOME}/.git-workflow.settings";

        $settings
            = -f $file
            ? eval scalar slurp($file)  ## no critic
            : {};

        $settings->{$git_dir} ||= {};

        return $settings->{$git_dir};
    }

    sub save_settings {
        local $Data::Dumper::Indent   = 1;
        local $Data::Dumper::Sortkeys = 1;
        $settings->{version} =$Git::Workflow::VERSION;
        spew($file, 'my ' . Dumper $settings);
    }
}

sub DESTROY {
    save_settings();
}

1;

__END__

=head1 NAME

Git::Workflow - Git workflow tools

=head1 VERSION

This documentation refers to Git::Workflow version 0.2

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

=head2 C<_alphanum_sort ()>

Does sorting (for the building C<sort>) in a alpha numerical fashion.
Specifically all numbers are converted for the comparison to 14 digit strings
with leading zeros.

=head2 C<children ($dir)>

Get the child files of C<$dir>

=head2 C<config ($name, $default)>

Get the git config value of C<$name>, or if not set C<$default>

=head2 C<current ()>

Get the current branch/tag or commit

=head2 C<match_commits ($type, $regex, $max)>

=head2 C<release ($tag_or_branch, $local, $search)>

=head2 C<releases (%option)>

=head2 C<runner (@cmd)>

=head2 C<sha_from_show ($name)>

Get info from C<git show $name>

=head2 C<slurp ($file)>

Return the contents of C<$file>

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
