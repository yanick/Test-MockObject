#!/usr/bin/perl

use strict;
use warnings;

use Test::MockObject;
my $package = 'Test::MockObject';

use Test2::V0;

plan tests => 5;

my $mock = $package->new();
$mock->set_true( -somesub => 'anothersub' );

ok( $mock->somesub(), 'mocking a method with a leading dash should work' );
ok( $mock->anothersub(), '... not preventing subsequent mocks' );

is( $mock->next_call(), 'anothersub',
	'... but should prevent logging of endashed sub calls' );

$mock->set_false( 'somesub' );
ok( ! $mock->somesub(), 'unlogged call should be remockable' );
is( $mock->next_call(), 'somesub', '... and reloggable' );
