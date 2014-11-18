use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'App-Git-Workflow',
    license           => 'perl',
    dist_author       => 'Ivan Wills <ivan.wills@gmail.com>',
    dist_version_from => 'lib/App/Git/Workflow.pm',
    dist_abstract     => 'Tools to help make git workflows easier',
    requires          => {
        'perl'        => '5.008',
        'autodie'     => 0,
        'Error'       => 0,
        'Git'         => 0,
        'XML::Tiny'   => 0,
        'Path::Class' => 0,
        'Time::Piece' => 0,
    },
    recommends => {
        'JSON'       => '2.0',
        'JIRA::REST' => 0,
    },
    build_requires => {
        'Capture::Tiny'  => 0,
        'Test::MockTime' => 0,
        'Test::More'     => 0,
        'Test::Warnings' => 0,

    },
    add_to_cleanup     => [ 'App-Git-Workflow-*' ],
    create_makefile_pl => 'traditional',
    create_license     => 1,
    meta_merge => {
        resources => {
            repository => 'git://github.com/ivanwills/git-workflow-tools.git',
            bugtracker => 'https://github.com/ivanwills/git-workflow-tools/issues',
        },
    },
);

$builder->create_build_script();
