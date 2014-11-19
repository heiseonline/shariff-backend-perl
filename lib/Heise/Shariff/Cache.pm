package Heise::Shariff::Cache;

use Mojo::Base 'Mojo::Cache';

has expires => sub { 60 };

sub get {
    my ($self, $key) = @_;

    return unless (my $data = $self->SUPER::get($key));

    if ($data->{mtime} + $self->expires >= time) {
        return $data->{val};
    }

    return undef;
}

sub set {
    my ($self, $key, $value, $expires) = @_;
    $self->SUPER::set($key, {
        mtime => time,
        val   => $value,
    });
}

1;
