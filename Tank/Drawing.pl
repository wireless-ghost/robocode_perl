#!/usr/local/bin/perl -w

use Time::HiRes;
use Tk;
use Tk::widgets qw/JPEG PNG/;
use Tk::Compound;
use Tk::PhotoRotate;
use subs qw/rotate/;
use Tank;

$\ = "\n";

my $mw;

my $tank1_image;
my $shot_image;

my $canvas;
my $kp;

my $tank1 = new Tank();

sub exit_app {
	$mw->destroy;
	exit;
}

sub move_up {
	$tank1->move_up();
	move_tank( 0, $tank1->getX(), $tank1->getY() );
	$kp = 1;
}

sub move_down {
	$tank1->move_down();
	move_tank( 180, $tank1->getX(), $tank1->getY() );
	$kp = 1;
}

sub move_right {
	$tank1->move_right();
	move_tank( 270, $tank1->getX(), $tank1->getY() );
	$kp = 1;
}

sub move_left {
	$tank1->move_left();
	move_tank( 90, $tank1->getX(), $tank1->getY() );
	$kp = 1;
}

sub move_forward {
	print "moving forward!!!";
	$tank1->move_forward();
	draw_tank( $tank1->getAngle(), $tank1->getX(), $tank1->getY());
}

sub move_tank {
	my $angle = shift;
	my $x = shift;
	my $y = shift;

	$canvas->delete( 'tank1' );

	my $new_image = $mw->Photo;
	$new_image->copy( $tank1_image );

	print "angle: $angle , x: $x , y: $y";

	$new_image->rotate( $angle );
	$canvas->createImage
		( $x,
		  $y,
		  -image => $new_image, 
		  -tags => ['tank1'] );

	$canvas->update;
}

sub draw_tank {
	$canvas->delete( 'tank1' );

	my $my_angle = shift;
	my $my_x = shift;
	my $my_y = shift;

	$canvas->delete( 'tank1' );

	my $new_image = $mw->Photo;
	$new_image->copy( $tank1_image );

	print "angle: $my_angle , x: $my_x , y: $my_y";

	$new_image->rotate( $my_angle );

	$canvas->createImage
		( $my_x,
		  $my_y,
		  -image => $new_image, 
		  -tags => ['tank1'] );

	$canvas->update;
}

sub turnLeft {
	$tank1->turnLeft();
	draw_tank( $tank1->getAngle(), $tank1->getX(), $tank1->getY());
}

sub turnRight {
	$tank1->turnRight();
	draw_tank( $tank1->getAngle(), $tank1->getX(), $tank1->getY() );
}

sub shoot_up {
	print "Started Shooting...";
#    print $tank1->getY();
#$    for ( my $i = $tank1->getY(); $i > 0; $i-- ) {
#      draw_shot( $tank1->getX(), $i );
#    }
	print "Tank stopped shooting...";
}

sub draw_shot {
#    my $tank1->getX() = shift;
#    my $tank1->getY() = shift;#

#    $canvas->delete( 'shot' );
#
#    print $tank1->getX(), $tank1->getY();
#
#    my $new_shot = $mw->Photo;
#    $new_shot->copy( $shot_image );
#    
#    $canvas->createImage
#    (
#      $tank1->getX(), 
#      $tank1->getY(), 
#      -image => $new_shot,
#      -tags => [ 'shot' ]
#    );#
#
#    $canvas->update;
}

MAIN: {
	      $tank1 = new Tank();
	      $mw = MainWindow->new;

	      $tank1_image = $mw->Photo( -file => "images/tank.png" );
	      $shot_image  = $mw->Photo( -file => "images/shot.png" );

	      $canvas = $mw->Canvas( -width => 512, -height => 512, -background => 'black' ) -> pack;

	      $mw->protocol( 'WM_DELETE_WINDOW', \&exit_app );
	      $mw->bind( "<q>"         => \&exit_app );
	      $mw->bind( "<Control-c>" => \&exit_app );
	      $mw->bind( "<w>"				 => \&move_up );
	      $mw->bind( "<s>"				 => \&move_down );
	      $mw->bind( "<d>"				 => \&move_right );
	      $mw->bind( "<a>"				 => \&move_left );
#$mw->bind( "<r>"         => \&rotate_tank );
	      $mw->bind( "<c>"				 => \&move_forward);
	      $mw->bind( "<f>"         => \&shoot_up );

	      $kp = 0; #key pressed

#    $clockwise = 1; #one means clockwise, everything different from 1 - anticlockwise

		      $canvas->createImage( $tank1->getX(),$tank1->getY(),
				      -image => $tank1_image,
				      -tags => ['tank1'] );
	      $canvas->createImage( $tank1->getX(),
			      $tank1->getY() + 1,
			      -image => $shot_image,
			      -tags => ['shot'] );

	      MainLoop;
      }
