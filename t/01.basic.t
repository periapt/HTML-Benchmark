use Test::More tests => 3;
use Test::SharedFork;
use strict;
use warnings;
use Carp;
use POSIX qw(SIGINT);
use Tie::ShareLite qw(:lock);

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
    isa_ok($daemon, 'HTTP::Daemon');
    while(my $conn = $daemon->accept) {
        $conn->close;
    }
}
elsif ($pid) {
    use LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
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
}
else {
    croak $!;
}

