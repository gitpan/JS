#!perl

use Test::More tests => 11;

use strict;
use warnings;

use JS;

# Create a new runtime
my $rt1 = JS::Runtime->new();
my $cx1 = $rt1->create_context();

# Compile a script
my $script = $cx1->compile(q!
v = Math.random(10);
v + 1;
!);

isa_ok($script, "JS::Script", "Compile returns object");
for(1..10) {
    ok($script->exec() > 0, "Ok pass $_");
}
