package Git::Workflow::Repository;

# Created on: 2014-08-18 06:54:14
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Carp;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use Git;
use File::Spec;
use base qw/Exporter/;

our $VERSION     = 0.3;
our @EXPORT      = qw/git/;
our @EXPORT_OK   = qw//;
our %EXPORT_TAGS = ();
our $last;

sub new {
    my $caller = shift;
    my $class  = ref $caller ? ref $caller : $caller;
    my $self   = { repository => @_ || undef };
    if (!$self->{repository}) {
        my @dir = File::Spec->splitdir( File::Spec->rel2abs( File::Spec->curdir ) );
        while (
            @dir > 1
            && ! -d ( $self->{repository} = File::Spec->catdir(@dir, '.git') )
        ) {
            pop @dir;
        }
        die "Couldn't find the git repository!\n" if !-d $self->{repository};
    }
    $self->{git} = Git->repository(Directory => $self->{repository});

    bless $self, $class;

    return $last = $self;
}

sub git {
    return $last || Git::Workflow::Repository->new;
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;

    my $called =  $AUTOLOAD;
    $called =~ s/.*:://;
    $called =~ s/_/-/g;

    if ($ENV{REPO_RECORD}) {
        open my $fh, '>>', '/tmp/repo-record.txt';
        my ($result, @result);
        if (wantarray) {
            @result = $self->{git}->command($called, @_);
        }
        else {
            $result = $self->{git}->command($called, @_);
        }
        print {$fh} Dumper [$called, \@_, { scalar => $result, array => \@result }];
        return wantarray ? @result : $result;
    }

    return if !$self || !$self->{git};

    return $self->{git}->can($called)
        ? $self->{git}->$called(@_)
        : $self->{git}->command($called, @_);
}

1;

__END__

=head1 NAME

Git::Workflow::Repository - A basic wrapper around GIT

=head1 VERSION

This documentation refers to Git::Workflow::Repository version 0.3

=head1 SYNOPSIS

   use Git::Workflow::Repository qw/git/;

   # get the git object based on the current directory
   my $git = git();

   # call git sub commands
   $git->log('--oneline');
   $git->show('123ABC');
   $git->status();

=head1 DESCRIPTION

This is a thin wrapper around L<Git> that will default to using the current
directory for C<git>, adds a simple way of calling git sub-commands
as methods.

=head1 SUBROUTINES/METHODS

=head3 C<new (%options)>

Returns a new Git::Workflow::Repository

=head2 C<git ()>

Singleton to get the last created C<Git::Workflow::Repository> object or
create a new one.

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
