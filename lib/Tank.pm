#!/usr/local/bin/perl -w
package Tank;

use Math::Trig;
use Shot;

$\ = "\n";

sub step {
  print "step method of the tank should be overriden.";
  print "Robot is suiciding!!!";
  $self->{_power} = 0;
}

sub get_name{
  my ($self) = @_;
  return $self->{_name};
}

sub checkPower {
  my ($self) = @_;
  if ($self->{_power} <= 0){
    return 0;
  }
  return 1;
}

sub get_color {
  my ($self) = @_;
  return $self->{_color};
}

sub set_color {
  my ($self, $color) = @_;
  $self->{_color} = $color if defined $color;
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
  my ( $self, $distance ) = @_;
  print "$self->{_name} is moving forward...";

  if ( $self->{_y} >= 488 || $self->{_y} <= 24 #bottom/ top of the screen
    || $self->{_x} <= 24 || $self->{_x} >= 488 #left/ right of the screen
    || $self->{_power} <= 0 ) {
    return 0;	
  }

  if ( $self->{_angle} == 360 or $self->{_angle} == 0) {
    $self->{_y} -= $distance;
  }
  elsif ( $self->{_angle} == 270 or $self->{_angle} == -90 ) {
    $self->{_x} += $distance;
  }
  elsif ( $self->{_angle} == 180 or $self->{_angle} == -180 ) {
    $self->{_y} += $distance;
  }
  elsif ( $self->{_angle} == 90 or $self->{_angle} == -270) {
    $self->{_x} -= $distance;
  }
  elsif ( ( $self->{_angle} >= 271 && $self->{_angle} <= 359)
    || ($self->{_angle} >= -179 && $self->{_angle} <= -91  ) ) {#first quadrant
    $self->{_x} += $distance;
    $self->{_y} += $distance;
  }
  elsif ( ( $self->{_angle} >= 181 && $self->{_angle} <= 269)
    || ( $self->{_angle} >= -89 && $self->{_angle} <= -1 ) ) { #second quadrant
    $self->{_x} += $distance;
    $self->{_y} -= $distance;
  }
  elsif ( ( $self->{_angle} >= 91 && $self->{_angle} <= 179 )
    || ( $self->{_angle} => -359 && $self->{_angle} <= -271 ) ) { #third quadrant
    $self->{_x} -= $distance;
    $self->{_y} -= $distance;
  }
  elsif ( ( $self->{_angle} >= 1 && $self->{_angle} <= 89 ) 
    || ( $self->{_anlge} >= -269 && $self->{_angle} <= -181 )) { #forth quadrant
    $self->{_x} -= $distance;
    $self->{_y} += $distance;
  }

  $self->{_shot}->set_x( $self->{_x} );
  $self->{_shot}->set_y( $self->{_y} );

  $self->{_power} -= $distance;
}

sub check_enemies {
  print "Checking for enemies";
  my ( $self, @tanks ) = @_;
  foreach my $cur_tank ( @tanks ){
    if ( $self->{_name} ne $cur_tank->get_name() ) {
      if ( $self->checkForEnemy( $cur_tank->getX(), $cur_tank->getY() ) == 1 ) {
        return 1;
      }
    }
  }
  return 0;
}

sub checkForEnemy {
  my ($self, $e_x, $e_y) = @_;
  my $x = $self->{_x};
  my $y = $self->{_y};

  print "Checking enemy at ($x, $y)";

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
    return 1;
  }	
  return 0;
}

sub turnLeft {
  my ( $self, $turning_angle ) = @_;

  $self->{_angle} += $turning_angle;
}

sub turnRight {
  my ( $self, $turning_angle ) = @_;
  if ( $self->{_power} <= 0 ) {
    print "$self->{_name} is out of power!!!";
    return 0;
  }
  $self->{_angle} -= $turning_angle;
  if ( $self->{_angle} < -360 || $self->{_angle} > 360){
    $self->{_angle} = $self->{_angle} % 360; 
  }
}

sub shoot_it{
  my ( $self ) = @_;
  if ( $self->{_power} <= 0 ){
    return 0;
  }
  $self->{_isShooting} = 1;
  print "$self->{_name} started Shooting...";
  $self->{_shot}->shoot( $self->{_angle}, 1 );

  print "$self->{_name} stopped shooting...";
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

sub enemy_spotted {
  my ( $self ) = @_;
  #All tanks should extend this function.
  #It declares what the tank should do when he spots an enemy.
  print "Enemy Spotted";
  print "Make your own function!";
  print "Robot is suiciding!!!";
  $self->{_power} = 0;
}

sub tank_shooting{
  my ( $self ) = @_;
  return $self->{_isShooting};
}

sub shoot{ 
  my ( $self ) = @_;
  $self->{_isShooting} = 1;
  $self->{_power} -= $self->{_shotPower};
}

sub set_shooting{
  my ( $self, $state ) = @_;
  $self->{_isShooting} = $state;
}

sub check_for_intersection {
  my ( $self, $x, $y ) = @_;
  print "intersec in $x, $y";
  if ( ( $self->{_x} + 24 >= $x and
      $self->{_x} - 24 <= $x ) or
      ( $self->{_y} + 24 >= $y and
        $self->{_y} - 24 <= $y ) ) {
        return 1;
      }
      return 0;
}

sub recieve_hit {
  my $self = shift;
  my $damage = shift;
#:my ( $self, $damag ) = @_;
  $self->{_power} -= $damage;
}

sub bullseye {
  my $self = shift;;
  $self->{_power} += $self->{_shotPower};
}

sub x{
  my ( $self, $x ) = @_;
  $self->{_x} = $x;
  $self->{_shot}->set_x( $x );
}

sub y{
  my( $self, $y ) = @_;
  $self->{_y} = $y;
  $self->{_shot}->set_y( $y );
}

sub new
{
  my $class = shift;
  my $name = shift;
  my $self = {
    _x => int(rand(460))+25,
    _y => int(rand(460))+25,
    _angle => 0,
    _power => 1000,
    _shotPower => 10,
    _name => $name,
    #   _shot => $shot,
    _color => "blue",
    _isShooting => 0
  };
  my $shot = new Shot( $self->{_x}, $self->{_y} + 23 );
  $self->{_shot} = $shot;
  bless $self, $class;
  return $self;
}
1;
