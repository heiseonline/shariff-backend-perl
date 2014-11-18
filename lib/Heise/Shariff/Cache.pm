package Heise::Shariff::Cache;

use Mojo::Base 'Mojo::Cache';

has expires => sub { 60 };

sub get_mtime {
    my ($self, $key) = @_;

    return unless (my $data = $self->SUPER::get($key));

    return $data->{mtime};
}

sub get {
    my ($self, $key) = @_;

    return unless (my $data = $self->SUPER::get($key));

    if ($data->{mtime} + $self->expires >= time) {
        return $data->{val};
    }

    return undef;
}

sub set {
    my ($self, $key, $value) = @_;
    my $mtime = time;
    $self->SUPER::set($key, {
        mtime => $mtime,
        val   => $value,
    });
    return $mtime;
}

1;
