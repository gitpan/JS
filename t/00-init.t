#!perl
use strict;

use Test::More tests => 7;

BEGIN { use_ok("JS"); }
ok(my $ctx = JS->stock_context, "Can create a context");
ok($ctx->{RaiseExceptions}, "Default flag on");
isa_ok (my $gobj = $ctx->get_global, "JS::Object",  'Can get global');
is($gobj->CLASS_NAME, 'global', "Its the global object");
isa_ok($ctx->get_controller, "JS::Controller",  "Can get controller");
is($ctx->get_controller->CLASS_NAME, 'perl', 'Is a controller');
