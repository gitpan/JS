#!/usr/bin/perl

use JavaScript;

my $rt = JavaScript::Runtime->new();
my $cx = $rt->create_context();
$cx->{RaiseExceptions} = 0;
$cx->eval( "foo } bar {" );
warn $@;

