package WWW::Questhub::Quest;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;

my $true = 1;
my $false = '';

sub __new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, $class;

    if ($self->__value_is_defined_and_has_length($opts{_id})) {
        $self->{__id} = $opts{_id};
    } else {
        croak "new() expected to recieve _id. Stopped";
    }

    if ($self->__value_is_defined_and_has_length($opts{name})) {
        $self->{__name} = $opts{name};
    } else {
        croak "new() expected to recieve name. Stopped";
    }

    if (ref $opts{team} eq 'ARRAY') {
        $self->{__owners} = $opts{team};
    } else {
        croak "new() expected to recieve team arrayref. Stopped";
    }

    my @known_states = qw(
        open
        abandoned
        closed
    );

    if ($self->__in_array($opts{status}, @known_states)) {
        $self->{__status} = $opts{status};
    } else {
        croak "new() got unexpected status '" . $opts{status} . "'. Stopped";
    }

    return $self;
}

sub get_id {
    my ($self) = @_;
    return $self->{__id};
}

sub get_name {
    my ($self) = @_;
    return $self->{__name};
}

sub get_status {
    my ($self) = @_;

    return $self->{__status};
}

sub get_owners {
    my ($self) = @_;

    my @owners = @{$self->{__team}};

    return @owners;
}

sub has_one_owner {
    my ($self) = @_;

    my @owners = $self->get_owners();
    if (@owners == 1) {
        return $true;
    } else {
        return $false;
    }
}

sub get_owner {
    my ($self) = @_;

    my @owners = $self->get_owners();

    if (@owners == 1) {

        return $owners[0];

    } else {
        croak "Can't get quest "
            . $self->get_id()
            . " owner. This quest have "
            . scalar(@owners)
            . " owners."
            ;
    }
}


sub __value_is_defined_and_has_length {
    my ($self, $value) = @_;

    return $false if not defined $value;
    return $false if $value eq '';
    return $false if ref $value;

    return $true;
}

sub __in_array {
    my ($self, $value, @array) = @_;

    my %a = map { $_ => 1 } @array;

    if(exists($a{$value})) {
        return $true;
    } else {
        return $false;
    }

}

1;
