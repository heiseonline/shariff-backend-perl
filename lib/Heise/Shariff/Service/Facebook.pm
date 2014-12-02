package Heise::Shariff::Service::Facebook;

use Mojo::Base 'Heise::Shariff::Service';
use Mojo::Util qw(dumper);

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

    if (ref $res->json eq 'ARRAY') {
        return $res->json->[0]->{share_count};
    } else {
        warn dumper($res);
        return 0;
    }
}

sub get_name {
    return 'facebook';
}

1;
