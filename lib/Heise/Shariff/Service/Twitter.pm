package Heise::Shariff::Service::Twitter;

use Mojo::Base 'Heise::Shariff::Service';

sub request {
    my ($self, $url) = @_;

    my $twurl = Mojo::URL->new('https://cdn.api.twitter.com/1/urls/count.json');
    $twurl->query->param(url => $url);

    return [get => $twurl];
}

sub extract_count {
    my ($self, $res) = @_;
    return $res->json->{count};
}

sub get_name {
    return 'twitter';
}

1;
