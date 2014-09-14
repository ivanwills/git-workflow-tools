#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 17 + 1;
use Test::NoWarnings;

sub not_in_file_ok {
    my ($filename, %regex) = @_;
    open( my $fh, '<', $filename )
        or die "couldn't open $filename for reading: $!";

    my %violated;

    while (my $line = <$fh>) {
        while (my ($desc, $regex) = each %regex) {
            if ($line =~ $regex) {
                push @{$violated{$desc}||=[]}, $.;
            }
        }
    }

    for my $test (keys %regex) {
        ok !$violated{$test}, $test or diag "$test appears on lines @{$violated{$_}}";
    }
}

sub module_boilerplate_ok {
    my ($module) = @_;
    subtest $module => sub {
        not_in_file_ok($module =>
            'the great new $MODULENAME' => qr/ - The great new /,
            'boilerplate description'   => qr/Quick summary of what the module/,
            'stub function definition'  => qr/function[12]/,
            'module description'        => qr/One-line description of module/,
            'description'               => qr/A full description of the module/,
            'subs / methods'            => qr/section listing the public components/,
            'diagnostics'               => qr/A list of every error and warning message/,
            'config and environment'    => qr/A full explanation of any configuration/,
            'dependencies'              => qr/A list of all of the other modules that this module relies upon/,
            'incompatible'              => qr/any modules that this module cannot be used/,
            'bugs and limitations'      => qr/A list of known problems/,
            'contact details'           => qr/<contact address>/,
        );
    };
}

subtest 'README' => sub {
    not_in_file_ok((-f 'README' ? 'README' : 'README.pod') =>
        "The README is used..."       => qr/The README is used/,
        "'version information here'"  => qr/to provide version information/,
    );
};

subtest 'Changes' => sub {
    not_in_file_ok(Changes =>
        "placeholder date/time"       => qr(Date/time)
    );
};

module_boilerplate_ok('bin/git-branch-clean');
module_boilerplate_ok('bin/git-branch-grep');
module_boilerplate_ok('bin/git-committers');
module_boilerplate_ok('bin/git-cows');
module_boilerplate_ok('bin/git-feature');
module_boilerplate_ok('bin/git-files');
module_boilerplate_ok('bin/git-hook-setup');
module_boilerplate_ok('bin/git-jira');
module_boilerplate_ok('bin/git-pom');
module_boilerplate_ok('bin/git-tag-grep');
module_boilerplate_ok('bin/git-up-to-date');
module_boilerplate_ok('bin/git-watch');
module_boilerplate_ok('lib/Git/Workflow.pm');
module_boilerplate_ok('lib/Git/Workflow/Pom.pm');
module_boilerplate_ok('lib/Git/Workflow/Repository.pm');
