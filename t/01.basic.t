use Test::More tests => 2;
use Test::SharedFork;
use strict;
use warnings;
use Carp;

my $pid = fork();
if ($pid == 0) {
    ok 1, 'child';
}
elsif ($pid) {
    ok 1, 'parent';
}
else {
    croak $!;
}


