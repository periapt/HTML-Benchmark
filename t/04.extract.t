use Test::More tests => 1;
use strict;
use warnings;
use Carp;
use HTML::Benchmark::Parser;
use Perl6::Slurp;

my $html = slurp 't/htdocs/periapt.html';
my $parser = HTML::Benchmark::Parser->new;
isa_ok($parser, 'HTML::Parser');
