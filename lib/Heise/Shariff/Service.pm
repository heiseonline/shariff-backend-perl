package Heise::Shariff::Service;

use Mojo::Base -base;

use Mojo::URL;

has 'app';

has url => sub {};

sub request {
    die 'not implemented';
}

sub extract_count {
    die 'not implemented';
}

sub get_name {
    die 'not implemented';
}

1;
