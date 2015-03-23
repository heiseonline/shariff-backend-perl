package Heise::Shariff::Service::Facebook;

use Mojo::Base 'Heise::Shariff::Service';
use Mojo::Util qw(dumper);

sub request {
    my ($self, $url) = @_;

    my $app_id = $self->app->config->{services}->{facebook}->{app_id};
    my $secret = $self->app->config->{services}->{facebook}->{secret};

    my $furl = q();
    if ($app_id && $secret) {
        $furl = Mojo::URL->new('https://graph.facebook.com/v2.2/');
        $furl->query->param(access_token => $app_id.'|'.$secret);
        $furl->query->param(id => $url);
    } else {
        $furl = Mojo::URL->new('https://api.facebook.com/method/fql.query');
        $furl->query->param(format => 'json');
        my $query = qq{select share_count from link_stat where url="$url"};
        $furl->query->param(query => $query);
    }
    return [get => $furl];
}

sub extract_count {
    my ($self, $res) = @_;

    $self->app->log->debug( dumper($res->json));
    if (ref $res->json eq 'ARRAY' && exists $res->json->[0]->{share_count}) {
        return $res->json->[0]->{share_count};
    }
    if (exists $res->json->{share} && defined($res->json->{share}->{share_count})) {
        return $res->json->{share}->{share_count};
    }
    return undef;
}

sub get_name {
    return 'facebook';
}

1;
