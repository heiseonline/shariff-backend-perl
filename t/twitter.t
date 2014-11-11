use Mojo::Base -strict;

use Heise::Shariff::Backend;
use Heise::Shariff::Service::Twitter;
use Test::More;

my $url = 'http://www.heise.de';

ok my $backend = Heise::Shariff::Backend->new;
ok my $tx = $backend->tx(Heise::Shariff::Service::Twitter->new, $url);
is uc $tx->req->method => 'GET';
like $tx->req->url => qr{cdn\.api\.twitter\.com};

done_testing;
