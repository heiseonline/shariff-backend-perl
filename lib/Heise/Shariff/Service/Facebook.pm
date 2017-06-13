package Heise::Shariff::Service::Facebook;

use Mojo::Base 'Heise::Shariff::Service';
use Mojo::Util qw(dumper);

sub request {
    my ($self, $url) = @_;

    my $app_id = $self->app->config->{services}->{facebook}->{app_id};
    my $secret = $self->app->config->{services}->{facebook}->{secret};

    unless (defined($app_id) && defined($secret)) {
        return [get => Mojo::URL->new];
    }

    my $furl = Mojo::URL->new('https://graph.facebook.com/v2.8/');
    $furl->query->param(access_token => $app_id.'|'.$secret);
    $furl->query->param(id => $url);

    return [get => $furl];
}

sub extract_count {
    my ($self, $res) = @_;

    my $json = $res->json;

    $self->app->log->debug( dumper($json));

    return undef unless $json;

    if (ref $json eq 'ARRAY' && ref($json->[0]) eq 'HASH' && exists $json->[0]->{share_count}) {
        return $json->[0]->{share_count};
    }
    if (ref $json eq 'HASH' && ref($json->{share}) eq 'HASH' && defined($json->{share}->{share_count})) {
        return $json->{share}->{share_count};
    }
    return undef;
}

sub get_name {
    return 'facebook';
}

1;
