package JS::TrapHandler;
use strict;
use warnings;

use JS;
JS::_boot_(__PACKAGE__);

sub JS::RawRT::set_interrupt_handler {
    my ($self, $callback, $data) = @_;
    $callback = scalar(caller)->can($callback) if $callback &&  !ref $callback;
    if($callback) {
	croak("Callback not a code ref!") unless ref $callback eq 'CODE';
        $self->add_interrupt_handler(JS::TrapHandler->new($callback, $data));
    } else {
        $self->remove_interrupt_handler();
    }
}

1;

__END__

=head1 NAME

JS::TrapHandler - Add support for Traps Handling to JS

=over 4

=item new ( $code, $data )

Construct a new closure with $code and $data
