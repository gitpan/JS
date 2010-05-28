package JS::Runtime;
use strict;
use warnings;

require JS::Context;
require JS::Error;
require JS::Function;
require JS::Array;
require JS::Controller;

our @ISA = qw(JS::RawRT);

our $MAXBYTES = 1024 ** 2 * 4;

sub new {
    my $pkg = shift;
    bless JS::RawRT::create(shift || $MAXBYTES);
}

sub create_context {
    my $self = shift;
    JS::Context->new($self);
}

my $stock_ctx;
sub JS::stock_context {
    my($pkg, $stock) = @_;
    my $clone;
    if(!defined $stock_ctx) {
	my $rt = __PACKAGE__->new();
	$clone = $stock_ctx = $rt->create_context();
	require JS::Runtime::Stock;
	JS::Runtime::Stock::_ctxcreate($clone);
	Scalar::Util::weaken($stock_ctx);
    } else {
	$clone = $stock_ctx;
    }
    return $clone;
}

1;

__END__

=head1 NAME

JS::Runtime - Runs contexts

=head1 SYNOPSIS

    use JS;

    my $rt = JS::Runtime->new();
    my $ctx = $rt->create_context();

    # BTW, if you don't need the runtime, it is always easier to just:

    use JS;

    my $ctx = JS::stock_context();

=head1 DESCRIPTION

In SpiderMonkey, a I<runtime> is the data structure that holds javascript
variables, objects, script and contexts. Every application needs to have
a runtime. This class encapsulates the SpiderMonkey runtime object.

The main use of a runtime in JS is to create I<contexts>, i.e. L<JS::Context>
instances.

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new ( [ $maxbytes] )

Creates a new C<JS::Runtime> object and returns it.

If the I<$maxbytes> option is given, it's taken to be the number of bytes that
can be allocated before garbage collection is run. If ommited defaults to 4MB.

=back

=head2 INSTANCE METHODS

=over 4

=item create_context ()

Creates a new C<JS::Context> object in the runtime. 

=cut
