package Heise::Shariff::Service::Facebook;

use Mojo::Base 'Heise::Shariff::Service';

sub request {
    my ($self, $url) = @_;

    my $furl = Mojo::URL->new('https://api.facebook.com/method/fql.query');
    $furl->query->param(format => 'json');
    my $query = qq{select share_count from link_stat where url="$url"};
    $furl->query->param(query => $query);

    return [get => $furl];
}

sub extract_count {
    my ($self, $res) = @_;
    return $res->json->[0]->{share_count};
}

sub get_name {
    return 'facebook';
}

1;
