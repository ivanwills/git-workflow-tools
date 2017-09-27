package App::Git::Workflow::Command::Branches;

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

our $VERSION = 1.0.2;
our $workflow = App::Git::Workflow->new;
my ($name)   = $PROGRAM_NAME =~ m{^.*/(.*?)$}mxs;
our %option;
our %p2u_extra;

sub run {
    my ($self) = @_;

    %option = (
        exclude    => [],
        max_age    => ( $ENV{GIT_WORKFLOW_MAX_AGE} || $workflow->config('workflow.max') || 120 ),
    );
    get_options(
        \%option,
        'remote|r',
        'all|a',
        'exclude|e=s@',
        'exclude_file|exclude-file|f=s',
        'max_age|max-age|m=i',
        'min_age|min-age|n=i',
        'tag|t!',
        'tag_prefix|tag-prefix|p=s',
        'tag_suffix|tag-suffix|s=s',
        'test!',
    ) or return;

    # get the list of branches to look at
    my $max      = 0;
    my @branches = $workflow->branches($option{remote} ? 'remote' : $option{all} ? 'both' : undef );
    my @excludes = @{ $option{exclude} };
    my ($total, $deleted) = (0, 0);

    if ($option{exclude_file}) {
        for my $exclude ($workflow->slurp($option{exclude_file})) {
            chomp $exclude;
            next if !$exclude;
            next if $exclude =~ /^\s*(?:[#].*)$/xms;
            push @excludes, $exclude;
        }
    }

    my @found;
    BRANCH:
    for my $branch (@branches) {
        # skip master branches
        next BRANCH if grep {$branch =~ /$_/} @excludes;

        # get branch details
        push @found, $workflow->commit_details($branch, branches => 0);
    }

    for (@found) {
        $max = length $_ if length $_ > $max;
    }

    for my $details (sort {$a->{time} <=> $b->{time}} @found) {
        printf "%-${max}s %s\n", $details->{name}, scalar localtime $details->{time};
    }

    return;
}

1;

__DATA__

=head1 NAME

git-branches - es old branches out of the repository

=head1 VERSION

This documentation refers to git-branches version 1.0.2

=head1 SYNOPSIS

   git-branches [option]

 OPTIONS:
  -r --remote   Only remote branches (defaults to local branches)
  -a --all      All branches
  -m --max-age[=]days
                Maximum age of a branch with out changes before it is esed
                weather it's merged to master or not. (Default 0, no max age)
  -n --min-age[=]days
                Leave branches this number of days or new alone even if merged
                to master. (default 7 days)
  -e --exclude[=]regex
                Regular expression to exclude specific branches from deletion.
                You can specify --exclude multiple times for more control.
     --exclude-file[=]file
                A file of exclude regular expressions, blank lines and lines
                starting with a hash (#) are ignored.
  -t --tag      Create tags of the same name as the branch
  -p --tag-prefix[=]str
                When converting a branch to a tag prepend it with "str"
  -s --tag-suffix[=]str
                When converting a branch to a tag apend it with "str"
     --test     Don't actually delete branches just report on what branches
                would be deleted.

  -v --verbose  Show more detailed option
     --version  Prints the version information
     --help     Prints this help information
     --man      Prints the full documentation for git-branches

=head1 DESCRIPTION

C<git-branches> deletes branches merged to master (but not newer than
C<--min-age> days). Optionally also deleting branches that haven't been
modified more than C<--max-age> days. When deleting branches they can be
converted to tags (C<--tag>) with optional an prefix (C<--tag-prefix>) and/or
an optional suffix (C<--tag-suffix>) added.

=head1 SUBROUTINES/METHODS

=head2 C<run ()>

Executes the git workflow command

=head2 C<do_delete ($branch, $details)>

Performs the deleting of old branches.

=head2 C<in_master ($details)>

The branch with C<$details> has been merged to master

=head2 C<too_old ($details)>

The branch with C<$details> has not been modified in greater than C<--max-age>
days.

=head2 C<too_young_to_die ($details)>

The branch was only recently used and should be esed.

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
