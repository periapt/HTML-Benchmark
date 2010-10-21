use Test::More tests => 19;
use Test::Deep;
use strict;
use warnings;
use Carp;
use Test::TCP;
use CGI;
use Readonly;

Readonly my $LABEL => $0;

my $reference_run_uuid = undef;

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
        $ua->label($LABEL);
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
                    item=>'',
                    date=>ignore(),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>code(\&check_run_uuid),
                    download_time=>code(\&check_download_time),
                    type=>'text/html',
                    size=>2273,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/css/periapt.css',
                    date=>ignore(),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>code(\&check_run_uuid),
                    download_time=>code(\&check_download_time),
                    type=>'text/css',
                    size=>3145,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/js/amulets.js',
                    date=>ignore(),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>code(\&check_run_uuid),
                    download_time=>code(\&check_download_time),
                    type=>'application/javascript',
                    size=>720,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/js/periapt.js',
                    date=>ignore(),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>code(\&check_run_uuid),
                    download_time=>code(\&check_download_time),
                    type=>'application/javascript',
                    size=>3149,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/img/portfolio/mban303h.jpg',
                    date=>ignore(),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>code(\&check_run_uuid),
                    download_time=>code(\&check_download_time),
                    type=>'image/jpeg',
                    size=>297017,
                },
            ],
            'first iteration'
        );
        $reference_run_uuid = undef;
        $ua->benchmark($url);
        $statistics = $ua->statistics;
        @raw_data = $statistics->get_raw_data;
        is(scalar(@raw_data), 10, 'two datum');
        my $raw_datum = $raw_data[0];
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

sub check_run_uuid {
    my $got_v = shift;
    if (defined $reference_run_uuid) {
        return 1 if $got_v eq $reference_run_uuid;
        return (0, "$got_v ne $reference_run_uuid");
    }
    if ($got_v =~ m{\A[A-Za-z0-9\+/\=]+\s*\z}xms) {
        $reference_run_uuid = $got_v;
        return 1;
    }
    return (0, "$got_v not base64");
}
        
        
