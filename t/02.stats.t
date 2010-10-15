use Test::More tests => 18;
use strict;
use warnings;
use Carp;
use HTML::Benchmark::Statistics;
use Test::NoWarnings;
use Readonly;
use DateTime;

Readonly my $WEBSITE => 'http://www.test.org';
Readonly my $RUN_UUID_A => 'ipehpfhihf'; 
Readonly my $LABEL => 'piqeppiqhphiqjeqf';

my $stats = HTML::Benchmark::Statistics->new;
isa_ok($stats, 'HTML::Benchmark::Statistics');

my @raw_data = $stats->get_raw_data;
is_deeply( \@raw_data, [], 'no data');

my @combined_data = $stats->get_combined_data;
is_deeply( \@combined_data, [], 'no data');

my @statistics = $stats->get_statistics;
is_deeply( \@statistics, [], 'no data');
    
$stats->add_data(
    website=>$WEBSITE,
    path=>'/',
    item=>'/',
    type=>'text/plain',
    status=>200,
    succeeded=>1,
    size=>10000,
    download_time=>0.331131,
    run_uuid=>$RUN_UUID_A,
    label=>$LABEL,
    date=>DateTime->new(year=>'1977'),
);
@raw_data = $stats->get_raw_data;
is_deeply( \@raw_data, [{
    website=>$WEBSITE,
    path=>'/',
    item=>'/',
    type=>'text/plain',
    status=>200,
    succeeded=>1,
    size=>10000,
    download_time=>0.331131,
    run_uuid=>$RUN_UUID_A,
    label=>$LABEL,
    date=>DateTime->new(year=>'1977'),
}], 'one datum');
@combined_data = $stats->get_combined_data;
is_deeply( \@combined_data, [{
    website=>$WEBSITE,
    path=>'/',
    size=>10000,
    download_time=>0.331131,
    run_uuid=>$RUN_UUID_A,
    label=>$LABEL,
    min_date=>DateTime->new(year=>'1977'),
    max_date=>DateTime->new(year=>'1977'),
}], 'one datum');
@statistics = $stats->get_statistics;
is(scalar(@statistics), 1, 'one dataum');
my $results = $statistics[0];
my $size = delete $results->{size};
is($size->mean, 10000, 'one datum size');
is($size->variance, 0, 'one datum size');
my $download = delete $results->{download_time};
is($download->mean, 0.331131, 'one datum download');
is($download->variance, 0, 'one datum download');
is_deeply($results, {
    website=>$WEBSITE,
    path=>'/',
    label=>$LABEL,
    min_date=>DateTime->new(year=>'1977'),
    max_date=>DateTime->new(year=>'1977'),
}, 'one datum results');

is(HTML::Benchmark::Statistics::_compile_key({
    ihpq=>'ougwou',
    qwdhq=>'pqhihfqf',
    uqhwehdq=>'wquoqhd',
    uqowd=>'pqihdip',
    quodhqo=>'hqphdpq',
}, ['qwdhq','ihpq']), 'pqhihfqf|ougwou|', 'key generation');
is(HTML::Benchmark::Statistics::_min_date(
    DateTime->new(year=>1999), DateTime->new(year=>2000))->year, 1999, 'year 1999');
is(HTML::Benchmark::Statistics::_min_date(
    DateTime->new(year=>1999), DateTime->new(year=>1998))->year, 1998, 'year 1998');
is(HTML::Benchmark::Statistics::_max_date(
    DateTime->new(year=>1999), DateTime->new(year=>2000))->year, 2000, 'year 2000');
is(HTML::Benchmark::Statistics::_max_date(
    DateTime->new(year=>1999), DateTime->new(year=>1998))->year, 1999, 'year 1999');

