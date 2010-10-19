use Test::More tests => 19;
use strict;
use warnings;
use Carp;
use POSIX qw(SIGINT);
use Test::TCP;
use CGI;

test_tcp(
    server => sub {
        my $port = shift;
        use HTTP::Daemon;
        my $daemon = HTTP::Daemon->new(LocalPort=>$port);
        while(my $conn = $daemon->accept) {
            while(my $request = $conn->get_request) {
                my $html = CGI->start_html;
                $html .= CGI->h1($request->uri);
                $html .= CGI->end_html;
                my $response = HTTP::Response->new(
                                             200,
                                             'hello', 
                                             ['Content-Type'=>'text/html'],
                                             $html);
                $conn->send_response($response);
            }
            $conn->close;
        }
    },
    client => sub {
        my $port = shift;
        my $url = "http://localhost:$port/";
        use HTML::Benchmark;
        my $ua = HTML::Benchmark->new;
        isa_ok($ua, 'HTML::Benchmark');
        $ua->benchmark($url);
        my $statistics = $ua->statistics;
        my @raw_data = $statistics->get_raw_data;
        is(scalar(@raw_data), 1, 'one datum');
        my $raw_datum = $raw_data[0];
        is($raw_datum->{path}, '/', 'item');
        is($raw_datum->{item}, '/', 'path');
        is($raw_datum->{website}.'/', $url, 'website');
        ok($raw_datum->{download_time} < 1, 'download_time');
        is($raw_datum->{status}, 200, 'status');
        is($raw_datum->{succeeded}, 1, 'succeeded');
        is($raw_datum->{type}, 'text/html', 'type');
        is($raw_datum->{size}, 318, 'size');
        $ua->benchmark($url);
        $statistics = $ua->statistics;
        @raw_data = $statistics->get_raw_data;
        is(scalar(@raw_data), 2, 'two datum');
        $raw_datum = $raw_data[0];
        is($raw_datum->{path}, '/', 'item');
        is($raw_datum->{item}, '/', 'path');
        is($raw_datum->{website}.'/', $url, 'website');
        ok($raw_datum->{download_time} < 1, 'download_time');
        is($raw_datum->{status}, 200, 'status');
        is($raw_datum->{succeeded}, 1, 'succeeded');
        is($raw_datum->{type}, 'text/html', 'type');
        is($raw_datum->{size}, 318, 'size');
    }
);
