use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HTML::Benchmark',
    license             => 'artistic_2',
    dist_author         => 'Nicholas Bamber <nicholas@periapt.co.uk>',
    dist_version_from   => 'lib/HTML/Benchmark.pm',
    build_requires => {
        'Test::More' => 0,
    },
    script_files=>      [
        'html_benchmark',
    ],
    requires => {
        'version'    => 0,
        'Class::XSAccessor' => 0,
        'Getopt::Euclid' => 0,
    },
    create_readme => 1,
    create_makefile_pl => 'traditional',
    add_to_cleanup      => [ 'HTML-Benchmark-*' ],
);

$builder->create_build_script();
