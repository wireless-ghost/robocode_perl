#!/usr/local/bin/perl -w

use Time::HiRes;
use Tk;
use Tk::widgets qw/JPEG PNG/;
use Tk::Compound;
use Tk::PhotoRotate;
use subs qw/rotate/;
use strict;

$\ = "\n";

    my $mw;

    my $tank1_image;
    my $shot_image;

    my $canvas;
    my $kp;
    my $angle;
    my $x;
    my $y;
    my $clockwise;

sub exit_app {
    $mw->destroy;
    exit;
}

sub rotate_tank {
  #added new variable,so if the user change it while the function is being executed there won't be
  #constant rotating of the tank
  my $is_clockwise = $clockwise;
 
  print "in rotate_tank... angle is $angle";

  #here we need to justify the angle if it is greater than 360
  if ( $angle > 360 )
  {
    my $k = $angle / 360;
    $angle = $angle - ( $k * 360);
  }

  my $total_angle = ( $clockwise == 1 ? 0 : 360 ) + $angle; #when the tank is headed left the rotation will start from there

  for ( my $cur_angle = ( $is_clockwise == 1 ? 360 : 0 ) + $angle; 
                            $is_clockwise == 1 ? $cur_angle >= $total_angle : $cur_angle <= $total_angle; 
                            $is_clockwise == 1 ? $cur_angle-- : $cur_angle++ ) { #it is from 360 to 0 because this is the clockwise direction
       if ( $kp == 1 ) 
       {
        move_forward();
        last;
       }
       move_tank( $cur_angle , $x, $y );
       $angle = $cur_angle;
    }
  }

sub move_up {
		move_tank( 0, $x, --$y );
    $angle = 0;
    $kp = 1;
	}

sub move_down {
		move_tank( 180, $x, ++$y );
    $angle = 180;
    $kp = 1;
	}
	
	sub move_right {
    move_tank( 270, ++$x, $y );
    $angle = 270;
    $kp = 1;
	}
	
	sub move_left {
    move_tank( 90, --$x, $y );
    $angle = 90;
    $kp = 1;
	}
	
  sub move_forward {

    print "moving forward!!!";
    print "old x: $x, old y: $y, angle: $angle";

    $kp = 0;

    if ( $angle == 360 or $angle == 0) {
      $y += 1;
    }
    elsif ( $angle == 270 ) {
      $x += 1;
    }
    elsif ( $angle == 180 ) {
      $y -= 1;
    }
    elsif ( $angle == 90 ) {
      $x -= 1;
    }
    elsif ( $angle >= 271 && $angle <= 359 ) {#first quadrant
      $x += 1;
      $y += 1;
    }
    elsif ( $angle >= 181 && $angle <= 269 ) { #second quadrant
      $x += 1;
      $y -= 1;
    }
    elsif ( $angle >= 91 && $angle <= 179 ) { #third quadrant
      $x -= 1;
      $y -= 1;
    }
    elsif ( $angle >= 1 && $angle <= 89 ) { #forth quadrant
      $x -= 1;
      $y += 1;
    }

    draw_tank( $angle, $x, $y);

    print "new x: $x, new y: $y, angle: $angle";
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
    my $turning_angle = shift;

    $angle += $turning_angle;

    draw_tank( $angle, $x, $y);
  }

sub turnRight {
    my $turning_angle = shift;

    $angle -= $turning_angle;

    draw_tank( $angle, $x, $y );
  }

sub shoot_up{
    print "Started Shooting...";
    print $y;
    for ( my $i = $y; $i > 0; $i-- ) {
      draw_shot( $x, $i );
    }
    print "Tank stopped shooting...";
  }

sub draw_shot {
    my $x = shift;
    my $y = shift;

    $canvas->delete( 'shot' );

    print $x, $y;

    my $new_shot = $mw->Photo;
    $new_shot->copy( $shot_image );
    
    $canvas->createImage
    (
      $x, 
      $y, 
      -image => $new_shot,
      -tags => [ 'shot' ]
    );

    $canvas->update;
  }

MAIN: {
    $mw = MainWindow->new;

    $tank1_image = $mw->Photo( -file => "tank.png" );
    $shot_image  = $mw->Photo( -file => "shot.png" );

    $canvas = $mw->Canvas( -width => 512, -height => 512, -background => 'black' ) -> pack;

    $mw->protocol( 'WM_DELETE_WINDOW', \&exit_app );
    $mw->bind( "<q>"         => \&exit_app );
    $mw->bind( "<Control-c>" => \&exit_app );
    $mw->bind( "<w>"				 => \&move_up );
    $mw->bind( "<s>"				 => \&move_down );
    $mw->bind( "<d>"				 => \&move_right );
    $mw->bind( "<a>"				 => \&move_left );
    $mw->bind( "<r>"         => \&rotate_tank );
    $mw->bind( "<f>"         => \&shoot_up );

    $kp = 0; #key pressed
    $angle = 0;
    $x;
    $y;
    $clockwise = 1; #one means clockwise, everything different from 1 - anticlockwise

    $x = 100; $y = 100;

    $canvas->createImage( $x,$y,
    -image => $tank1_image,
    -tags => ['tank1'] );
    $canvas->createImage( $x,
                          $y + 1,
                          -image => $shot_image,
                          -tags => ['shot'] );
    
    MainLoop;
 }
