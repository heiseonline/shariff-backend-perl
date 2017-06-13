use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Heise::Shariff');

my $response = $t->get_ok('/?url=http://www.heise.de/')
  ->status_is(200, 'Statistik als JSON abfragen')
  ->content_type_is('application/json;charset=UTF-8')
  ->header_is('Cache-Control' => 'public, max-age=60')
  ->header_like('Last-Modified' => qr/GMT/)
  ->json_like('/googleplus'    => qr/^[1-9]\d*$/);

if ($t->app->config->{services}->{facebook}->{app_id}) {
  $response->json_like('/facebook' => qr/^[1-9]\d*$/);
}

done_testing();
