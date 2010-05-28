#!perl

package Foo;

use Test::More tests => 2;

use strict;
use warnings;

use JS;

my $runtime = new JS::Runtime();
my $context = $runtime->create_context();

ok( my $s = eval { $context->eval(q!
    s = new String("foo");
    s['bar'] = 1;
    s
!) } );

ok(!$@, "didn't die");
