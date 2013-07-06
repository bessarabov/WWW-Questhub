package WWW::Questhub::Script;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;

use WWW::Questhub;
use WWW::Questhub::Util;

my $true = 1;
my $false = '';

sub __new {
    my ($class, %opts) = @_;

    croak "__new() shoud not recieve any options. Stopped" if %opts;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub __is_known_command {
    my ($self, $command) = @_;

    my @known_commands = qw(
        list
    );

    if (WWW::Questhub::Util::__in_array($command, @known_commands)) {
        return $true;
    } else {
        return $false;
    }

}

sub list {
    my ($self) = @_;

    my $wq = WWW::Questhub->new();

    my @quests = $wq->get_quests();

    foreach my $quest (@quests) {
        print $quest->get_id()
            . " "
            . $quest->get_name()
            . "\n"
            ;
    }
}

1;
