#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use FindBin qw/$Bin/;

require_ok('Git::Workflow');
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-cows"      ), "bin/git-cows compiles"      );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-feature"   ), "bin/git-feature compiles"   );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-jira"      ), "bin/git-jira compiles"      );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-up-to-date"), "bin/git-up-to-date compiles");

diag( "Testing git-workflow-tools, Perl $], $^X" );
done_testing();
