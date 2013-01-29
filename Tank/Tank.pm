#!/usr/local/bin/perl -w

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
	if ($self->checkPower() != 1){
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
	my ($self) = @_;
	print "moving forward!!!";
#    print "old x: $self->{_x}, old y: $self->{_my}, angle: $self->{_angle}";

	if ( $self->{_angle} == 360 or $self->{_angle} == 0) {
		$self->{_my} -= 1;
	}
	elsif ( $self->{_angle} == 270 ) {
		$self->{_x} += 1;
	}
	elsif ( $self->{_angle} == 180 ) {
		$self->{_my} += 1;
	}
	elsif ( $self->{_angle} == 90 ) {
		$self->{_x} -= 1;
	}
	elsif ( $self->{_angle} >= 271 && $self->{_angle} <= 359 ) {#first quadrant
		$self->{_x} += 1;
		$self->{_my} += 1;
	}
	elsif ( $self->{_angle} >= 181 && $self->{_angle} <= 269 ) { #second quadrant
		$self->{_x} += 1;
		$self->{_my} -= 1;
	}
	elsif ( $self->{_angle} >= 91 && $self->{_angle} <= 179 ) { #third quadrant
		$self->{_x} -= 1;
		$self->{_my} -= 1;
	}
	elsif ( $self->{_angle} >= 1 && $self->{_angle} <= 89 ) { #forth quadrant
		$self->{_x} -= 1;
		$self->{_my} += 1;
	}

	$self->{_power}--;
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
	print "Started Shooting...";
#print $self->{_my};
#    for ( my $i = $self->{_my}; $i > 0; $i-- ) {
#     draw_shot( $self->{_x}, $i );
#  }
	print "Tank stopped shooting...";
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
	my $self = {
		_x => 100,
		_angle => 0,
		_my => 100,
		_power => 100,
		_shotPower => 1
	};
	bless $self, $class;
	return $self;
}
1;
