use Test::More tests => 4;

BEGIN {
use_ok( 'HTML::Benchmark' );
use_ok( 'HTML::Benchmark::Statistics' );
use_ok( 'HTML::Benchmark::Output::Form' );
use_ok( 'HTTP::Daemon::File' );
}

diag( "Testing HTML::Benchmark $HTML::Benchmark::VERSION" );
