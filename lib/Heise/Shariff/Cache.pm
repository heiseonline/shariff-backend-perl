package Heise::Shariff::Cache;

use Mojo::Base 'Mojo::Cache';

has expires => sub { 60 };

sub get {
    my ($self, $key) = @_;

    return unless (my $data = $self->SUPER::get($key));

    if ($data->{expires} >= time) {
        return $data->{val};
    }

    return;
}

sub set {
    my $self = shift;
    my ($key, $value, $expires) = @_;

    $expires //= $self->expires;

    return $self->SUPER::set($key, {
        expires => time + $expires,
        val     => $value,
    });
}

1;
