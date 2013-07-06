package WWW::Questhub;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;
use LWP::UserAgent;
use JSON;
use URI;

use WWW::Questhub::Quest;

my $true = 1;
my $false = '';

sub new {
    my ($class, %opts) = @_;

    croak "new() shoud not recieve any options. Stopped" if %opts;

    my $self = {};
    bless $self, $class;

    $self->__set_server('http://questhub.io');

    my $version_text = '';
    eval {
        $version_text = " " . $WWW::Questhub::VERSION;
    };
    $self->__set_agent("WWW::Questhub$version_text");

    return $self;
}

sub get {
    my ($self, $url) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->agent($self->__get_agent());

    my $req = HTTP::Request->new(
        GET => $url,
    );

    my $res = $ua->request($req);

    return $res->content if $res->is_success;
}

sub get_quests {
    my ($self, %opts) = @_;

    my $option_user = delete $opts{user};
    my $option_status = delete $opts{status};

    my @unknown_options = keys %opts;
    if (@unknown_options) {
        croak "get_quests() got unknown option: '"
            . join("', '", @unknown_options)
            . "'. Stopped";
    }

    my $url = URI->new($self->__get_server());
    $url->path('/api/quest');
    $url->query_form(
        ( defined $option_user ? ( user => $option_user ) : () ),
        ( defined $option_status ? ( status => $option_status ) : () ),
    );

    my $json = $self->get( $url->as_string() );
    my $data = from_json($json, { utf8 => 1 });

    my @quests;
    foreach my $element (@{$data}) {
        my $quest = WWW::Questhub::Quest->__new(%{$element});
        push @quests, $quest;
    }

    return @quests;
}

sub __set_server {
    my ($self, $server) = @_;

    croak "__set_server() should recieve server url" if not defined $server;

    $self->{__server} = $server;
    return $false;
}

sub __get_server {
    my ($self) = @_;

    return $self->{__server};
}

sub __set_agent {
    my ($self, $agent) = @_;

    croak "__set_agent() should recieve agent text" if not defined $agent;

    $self->{__agent} = $agent;
    return $false;
}

sub __get_agent {
    my ($self) = @_;

    return $self->{__agent};
}

1;
