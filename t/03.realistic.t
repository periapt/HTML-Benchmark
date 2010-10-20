use Test::More tests => 19;
use Test::Deep;
use strict;
use warnings;
use Carp;
use Test::TCP;
use CGI;

test_tcp(
    server => sub {
        my $port = shift;
        use HTTP::Daemon::File;
        my $daemon = HTTP::Daemon::File->new(
            LocalPort=>$port,
            DefaultFile=>'periapt.html',
            DocumentRoot=>'t/htdocs',
            FileNotFound=>'file-not-found.html',
        );
        $daemon->run;
    },
    client => sub {
        my $port = shift;
        my $url = "http://localhost:$port";
        use HTML::Benchmark;
        my $ua = HTML::Benchmark->new;
        isa_ok($ua, 'HTML::Benchmark');
        $ua->benchmark($url);
        my $statistics = $ua->statistics;
        my @raw_data = $statistics->get_raw_data;
        cmp_deeply(
            \@raw_data,
            [
                {
                    website=>$url,
                    path=>'',
                    item=>ignore(),
                    date=>ignore(),
                    label=>'TEST',
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                    type=>'text/html',
                    size=>ignore(),
                },
                {
                    website=>$url,
                    path=>'',
                    item=>ignore(),
                    #item=>'/',
                    date=>ignore(),
                    label=>'TEST',
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                },
                {
                    website=>$url,
                    path=>'',
                    item=>ignore(),
                    #item=>'/',
                    date=>ignore(),
                    label=>'TEST',
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                },
                {
                    website=>$url,
                    path=>'',
                    item=>ignore(),
                    #item=>'/',
                    date=>ignore(),
                    label=>'TEST',
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                },
                {
                    website=>$url,
                    path=>'',
                    item=>ignore(),
                    #item=>'/',
                    date=>ignore(),
                    label=>'TEST',
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                },
            ],
            'first iteration'
        );
        my $raw_datum = $raw_data[0];
        is($raw_datum->{path}, '/', 'item');
        is($raw_datum->{item}, '/', 'path');
        is($raw_datum->{website}.'/', $url, 'website');
        ok($raw_datum->{download_time} < 1, 'download_time');
        is($raw_datum->{status}, 200, 'status');
        is($raw_datum->{succeeded}, 1, 'succeeded');
        is($raw_datum->{type}, 'text/html', 'type');
        is($raw_datum->{size}, 2273, 'size');
        $ua->benchmark($url);
        $statistics = $ua->statistics;
        @raw_data = $statistics->get_raw_data;
        is(scalar(@raw_data), 10, 'two datum');
        $raw_datum = $raw_data[0];
        is($raw_datum->{path}, '/', 'item');
        is($raw_datum->{item}, '/', 'path');
        is($raw_datum->{website}.'/', $url, 'website');
        ok($raw_datum->{download_time} < 1, 'download_time');
        is($raw_datum->{status}, 200, 'status');
        is($raw_datum->{succeeded}, 1, 'succeeded');
        is($raw_datum->{type}, 'text/html', 'type');
        is($raw_datum->{size}, 2273, 'size');
    }
);

sub check_download_time {
    my $got_v = shift;
    return 1 if $got_v < 1;
    return (0, "$got_v is a long time");
}

