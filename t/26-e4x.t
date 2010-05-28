#!perl

use Test::More tests => 5;

use strict;
use warnings;

use JS;

my $runtime = new JS::Runtime();
my $context = $runtime->create_context();

my $ret = $context->eval(q| <xml>this is an E4X object</xml> |);

isa_ok($ret, 'JS::XMLObject');
is($ret->toXMLString, '<xml>this is an E4X object</xml>', "Methods works");
is("$ret",'<xml>this is an E4X object</xml>', "Stringify");
$ret = $context->eval(q|(<xml attr="foo">this is an E4X object</xml>).@attr;|);
isa_ok($ret, 'JS::XMLObject');
is("$ret", 'foo', "Can get \@attr");
