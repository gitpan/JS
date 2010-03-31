#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'JS::JS' ) || print "Bail out!
";
}

diag( "Testing JS::JS $JS::JS::VERSION, Perl $], $^X" );
