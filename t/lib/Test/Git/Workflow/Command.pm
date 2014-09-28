package Test::Git::Workflow::Command;

# Created on: 2014-09-23 06:44:54
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use Carp;
use English qw/ -no_match_vars /;
use base qw/Exporter/;
use Test::More;
use Capture::Tiny qw/capture/;
use Test::MockTime qw/restore_time set_fixed_time/;
use App::Git::Workflow;
use Mock::App::Git::Workflow::Repository;

our $VERSION     = 0.7;
our @EXPORT      = qw/command_ok/;
our @EXPORT_OK   = qw/command_ok/;
our %EXPORT_TAGS = ();
our $workflow    = 'App::Git::Workflow';

our $git = Mock::App::Git::Workflow::Repository->git;
%App::Git::Workflow::Command::p2u_extra = ( -exitval => 'NOEXIT', );

sub command_ok ($$) {  ## no critic
    my ($module, $data) = @_;
    subtest $data->{name} => sub {
        no strict qw/refs/;  ## no critic

        if ($data->{skip} && $data->{skip}->()) {
            plan skip_all => "Skipping $data->{name}";
            return;
        }

        # initialise
        $git->mock_reset();
        $git->mock_add(@{ $data->{mock} });

        $git->{ran} = [];
        %{"${module}::option"} = ();
        ${"${module}::workflow"} = $workflow->new(git => $git);
        if ($data->{workflow}) {
            ${"${module}::workflow"}->{$_} = $data->{workflow}{$_} for keys %{ $data->{workflow} };
        }

        local @ARGV = @{ $data->{ARGV} };
        local %ENV = %ENV;
        if ($data->{ENV}) {
            $ENV{$_} = $data->{ENV}{$_} for keys %{ $data->{ENV} };
        }
        my $stdin;
        $data->{STD}{IN} ||= '';
        open $stdin, '<', \$data->{STD}{IN};

        if ($data->{time}) {
            set_fixed_time($data->{time});
        }

        # run the code
        my $error;
        my ($stdout, $stderr) = capture { local *STDIN = $stdin; eval { $module->run() }; $error = $@; };

        ## Tests
        if ($error) {
            #die $error, $stderr if !$data->{error};
            is $error, $data->{error}, "Error matches"
                or diag explain $error, $data->{error};
        }

        # STDOUT
        if ( !ref $data->{STD}{OUT} ) {
            is $stdout, $data->{STD}{OUT}, "STDOUT $data->{name} run"
                or diag explain $stdout, $data->{STD}{OUT};
        }
        elsif ( ref $data->{STD}{OUT} eq 'Regexp' ) {
            like $stdout, $data->{STD}{OUT}, "STDOUT $data->{name} run"
                or diag explain $stdout, $data->{STD}{OUT};
        }
        elsif ( ref $data->{STD}{OUT} eq 'HASH' ) {
            #chomp $stdout;
            my $actual   = $data->{STD}{OUT_PRE} ? eval { $data->{STD}{OUT_PRE}->($stdout) } : $stdout;
            #diag explain [$stdout, $data, $@] if $@;
            is_deeply $actual, $data->{STD}{OUT}, "STDOUT $data->{name} run"
                or diag explain $actual, $data->{STD}{OUT};
        }

        # STDERR
        if ( !ref $data->{STD}{ERR} ) {
            is $stderr, $data->{STD}{ERR}, "STDERR $data->{name} run"
                or diag explain $stderr, $data->{STD}{ERR};
        }
        elsif ( ref $data->{STD}{ERR} eq 'Regexp' ) {
            like $stderr, $data->{STD}{ERR}, "STDERR $data->{name} run"
                or diag explain $stderr, $data->{STD}{ERR};
        }
        elsif ( ref $data->{STD}{ERR} eq 'HASH' ) {
            my $actual   = $data->{STD}{ERR_PRE} ? $data->{STD}{ERR_PRE}->($stdout) : $stdout;
            is_deeply $actual, $data->{STD}{ERR}, "STDERR $data->{name} run"
                or diag explain $actual, $data->{STD}{ERR};
        }

        is_deeply \%{"${module}::option"}, $data->{option}, 'Options set correctly'
            or diag explain \%{"${module}::option"}, $data->{option};
        ok !@{ $git->{data} }, "All data setup is used"
            or diag explain $git->{data};

        if ($data->{time}) {
            restore_time();
        }
    };
}


1;

__END__

=head1 NAME

Test::Git::Workflow::Command - <One-line description of module's purpose>

=head1 VERSION

This documentation refers to Test::Git::Workflow::Command version 0.7


=head1 SYNOPSIS

   use Test::Git::Workflow::Command;

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

Return: Test::Git::Workflow::Command -

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
