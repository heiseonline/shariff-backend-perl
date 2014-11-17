use Mojo::Base -strict;

use Heise::Shariff::Cache;
use Test::More;
use Test::Mojo;

my $cache = Heise::Shariff::Cache->new;
is $cache->get('foo') => undef;
ok $cache->set(foo => 'bar');
is $cache->get('foo') => 'bar';

$cache = Heise::Shariff::Cache->new(expires => 1);
ok $cache->set(foo => 'bar');
is $cache->get('foo') => 'bar', 'Still cached';
sleep(2);
is $cache->get('foo') => undef, 'Cache expired';

done_testing;
