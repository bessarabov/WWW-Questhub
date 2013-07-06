package WWW::Questhub::Script;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;
use Term::ANSIColor qw(colored);

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
    my ($self, @options) = @_;

    my @unknown_options;
    my $option_user;
    my $option_status;

    foreach my $option (@options) {
        if ($option =~ /^--owner=(.*)$/) {
            $option_user = $1;
        } elsif ($option =~ /^--status=(.*)$/)  {
            $option_status = $1;
            my $status_is_known = WWW::Questhub::Util::__in_array(
                $option_status,
                WWW::Questhub::Util::__get_known_quest_states(),
            );
            if (not $status_is_known) {
                print "Error. Got unknown status value '$option_status'\n";
                exit 1;
            };
        } else {
            push @unknown_options, $option;
        }
    }

    if (@unknown_options) {
        print "Error. `qh list` got unknown option: '"
            . join("', '", @unknown_options)
            . "'.\n";
        exit 1;
    }

    my $wq = WWW::Questhub->new();

    my @quests = $wq->get_quests(
        ( defined $option_user ? ( user => $option_user ) : () ),
        ( defined $option_status ? ( status => $option_status ) : () ),
    );

    foreach my $quest (@quests) {

        my $tags = '';
        foreach my $tag ($quest->get_tags()) {
            $tags .= colored($tag, 'magenta') . ", ";
        }
        $tags = substr($tags, 0, length($tags) - 2);
        $tags .= " " if length($tags) > 0;

        print colored($quest->get_id(), 'yellow')
            . " "
            . colored($quest->get_status(), 'blue')
            . " "
            . $tags
            . $quest->get_name()
            . "\n"
            ;
    }
}

1;
