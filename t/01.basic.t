use Test::More tests => 3;
use Test::SharedFork;
use strict;
use warnings;
use Carp;
use Readonly;
use POSIX qw(SIGINT);

Readonly my $PORT => 8888;

my $pid = fork();
if ($pid == 0) {
    use HTTP::Daemon;
    my $daemon = HTTP::Daemon->new(LocalPort => $PORT);
    isa_ok($daemon, 'HTTP::Daemon');
    while(my $conn = $daemon->accept) {
        $conn->close;
    }
}
elsif ($pid) {
    use LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    isa_ok($ua, 'LWP::UserAgent');
    my $response = $ua->get("http://localhost:$PORT");
    isa_ok($response, 'HTTP::Response');
    if ($response->is_success) {
        print $response->decoded_content;
    }
    else {
        print $response->status_line;
    }
    kill SIGINT, $pid;
}
else {
    croak $!;
}

