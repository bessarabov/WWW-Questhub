package WWW::Questhub::Util;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

use Carp;

my $true = 1;
my $false = '';

sub __value_is_defined_and_has_length {
    my ($value) = @_;

    return $false if not defined $value;
    return $false if $value eq '';
    return $false if ref $value;

    return $true;
}

sub __in_array {
    my ($value, @array) = @_;

    croak "value should be defined" if not __value_is_defined_and_has_length($value);

    my %a = map { $_ => 1 } @array;

    if(exists($a{$value})) {
        return $true;
    } else {
        return $false;
    }

}

1;
