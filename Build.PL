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
        'Test::TCP' => 0,
    },
    script_files=>      [
        'bin/html_benchmark',
    ],
    requires => {
#        'Format::Human::Bytes'=>0,
        'Class::XSAccessor' => 0,
        'DateTime' =>0,
        'File::HomeDir'=>0,
        'Getopt::Euclid' => 0,
        'HTML::Parser'=>'3',
        'MIME::Base64' => 0,
        'Params::Validate'=>0,
        'Perl6::Form' => 0,
        'Perl6::Slurp' => 0,
        'Readonly' => 0,
        'Statistics::Descriptive' => 0,
        'Time::HiRes' => 0,
        'version'    => 0,
        'XML::LibXML' => 0,
        #  URI stuff here
        'URI'=>0,
        'URI::Split'=>0,
        # libwww-perl stuff here
        'HTTP::Daemon' => 0,
        'LWP::UserAgent' => 0,
        'HTTP::Response' => 0,
    },
    create_readme => 1,
    create_makefile_pl => 'traditional',
    add_to_cleanup      => [ 'HTML-Benchmark-*' ],
);

$builder->create_build_script();
