use Test::More tests => 19;
use strict;
use warnings;
use Carp;
use POSIX qw(SIGINT);
use Tie::ShareLite qw(:lock);
use CGI;

my %shared;
my $ipc = tie %shared, 'Tie::ShareLite',
    -key => $$, -mode=> 0600, -create => 'yes', -destroy=>'yes'
    or croak "could not tie to shared memory";

my $pid = fork();
if ($pid == 0) {
    use HTTP::Daemon;
    my $daemon = HTTP::Daemon->new();
    $ipc->lock(LOCK_EX);
    $shared{url} = $daemon->url;
    $ipc->unlock;
    while(my $conn = $daemon->accept) {
        while(my $request = $conn->get_request) {
           my $html = CGI->start_html;
           $html .= CGI->h1($request->uri);
           $html .= CGI->end_html;
           my $response = HTTP::Response->new(200, 'hello', ['Content-Type'=>'text/html'], $html);
           $conn->send_response($response);
        }
        $conn->close;
    }
}
elsif ($pid) {
    use HTML::Benchmark;
    my $ua = HTML::Benchmark->new;
    my $url = undef;
    while(not exists $shared{url}) {
        sleep 1;
    }
    $url = $shared{url};
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
    kill SIGINT, $pid;
    waitpid($pid,0);
}
else {
    croak $!;
}

