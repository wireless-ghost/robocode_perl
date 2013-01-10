#!/usr/local/bin/perl -w

use Tk;
use Tk::widgets qw/JPEG PNG/;
use Tk::Compound;
use Tk::PhotoRotate;
use subs qw/rotate/;
use strict;

$\ = "\n";

my $mw = MainWindow->new;

my $tank1_image = $mw->Photo( -file => "tank.png" );
my $shot_image  = $mw->Photo( -file => "shot.png" );

my $canvas = $mw->Canvas( -width => 512, -height => 512, -background => 'black' ) -> pack;

$mw->protocol( 'WM_DELETE_WINDOW', \&exit_app );
$mw->bind( "<q>"         => \&exit_app );
$mw->bind( "<Control-c>" => \&exit_app );
$mw->bind( "<w>"				 => \&move_up );
$mw->bind( "<s>"				 => \&move_down );
$mw->bind( "<d>"				 => \&move_right );
$mw->bind( "<a>"				 => \&move_left );
$mw->bind( "<r>"         => \&rotate_tank );
$mw->bind( "<f>"         => \&shoot_up );

my $angle = 0;
my $x;
my $y;
my $clockwise = 1; #one means clockwise, everything different from 1 - anticlockwise

$x = 100; $y = 100;

$canvas->createImage( $x,$y,
														-image => $tank1_image,
														-tags => ['tank1'] );
$canvas->createImage( $x,
                      $y + 1,
                      -image => $shot_image,
                      -tags => ['shot'] );
														
sub exit_app {
    $mw->destroy;
    exit;
}

sub rotate_tank {
  #added new variable,so if the user change it while the function is being executed there won't be
  #constant rotating of the tank
  my $is_clockwise = $clockwise;
  my $total_angle = ( $clockwise == 1 ? 0 : 360 ) + $angle; #when the tank is headed left the rotation will start from there

  for ( my $cur_angle = ( $is_clockwise == 1 ? 360 : 0 ) + $angle; 
                            $is_clockwise == 1 ? $cur_angle >= $total_angle : $cur_angle <= $total_angle; 
                            $is_clockwise == 1 ? $cur_angle-- : $cur_angle++ ) { #it is from 360 to 0 because this is the clockwise direction
       move_tank( $cur_angle , $x, $y );
       $angle = $cur_angle;
    }
  }

sub move_up {
		move_tank( 0, $x, --$y );
    $angle = 0;
	}

sub move_down {
		move_tank( 180, $x, ++$y );
    $angle = 180;
	}
	
	sub move_right {
    move_tank( 270, ++$x, $y );
    $angle = 270;
	}
	
	sub move_left {
		move_tank( 90, --$x, $y );
    $angle = 90;
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

sub shoot_up{
    print "Started Shooting...";
    print $y;
    for ( my $i = $y; $i > 0; $i-- ){
      shoot( $x, $i );
    }
    print "Tank stopped shooting...";
  }

sub shoot {
    print $x;
    my $x = shift;
    my $y = shift;

    $canvas->delete( 'shot' );

    print $x, $y;

    my $new_shot = $mw->Photo;
    $new_shot->copy( $shot_image );
 
    $new_shot->rotate( 0 );
    
    $canvas->createImage
    (
      $x, 
      $y, 
      -image => $new_shot,
      -tags => [ 'shot' ]
    );

    $canvas->update;
  }

MainLoop;
