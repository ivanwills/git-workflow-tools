#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::Files;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [
                    '1111111111111111111111111111111111111111',
                    '2222222222222222222222222222222222222222',
                    '3333333333333333333333333333333333333333',
                ],
                [
                    '1111111 Message',
                    'file1',
                ],
                [
                    '2222222 Message',
                    'file2',
                ],
                [
                    '3333333 Message',
                    'file1',
                ],
            ],
            STD => {
                OUT => "   1 file2\n   2 file1\n",
                ERR => '',
            },
            option => {age => 28},
            name   => 'Default files changed',
        },
        {
            ARGV => [qw/--unknown/],
            mock => [
            ],
            STD => {
                OUT => qr/^Usage:$/xms,
                ERR => "Unknown option: unknown\n",
            },
            option => {age => 28},
            name   => 'Bad argument',
        },
        {
            ARGV => [qw/garbage --since 2014-09-24/],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [
                    '1111111111111111111111111111111111111111',
                    '2222222222222222222222222222222222222222',
                    '3333333333333333333333333333333333333333',
                    '4444444444444444444444444444444444444444',
                ],
                [
                    '1111111 Message',
                    'file1',
                ],
                [
                    '2222222 Message',
                    'file2',
                ],
                [
                    '3333333 Message',
                    'file1',
                ],
                [
                    '4444444 Message',
                    'file2',
                ],
            ],
            STD => {
                OUT => "   2 file1\n   2 file2\n",
                ERR => '',
            },
            option => {age => 28, since => '2014-09-24'},
            name   => 'files changed',
        },
        {
            ARGV => [qw/local/],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [qw/file1 file2/],
                [
                    '1111111111111111111111111111111111111111',
                    '2222222222222222222222222222222222222222',
                    '3333333333333333333333333333333333333333',
                    '4444444444444444444444444444444444444444',
                ],
                [
                    '1111111 Message',
                    'file1',
                ],
                [
                    '2222222 Message',
                    'file2',
                ],
                [
                    '3333333 Message',
                    'file1',
                ],
                [
                    '4444444 Message',
                    'file2',
                ],
                't/data/git-files',
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 23 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 3333333333333333333333333333333333333333
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 21 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 2222222222222222222222222222222222222222
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 22 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 4444444444444444444444444444444444444444
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 20 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
            ],
            workflow => {
                GIT_DIR => 'git',
            },
            STD => {
                OUT => <<'STDOUT',
file1
    Modified in : master
             by : Ivan Wills
file2
    Modified in : master
             by : Ivan Wills
STDOUT
                ERR => '',
            },
            option => {age => 28},
            name   => 'local',
        },
        {
            ARGV => [qw/local/],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [qw{file1 file2}],
                [],
                't/data/git-files',
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            workflow => {
                GIT_DIR => 'git',
            },
            option => {age => 28},
            name   => 'local no changes',
        },
        {
            ARGV => [qw/local/],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [qw/file1 file2/],
                [
                    '1111111111111111111111111111111111111111',
                    '2222222222222222222222222222222222222222',
                    '3333333333333333333333333333333333333333',
                    '4444444444444444444444444444444444444444',
                ],
                [
                    '1111111 Message',
                    'file1',
                ],
                [
                    '2222222 Message',
                    'file2',
                ],
                [
                    '3333333 Message',
                    'file1',
                ],
                [
                    '4444444 Message',
                    'file2',
                ],
                't/data/git-files',
                [],
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 3333333333333333333333333333333333333333
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 21 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 2222222222222222222222222222222222222222
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 22 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 4444444444444444444444444444444444444444
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 20 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
            ],
            workflow => {
                GIT_DIR => 'git',
            },
            STD => {
                OUT => <<'STDOUT',
file1
    Modified in : master
             by : Ivan Wills
file2
    Modified in : master
             by : Ivan Wills
STDOUT
                ERR => '',
            },
            option => {age => 28},
            name   => 'local no branch',
        },
        {
            ARGV => [qw/local --verbose/],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [qw/file1 file2/],
                [
                    '1111111111111111111111111111111111111111',
                    '2222222222222222222222222222222222222222',
                    '3333333333333333333333333333333333333333',
                    '4444444444444444444444444444444444444444',
                ],
                [
                    '1111111 Message',
                    'file1',
                ],
                [
                    '2222222 Message',
                    'file2',
                ],
                [
                    '3333333 Message',
                    'file1',
                ],
                [
                    '4444444 Message',
                    'file2',
                ],
                't/data/git-files',
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 23 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 3333333333333333333333333333333333333333
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 21 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 2222222222222222222222222222222222222222
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 22 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 4444444444444444444444444444444444444444
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 20 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
            ],
            workflow => {
                GIT_DIR => 'git',
            },
            STD => {
                OUT => <<'STDOUT',
file1
    Modified in : master
             by : Ivan Wills
file2
    Modified in : master
             by : Ivan Wills
STDOUT
                ERR => "file1\nfile2\n",
            },
            option => {age => 28, verbose => 1},
            name   => 'local verbose',
        },
        {
            ARGV => [qw/local -vv/],
            mock => [
                undef,
                [map {"  $_"} qw{master origin/master}],
                [(time - 60*60*24*5) . ' 1111111111111111111111111111111111111111'],
                [map {"  $_"} qw{master origin/master}],
                [qw/file1 file2/],
                [
                    '1111111111111111111111111111111111111111',
                    '2222222222222222222222222222222222222222',
                    '3333333333333333333333333333333333333333',
                    '4444444444444444444444444444444444444444',
                ],
                [
                    '1111111 Message',
                    'file1',
                ],
                [
                    '2222222 Message',
                    'file2',
                ],
                [
                    '3333333 Message',
                    'file1',
                ],
                [
                    '4444444 Message',
                    'file2',
                ],
                't/data/git-files',
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 1111111111111111111111111111111111111111
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 23 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 3333333333333333333333333333333333333333
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 21 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 2222222222222222222222222222222222222222
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 22 19:37:19 2014 +1000

    a => b

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-a
+b
SHOW
                [map {"  $_"} qw{master origin/master}],
                <<'SHOW',
commit 4444444444444444444444444444444444444444
Author: Ivan Wills <ivan.wills@gmail.com>
Date:   Tue Sep 20 19:37:19 2014 +1000

    b => a

diff --git a/file1 b/file1
index 7adad42..af54afc 100644
--- a/file1
+++ b/file1
@@ -1,1 +1,1 @@

-b
+a
SHOW
            ],
            workflow => {
                GIT_DIR => 'git',
            },
            STD => {
                OUT => <<'STDOUT',
file1
    Modified in : master
             by : Ivan Wills
file2
    Modified in : master
             by : Ivan Wills
STDOUT
                ERR => <<'STDERR',
file1
    1111111111111111111111111111111111111111
    3333333333333333333333333333333333333333
file2
    2222222222222222222222222222222222222222
    4444444444444444444444444444444444444444
STDERR
            },
            option => {age => 28, verbose => 2},
            name   => 'local very verbose',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::Files', $data)
            or return;
    }
}
