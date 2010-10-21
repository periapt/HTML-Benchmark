use Test::More tests => 3;
use Test::Deep;
use strict;
use warnings;
use Carp;
use Test::TCP;
use CGI;
use Readonly;
use DateTime;
use DateTime::Duration;

Readonly my $LABEL => $0;
Readonly my $MAX_INTERVAL => DateTime::Duration->new(minutes=>1);

my $reference_run_uuid = undef;
my $reference_date = undef;

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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
        reset_reference_data();
        $ua->benchmark($url);
        $statistics = $ua->statistics;
        @raw_data = $statistics->get_raw_data;
        cmp_deeply(
            \@raw_data,
            [
                {
                    website=>$url,
                    path=>'',
                    item=>'',
                    date=>code(\&check_date),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                    type=>'text/html',
                    size=>2273,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/css/periapt.css',
                    date=>code(\&check_date),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                    type=>'text/css',
                    size=>3145,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/js/amulets.js',
                    date=>code(\&check_date),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                    type=>'application/javascript',
                    size=>720,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/js/periapt.js',
                    date=>code(\&check_date),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                    type=>'application/javascript',
                    size=>3149,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'/img/portfolio/mban303h.jpg',
                    date=>code(\&check_date),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>ignore(),
                    download_time=>code(\&check_download_time),
                    type=>'image/jpeg',
                    size=>297017,
                },
                {
                    website=>$url,
                    path=>'',
                    item=>'',
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
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
                    date=>code(\&check_date),
                    label=>$LABEL,
                    status=>200,
                    succeeded=>1,
                    run_uuid=>code(\&check_run_uuid),
                    download_time=>code(\&check_download_time),
                    type=>'image/jpeg',
                    size=>297017,
                },
            ],
            'second iteration'
        );
        reset_reference_data();
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
        
sub check_date {
    my $got_v = shift;
    if (defined $reference_date) {
        return (0, 'confused dates')
            if $got_v < $reference_date;
        return 1 if
            DateTime::Duration->compare($got_v-$reference_date, $MAX_INTERVAL);
        return (0, "dates too far apart");
    }
    $reference_date = $got_v;
    return 1;
}
 
sub reset_reference_data {
    $reference_run_uuid = undef;
    $reference_date = undef;
}

