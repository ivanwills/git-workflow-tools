package App::Git::Workflow::Command;

# Created on: 2014-03-11 20:58:59
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage ();
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use base qw/Exporter/;

our $VERSION   = 0.11;
our @EXPORT_OK = qw/get_options/;
our %p2u_extra;

sub get_options {
    my ($option, @options) = @_;
    my ($caller_package) = caller;
    $caller_package .= '.pm';
    $caller_package =~ s{::}{/}g;
    $caller_package = $INC{$caller_package};

    Getopt::Long::Configure('bundling');
    GetOptions(
        $option,
        @options,
        'verbose|v+',
        'man',
        'help',
        'VERSION!',
    ) or Pod::Usage::pod2usage(
        -verbose => 1,
        -input   => $caller_package,
        %p2u_extra,
    ) and return;

    if ( $option->{'VERSION'} ) {
        my $name = "${caller_package}::name";
        no strict qw/refs/; ## no critic
        print "${$name} Version = $VERSION\n";
        return;
    }
    elsif ( $option->{'man'} ) {
        Pod::Usage::pod2usage(
            -verbose => 2,
            -input   => $caller_package,
            %p2u_extra,
        );
        return;
    }
    elsif ( $option->{'help'} ) {
        Pod::Usage::pod2usage(
            -verbose => 1,
            -input   => $caller_package,
            %p2u_extra,
        );
        return;
    }

    return 1;
}

1;

__DATA__

=head1 NAME

App::Git::Workflow::Command - Helper for other commands

=head1 VERSION

This documentation refers to App::Git::Workflow::Command version 0.11

=head1 SYNOPSIS

   use App::Git::Workflow::Command qw/get_option/;

   my %option;
   get_options( \%option, 'test|t!', 'quiet|q' );

=head1 DESCRIPTION

Does the boilerplate for other command modules.

=head1 SUBROUTINES/METHODS

=head2 C<get_options ($option_hash, @options)>

Just a wrapper for L<Getopt::Long>'s C<GetOptions> which configures bundling
and adds verbose, help, man and VERSION options. Also if C<GetOptions> fails
usage info will be displayed.

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
