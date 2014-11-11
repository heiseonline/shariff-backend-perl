use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Heise::Shariff');

my $response = $t->get_ok('/?url=http://www.heise.de/')
  ->status_is(200, 'Statistik als JSON abfragen')
  ->content_type_is('application/json')
  ->json_like('/twitter'  => qr/^[1-9]\d*$/)
  ->json_like('/facebook' => qr/^[1-9]\d*$/)
  ->json_like('/gplus'    => qr/^[1-9]\d*$/);

done_testing();
