use Mojo::Base -strict;

use Heise::Shariff::Backend;
use Heise::Shariff::Service::GooglePlus;
use Test::More;

my $url = 'http://www.heise.de';

ok my $backend = Heise::Shariff::Backend->new;
ok my $tx = $backend->tx(Heise::Shariff::Service::GooglePlus->new, $url);
is uc $tx->req->method => 'POST';
like $tx->req->url => qr{clients6\.google\.com};

done_testing;
