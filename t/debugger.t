#!perl

use strict;
use warnings;

use Test2::V0;
plan tests => 3;

use Test::MockObject;

# ask for generated anonymous sub names with this debugger variable
BEGIN { $^P |= 0x200 }

my $mock = Test::MockObject->new();

package Some::Parent;

BEGIN
{
	for my $name (qw( isa can ))
	{
		my $sub = sub
		{
			my $caller = ( caller( 1 ) )[ 3 ];
			::is( $caller, "Test::MockObject::$name",
				"generated $name() should have correct name under debugger" );
		};

		no strict 'refs';
		*{ $name } = $sub;
	}
}

package main;

local @Test::MockObject::ISA;
@Test::MockObject::ISA = 'Some::Parent';

my $tmo = Test::MockObject->new();
$tmo->isa( 'foo' );
$tmo->can( 'bar' );

ok( $^P & 0x200, 'T::MO should not permanently reset $^P' );
