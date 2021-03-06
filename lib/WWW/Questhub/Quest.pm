package WWW::Questhub::Quest;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;
use Term::ANSIColor qw(colored);

use WWW::Questhub::Util;

my $true = 1;
my $false = '';

sub __new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, $class;

    if (WWW::Questhub::Util::__value_is_defined_and_has_length($opts{_id})) {
        $self->{__id} = $opts{_id};
    } else {
        croak "new() expected to recieve _id. Stopped";
    }

    if (WWW::Questhub::Util::__value_is_defined_and_has_length($opts{name})) {
        $self->{__name} = $opts{name};
    } else {
        croak "new() expected to recieve name. Stopped";
    }

    if (WWW::Questhub::Util::__value_is_defined_and_has_length($opts{author})) {
        $self->{__author} = $opts{author};
    } else {
        croak "new() expected to recieve author. Stopped";
    }

    if (ref $opts{team} eq 'ARRAY') {
        $self->{__owners} = $opts{team};
    } else {
        croak "new() expected to recieve team arrayref. Stopped";
    }

    if (ref $opts{likes} eq 'ARRAY') {
        $self->{__likes} = $opts{likes};
    } else {
        $self->{__likes} = [];
    }

    if (ref $opts{tags} eq 'ARRAY') {
        $self->{__tags} = $opts{tags};
    } else {
        # Sometimes there is no `tags` key in the quest data
        # https://github.com/berekuk/play-perl/issues/116
        # I think this is a bug, when it will be fixed, I need to delete the
        # next line and to uncomment the other line

        $self->{__tags} = [];

        #croak "new() expected to recieve tags arrayref. Stopped";
    }

    my @known_states = WWW::Questhub::Util::__get_known_quest_states();

    if (WWW::Questhub::Util::__in_array($opts{status}, @known_states)) {
        $self->{__status} = $opts{status};
    } else {
        croak "new() got unexpected status '" . $opts{status} . "'. Stopped";
    }

    return $self;
}

sub print_info {
    my ($self) = @_;

    print "# WWW::Questhub::Quest all known info\n";
    print "id:        " . colored($self->get_id(), 'yellow') . "\n";
    print "name:      " . colored($self->get_name(), 'blue') . "\n";
    print "status:    " . colored($self->get_status(), 'blue') . "\n";
    print "author:    " . $self->get_author() . "\n";

    my @owners = $self->get_owners();

    if (@owners) {
        print "owners:\n";
        foreach (@owners) {
            print " * $_\n";
        }
        print "\n";
    } else {
        print "owners:    " . colored('none', 'blue') . "\n";
    }

    my @tags = $self->get_tags();

    if (@tags) {
        print "tags:\n";
        foreach (@tags) {
            print " * " . colored($_, 'magenta') . "\n";
        }
        print "\n";
    } else {
        print "tags:      " . colored('none', 'blue') . "\n";
    }

    print "\n";

    return $false;
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

sub get_author {
    my ($self) = @_;

    return $self->{__author};
}

sub get_owners {
    my ($self) = @_;

    my @owners = @{$self->{__owners}};

    return @owners;
}

sub get_tags {
    my ($self) = @_;

    my @tags = @{$self->{__tags}};

    return @tags;
}

sub get_likes_count {
    my ($self) = @_;

    my $count = scalar @{$self->{__likes}};

    return $count;
}

1;
