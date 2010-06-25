#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'JS' ) || print "Bail out!
";
}

diag( "Testing JS $JS::VERSION, Perl $], $^X" );
