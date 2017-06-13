package Heise::Shariff;
use Mojo::Base 'Mojolicious';

use Heise::Shariff::Cache;
use Mojo::Date;
use Mojo::Loader qw(load_class find_modules);

our $VERSION  = '4.0';

has service_namespaces => sub {['Heise::Shariff::Service']};

sub startup {
    my $self = shift;

    $self->plugin('Config');

    $self->helper(cache => sub {
        my $config = shift->config->{cache};
        my $class = $config->{class} // 'Heise::Shariff::Cache';
        my $e = load_class($class);
        die qq{Loading "$class" failed} if $e;
        state $cache = $class->new(@{$config->{options} // []});
    });

    $self->helper(services => sub {
        my @services;
        for my $ns (@{$self->service_namespaces}) {
            for my $module (find_modules($ns)) {
                my $e = load_class($module);
                warn qq{Loading "$module" failed: $e} and next if ref $e;
                push @services, $module->new(app => $self->app);
            }
        }
        return \@services;
    });

    $self->helper(get_counts => sub {
        my ($c, $url) = @_;

        if (my $data = $c->cache->get($url)) {
            return $c->is_fresh(last_modified => $data->{mtime})
              ? $c->rendered(304)
              : $c->render(json => $data->{counts});
        }

        my @services = @{$c->services};

        $c->app->log->debug('sending concurrent requests ...');

        $c->delay(
            sub {
                my $delay = shift;
                for my $service (@services) {
                    my $request = $service->request($url);
                    $c->ua->start(
                        $c->ua->build_tx(@{$service->request($url)}),
                        $delay->begin
                    );
                }
            },
            sub {
                my ($delay, @transactions) = @_;

                my %counts;

                for (my $i = 0; $i < @transactions; $i++) {
                    # warn dumper $transactions[$i]->res;
                    my $service = $services[$i];

                    if (defined(my $value = $service->extract_count($transactions[$i]->res))) {
                        $counts{ $service->get_name } = $value + 0;
                    }
                }

                my $mtime = time;
                $c->cache->set(
                    $url,
                    {
                        counts => \%counts,
                        mtime  => $mtime,
                    },
                    $c->config->{cache}->{expires}
                );
                $c->res->headers->last_modified(Mojo::Date->new($mtime));
                $c->render(json => \%counts);
            }
        );
    });

    $self->validation->validator->add_check(matches_domain => sub {
        my ( $validation, $name, $value, $domain ) = @_;
        return Mojo::URL->new($value)->host !~ $domain;
    });

    my $r = $self->routes;

    $r->get('/' => sub {
        my $c = shift;
        my $validation = $c->validation;

        $validation->required("url")->matches_domain($c->config->{domain});

        return $c->render(json => {error => "invalid url"}, status => 400)
          if $validation->has_error;

        $c->res->headers->cache_control('public, max-age=60');
        $c->get_counts($validation->param('url'));
    });
}

1;
