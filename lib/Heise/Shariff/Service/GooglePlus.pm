package Heise::Shariff::Service::GooglePlus;

use Mojo::Base 'Heise::Shariff::Service';

sub request {
    my ($self, $url) = @_;

    my $gurl = 'https://clients6.google.com/rpc?key=AIzaSyCKSbrvQasunBoV16zDH9R33D88CeLr9gQ';
    return [post => $gurl => json => {
        method => 'pos.plusones.get',
        id     => 'p',
        params => {
            nolog   => 'true',
            id      => $url,
            source  => 'widget',
            userId  => '@viewer',
            groupId => '@self',
        },
        jsonrpc    => '2.0',
        key        => 'p',
        apiVersion => 'v1',
    }];
}

sub extract_count {
    my ($self, $res) = @_;
    return $res->json->{result}->{metadata}->{globalCounts}->{count};
}

sub get_name {
    return 'gplus';
}

1;
