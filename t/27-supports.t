#!perl

use Test::More tests => 6;
use Test::Exception;

use strict;
use warnings;

use JS;

is(JS->supports("threading"), JS->does_support_threading, "Checking support 'threading'");
is(JS->supports("utf8"), JS->does_support_utf8, "Checking support 'utf8'");
is(JS->supports("e4x"), JS->does_support_e4x, "Checking support 'e4x'");
is(JS->supports("E4X"), JS->supports("e4X"), "Checking ignoring case");
is(JS->supports("threading", "utf8", "e4x"),
    JS->does_support_threading && 
    JS->does_support_utf8 &&
    JS->does_support_e4x,
    "Checking support for multiple");

throws_ok {
    JS->supports("non existent feature");
} qr/I don't know about/;
