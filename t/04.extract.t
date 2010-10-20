use Test::More tests => 7;
use strict;
use warnings;
use Carp;
use HTML::Benchmark::Parser;
use Perl6::Slurp;

my $html = slurp 't/htdocs/periapt.html';
my $parser = HTML::Benchmark::Parser->new;
isa_ok($parser, 'HTML::Parser');

my ($css, $js, $img) = $parser->extract_data($html);
is(ref $css, 'ARRAY');
is_deeply($css, ['/css/periapt.css']);
is(ref $js, 'ARRAY');
is_deeply($js, ['/js/amulets.js', '/js/periapt.js']);
is(ref $img, 'ARRAY');
is_deeply($img, ['/img/portfolio/mban303h.jpg']);

