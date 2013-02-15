#!/usr/local/bin/perl -w
package SampleRobot;

use Math::Trig;
use Shot;

$\ = "\n";

sub checkPower {
	my ($self) = @_;
	if ($self->{_power} <= 0){
		return 0;
	}
	return 1;
}

sub move_up {
	my ($self) = @_;
	if ($self->checkPower() != 1 || $self->{_y} <= 0 ){
		return 0;
	}
	$self->{_y}--;
	$self->{_angle} = 0;
	$self->{_power}--;
}

sub move_down {
	my ($self) = @_;
	if ($self->checkPower() != 1){
		return 0;
	}
	$self->{_y} = $self->{_y} + 1;
	$self->{_angle} = 180;
	$self->{_power}--;
}

sub move_right {
	my ($self) = @_;
	if ($self->checkPower() != 1){
		return 0;
	}
	$self->{_x} += 1;
	$self->{_angle} = 270;
	$self->{_power}--;
}

sub move_left {
	my ($self) = @_;
	if ($self->checkPower() != 1){
		return 0;
	}
	$self->{_x}--;
	$self->{_angle} = 90;
	$self->{_power}--;
}

sub move_forward {
my ( $self ) = @_;
	print "$self->{_name} is moving forward...";

	if ( $self->{_y} >= 488 || $self->{_y} <= 24 #bottom/ top of the screen
		|| $self->{_x} <= 24 || $self->{_x} >= 488 #left/ right of the screen
		|| $self->{_power} <= 0 ) {
		return 0;	
	}

	if ( $self->{_angle} == 360 or $self->{_angle} == 0) {
		$self->{_y} -= 1;
	}
	elsif ( $self->{_angle} == 270 or $self->{_angle} == -90 ) {
		$self->{_x} += 1;
	}
	elsif ( $self->{_angle} == 180 or $self->{_angle} == -180 ) {
		$self->{_y} += 1;
	}
	elsif ( $self->{_angle} == 90 or $self->{_angle} == -270) {
		$self->{_x} -= 1;
	}
	elsif ( ( $self->{_angle} >= 271 && $self->{_angle} <= 359)
		|| ($self->{_angle} >= -179 && $self->{_angle} <= -91  ) ) {#first quadrant
		$self->{_x} += 1;
		$self->{_y} += 1;
	}
	elsif ( ( $self->{_angle} >= 181 && $self->{_angle} <= 269)
		|| ( $self->{_angle} >= -89 && $self->{_angle} <= -1 ) ) { #second quadrant
		$self->{_x} += 1;
		$self->{_y} -= 1;
	}
	elsif ( ( $self->{_angle} >= 91 && $self->{_angle} <= 179 )
		|| ( $self->{_angle} => -359 && $self->{_angle} <= -271 ) ) { #third quadrant
		$self->{_x} -= 1;
		$self->{_y} -= 1;
	}
	elsif ( ( $self->{_angle} >= 1 && $self->{_angle} <= 89 ) 
		|| ( $self->{_anlge} >= -269 && $self->{_angle} <= -181 )) { #forth quadrant
		$self->{_x} -= 1;
		$self->{_y} += 1;
	}

	$self->{_power}--;
}

sub checkForEnemy {
	my ($self, $e_x, $e_y) = @_;
	my $x = $self->{_x};
	my $y = $self->{_y};
	my $sin = sin($self->{_angle});
	my $cos = cos($self->{_angle});
	
	while ( $e_x != $x 
		&& $e_y != $y
		&& $x > 0
		&& $x <= 512
		&& $y > 0
		&& $y <= 512 ) {
		$x -= $sin;
		$y -= $cos;
	}
	
	if ( $e_x == $x || $e_y == $y ) {
		print "ENEMY SPOTTED!";
	}	
}

sub turnLeft {
	my ( $self, $turning_angle ) = @_;

	$self->{_angle} += $turning_angle;
}

sub turnRight {
	my ( $self, $turning_angle ) = @_;

	$self->{_angle} -= $turning_angle;
}

sub shoot{
	my ( $self ) = @_;
	if ( $self->{_power} <= 0 ){
		return 0;
	}
	print "$self->{_name} started Shooting...";
	$self->{_shot}->shoot( $self->{_angle}, 1 );
	$self->{_power} -= $self->{_shotPower};
	
	print "$self->{_name} stopped shooting...";
}

sub moveShot{
	my ( $self ) = @_;
	$self->{_shot}->shoot( $self->{_angle}, 10 );
}

sub getShotX{
	my ( $self ) = @_;
	return $self->{_shot}->getX();
}

sub getShotY{
	my ( $self ) = @_;
	return $self->{_shot}->getY();
}

sub getX{
	my( $self ) = @_;
	return $self->{_x};
}

sub getY{
	my( $self ) = @_;
	return $self->{_y};
}

sub getAngle{
	my ( $self ) = @_;
	return $self->{_angle};		
}

sub getPower{
	my ( $self ) = @_;
	return $self->{_power};
}

sub getShotPower{
	my ( $self ) = @_;
	return $self->{_shotPower};
}

sub setShotPower{
	my ( $self, $shotPower ) = @_;
	$self->{_shotPower} = $shotPower if defined( $shotPower );
	return $self->{_shotPower};
}

sub new
{
	my $class = shift;
	my $name = shift;
	my $shot = new Shot( 100, 125 );
	my $self = {
		_x => 100,
		_angle => 0,
		_y => 100,
		_power => 100,
		_shotPower => 1,
		_name => $name,
		_shot => $shot
	};
	bless $self, $class;
	return $self;
}
1;
