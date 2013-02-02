#!/usr/local/bin/perl -w
use Math::Trig;

package Tank;

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
	if ($self->checkPower() != 1 || $self->{_my} <= 0 ){
		return 0;
	}
	$self->{_my}--;
	$self->{_angle} = 0;
	$self->{_power}--;
}

sub move_down {
	my ($self) = @_;
	if ($self->checkPower() != 1){
		return 0;
	}
	$self->{_my} = $self->{_my} + 1;
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

	if ( $self->{_my} >= 488 || $self->{_my} <= 24 #bottom/ top of the screen
		|| $self->{_x} <= 24 || $self->{_x} >= 488 #left/ right of the screen
		|| $self->{_power} <= 0 ) {
		return 0;	
	}

	if ( $self->{_angle} == 360 or $self->{_angle} == 0) {
		$self->{_my} -= 1;
	}
	elsif ( $self->{_angle} == 270 or $self->{_angle} == -90 ) {
		$self->{_x} += 1;
	}
	elsif ( $self->{_angle} == 180 or $self->{_angle} == -180 ) {
		$self->{_my} += 1;
	}
	elsif ( $self->{_angle} == 90 or $self->{_angle} == -270) {
		$self->{_x} -= 1;
	}
	elsif ( ( $self->{_angle} >= 271 && $self->{_angle} <= 359)
		|| ($self->{_angle} >= -179 && $self->{_angle} <= -91  ) ) {#first quadrant
		$self->{_x} += 1;
		$self->{_my} += 1;
	}
	elsif ( ( $self->{_angle} >= 181 && $self->{_angle} <= 269)
		|| ( $self->{_angle} >= -89 && $self->{_angle} <= -1 ) ) { #second quadrant
		$self->{_x} += 1;
		$self->{_my} -= 1;
	}
	elsif ( ( $self->{_angle} >= 91 && $self->{_angle} <= 179 )
		|| ( $self->{_angle} => -359 && $self->{_angle} <= -271 ) ) { #third quadrant
		$self->{_x} -= 1;
		$self->{_my} -= 1;
	}
	elsif ( ( $self->{_angle} >= 1 && $self->{_angle} <= 89 ) 
		|| ( $self->{_anlge} >= -269 && $self->{_angle} <= -181 )) { #forth quadrant
		$self->{_x} -= 1;
		$self->{_my} += 1;
	}

	$self->{_power}--;
}

sub checkForEnemy {
#	my ( $self, $enemyX, $enemyY ) = @_;
#	if ( tan ( ( )
}

sub turnLeft {
	my ($self, $turning_angle) = @_;

	$self->{_angle} += $turning_angle;
}

sub turnRight {
	my ($self, $turning_angle) = @_;

	$self->{_angle} -= $turning_angle;
}

sub shoot_up{
	my ($self) = @_;
	if ($self->{_power} <= 0){
		return 0;
	}
	print "$self->{_name} started Shooting...";
#print $self->{_my};
#    for ( my $i = $self->{_my}; $i > 0; $i-- ) {
#     draw_shot( $self->{_x}, $i );
#  }
	print "$self->{_name} stopped shooting...";
}

sub getX{
	my( $self ) = @_;
	return $self->{_x};
}

sub getY{
	my( $self ) = @_;
	return $self->{_my};
}

sub getAngle{
	my ($self) = @_;
	return $self->{_angle};		
}

sub getPower{
	my ($self) = @_;
	return $self->{_power};
}

sub getShotPower{
	my ($self) = @_;
	return $self->{_shotPower};
}

sub setShotPower{
	my ($self, $shotPower) = @_;
	$self->{_shotPower} = $shotPower if defined($shotPower);
	return $self->{_shotPower};
}

sub new
{
	my $class = shift;
	my $name = shift;
	my $self = {
		_x => 100,
		_angle => 0,
		_my => 100,
		_power => 100,
		_shotPower => 1,
		_name => $name
	};
	bless $self, $class;
	return $self;
}
1;