package Heise::Shariff;
use Mojo::Base 'Mojolicious';

use Mojo::Loader;

our $VERSION  = '1.02';

has service_namespaces => sub {['Heise::Shariff::Service']};

sub startup {
    my $self = shift;

    $self->plugin('Config');

    $self->helper(services => sub {
        my @services;
        my $loader = Mojo::Loader->new;
        for my $ns (@{$self->service_namespaces}) {
            for my $module (@{$loader->search($ns)}) {
                my $e = $loader->load($module);
                warn qq{Loading "$module" failed: $e} and next if ref $e;
                push @services, $module->new;
            }
        }
        return \@services;
    });

    $self->helper(get_counts => sub {
        my ($c, $url) = @_;

        my @services = @{$c->services};

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
                    $counts{ $service->get_name } =
                      $service->extract_count($transactions[$i]->res)
                }

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

        return $c->get_counts($validation->param('url'));
    });
}

1;
