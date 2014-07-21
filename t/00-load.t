#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use FindBin qw/$Bin/;

use_ok('Git::Workflow');
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-branch-grep" ), "bin/git-branch-grep compiles");
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-committers"  ), "bin/git-committers compiles" );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-cows"        ), "bin/git-cows compiles"       );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-feature"     ), "bin/git-feature compiles"    );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-hook-setup"  ), "bin/git-hook-setup compiles" );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-jira"        ), "bin/git-jira compiles"       );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-pom"         ), "bin/git-pom compiles"        );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-tag-grep"    ), "bin/git-tag-grep compiles"   );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-undo-regen"  ), "bin/git-undo-regen compiles" );
ok( !(system 'perl', "-I $Bin/../lib", '-c', "$Bin/../bin/git-up-to-date"  ), "bin/git-up-to-date compiles" );

diag( "Testing git-workflow-tools, Perl $], $^X" );
done_testing();
