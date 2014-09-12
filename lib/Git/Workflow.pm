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
use Git::Workflow::Repository;
use base qw/Exporter/;

our $VERSION   = 0.4;
our @EXPORT_OK = qw/
    branches
    children
    config
    current
    match_commits
    release
    releases
    runner
    settings
    commit_details
    slurp
    tags
/;
our %EXPORT_TAGS = ();
our $VERBOSE     = 0;
our $TEST        = 0;
our $git         = Git::Workflow::Repository->git;

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
        my @options
            = !defined $type    ? ()
            : $type eq 'local'  ? ()
            : $type eq 'remote' ? ('-r')
            : $type eq 'both'   ? ('-a')
            :                     confess "Unknown type '$type'!\n";

        if ($contains) {
            push @options, "--contains", $contains;
        }

        # assign to or cache
        $results{$type} ||= [
            sort _alphanum_sort
            map { /^[*]?\s+(?:remotes\/)?(.*?)\s*$/xms }
            grep {!/HEAD/}
            $git->branch(@options)
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
            $git->tag
        ];

        return @{ $result };
    }
}

sub current {
    # get the git directory
    my $git_dir = $git->rev_parse("--show-toplevel");
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
    my $value = eval { $git->config($name) };
    chomp $value;

    return $value || $default;
}

sub match_commits {
    my ($type, $regex, $max) = @_;
    $max ||= 1;
    my @commits = grep {/$regex/} $type eq 'tag' ? tags() : branches('both');

    my $oldest = @commits > $max ? -$max : -scalar @commits;
    return map { commit_details($_, branches => 1) } @commits[ $oldest .. -1 ];
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

sub commit_details {
    my ($name, %options) = @_;
    my ($log) = $git->rev_list(qw/-1 --timestamp/, $name);
    chomp $log;
    my ($time, $sha) = split /\s+/, $log;

    return {
        name     => $name,
        sha      => $sha,
        time     => $time,
        branches => $options{branches} ? { map { $_ => 1 } branches('both', $sha) } : {},
        files    => $options{files}    ? files_from_sha($sha) : {},
        user     => $options{user}     ? $git->log(qw/--format=format:%an -1/, $name) : '',
        email    => $options{user}     ? $git->log(qw/--format=format:%ae -1/, $name) : '',
    };
}

sub files_from_sha {
    my ($sha) = @_;
    my $show = $git->show('--name-status', $sha);
    $show =~ s/\A.*\n\n//xms;
    my %files;
    for my $file (split /\n/, $show) {
        my ($state, $file) = split /\s+/, $file, 2;
        $files{$file} = $state;
    }

    return \%files;
}

sub slurp {
    my ($file) = @_;
    open my $fh, '<', $file or die "Can't open file '$file' for reading: $!\n";

    return wantarray ? <$fh> : do { local $/; <$fh> };
}

sub spew {
    my ($file, @out) = @_;
    die "No file passed!" if !$file;
    open my $fh, '>', $file or die "Can't open file '$file' for writing: $!\n";

    print $fh @out;
}

sub children {
    my ($dir) = @_;
    opendir my $dh, $dir or die "Couldn't open directory '$dir' for reading: $!\n";

    return grep { $_ ne '.' && $_ ne '..' } readdir $dh;
}

my %times;
sub runner {
    my @cmd = @_;

    print join ' ', @cmd, "\n" if $VERBOSE;
    return if $TEST;

    if (!defined wantarray) {
        if ($ENV{GIT_WORKFLOW_TIMER}) {
            require Time::HiRes;
            my $start = Time::HiRes::time();
            my $ans = system @cmd;
            push @{ $times{$cmd[1]} }, Time::HiRes::time() - $start;
            return $ans;
        }
        return system @cmd;
    }

    carp "Too many arguments!\n" if @cmd != 1;

    if ($ENV{GIT_WORKFLOW_TIMER}) {
        require Time::HiRes;
        my $start = Time::HiRes::time();
        my (@ans, $ans);
        if (wantarray) {
            @ans = qx/$cmd[0]/;
        }
        else {
            $ans = qx/$cmd[0]/;
        }
        my ($sub) = $cmd[0] =~ /^git \s (\S+) \s/xms;
        push @{ $times{$sub} }, Time::HiRes::time() - $start;
        return wantarray ? @ans : $ans;
    }

    return qx/$cmd[0]/;
}

{
    my ($settings, $file);
    sub settings {
        return $settings if $settings;

        $ENV{HOME} ||= "/tmp/";
        my $dir = "$ENV{HOME}/.git-workflow";
        mkdir $dir if !-d $dir;

        my $key = $git->config('remote.origin.url');
        chomp $key;
        if ( !$key ) {
            $key = $git->rev_parse("--show-toplevel");
            chomp $key;
        }
        $key = _url_encode($key);

        $file = "$dir/$key";

        $settings
            = -f $file
            ? do $file
            : {};

        if ( $settings->{version} && $settings->{version} > $Git::Workflow::VERSION ) {
            die "Current settings created with newer version than this program!\n";
        }

        return $settings;
    }

    sub save_settings {
        return if !$file;
        local $Data::Dumper::Indent   = 1;
        local $Data::Dumper::Sortkeys = 1;
        $settings->{version} =$Git::Workflow::VERSION;
        spew($file, 'my ' . Dumper $settings);
    }
}

sub _url_encode {
    my ($url) = @_;
    $url =~ s/([^-\w.:])/sprintf "%%%x", ord $1/egxms;
    return $url;
}

sub END {
    save_settings();
    if ($ENV{GIT_WORKFLOW_TIMER}) {
        for my $sub (sort keys %times) {
            print "git $sub\n";
            my $total = 0;
            map {$total += $_} @{ $times{$sub} };
            printf "    Avg : %0.4fs for %i runs. Total time %0.4fs\n", $total / @{ $times{$sub} }, (scalar @{ $times{$sub} }), $total;
        }
    }
}

1;

__END__

=head1 NAME

Git::Workflow - Git workflow tools

=head1 VERSION

This documentation refers to Git::Workflow version 0.4

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

=head2 C<commit_details ($name)>

Get info from C<git show $name>

=head2 C<files_from_sha ($sha)>

Get the files changed by the commit

=head2 C<slurp ($file)>

Return the contents of C<$file>

=head2 C<spew ( $file, @data )>

Write C<@data> to the file C<$file>

=head2 C<settings ()>

Get the saved settings for the current repository

=head2 C<save_settings ()>

Save any changed settings for the current repository

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
