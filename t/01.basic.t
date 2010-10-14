use Test::More tests => 2;
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
    isa_ok($ua, 'LWP::UserAgent');
    my $response = $ua->get($url);
    isa_ok($response, 'HTTP::Response');
    if ($response->is_success) {
        print $response->decoded_content;
    }
    else {
        print $response->status_line;
    }
    kill SIGINT, $pid;
    waitpid($pid,0);
}
else {
    croak $!;
}

