#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Path::Class;

my $base = file($0)->parent->parent;
my $lib  = $base->subdir('lib');
#my @files = $lib->children;
#
#while ( my $file = shift @files ) {
#    if ( -d $file ) {
#        push @files, $file->children;
#    }
#    elsif ( $file =~ /[.]pm$/ ) {
#        require_ok $file;
#    }
#}

my $bin = $base->subdir('bin');
my @files = $bin->children;

while ( my $file = shift @files ) {
    if ( -d $file ) {
        push @files, $file->children;
    }
    elsif ( $file !~ /[.]sw[ponx]$/ ) {
        my ($bang) = $file->slurp;
        next if $bang !~ /perl/;
        ok !(system qw/perl -Ilib -c /, $file), "$file compiles";
    }
}

diag( "Testing git-workflow-tools, Perl $], $^X" );
done_testing();
