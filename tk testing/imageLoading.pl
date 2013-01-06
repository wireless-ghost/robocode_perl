#!/usr/local/bin/perl -w

use Tk;
use Tk::widgets qw/JPEG PNG/;
use Tk::Compound;
use Tk::PhotoRotate;
use subs qw/rotate/;
use strict;

$\ = "\n";

my $mw = MainWindow->new;
my $column = 0;


my $image = $mw->Photo( -file => "tank.png" );

my $c = $mw->Canvas( -width => 512, -height => 512, -background => 'black' ) -> pack;

$mw->protocol( 'WM_DELETE_WINDOW', \&exit_app );
$mw->bind( "<q>"         => \&exit_app );
$mw->bind( "<Control-c>" => \&exit_app );
$mw->bind( "<w>"					=> \&move_up );
$mw->bind( "<s>"					=> \&move_down );
$mw->bind( "<d>"					=> \&move_right );
$mw->bind( "<a>"					=> \&move_left );
$mw->bind( "<r>"         => \&rotate_tank );

#my $tank1 = $c->Label(-image => $image)->place('-x' => 20,
#						   '-y' => 10);
my $angle = 0;
my $x;
my $y;
$x = 100; $y = 100;
my $tank1 = $c->createImage( $x,$y,
														-image => $image,
														-tags => ['tank'] );
														
sub exit_app {
    $mw->destroy;
    exit;
}

sub rotate_tank {
    my $total_angle = 0 + $angle; #when the tank is headed left the rotation will start from there
    for ( my $cur_angle = 360 + $angle; $cur_angle > $total_angle; $cur_angle-- ) { #it is from 360 to 0 because this is the clockwise direction
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
				$c->delete( 'all' );
				my $new_image = $mw->Photo;
				$new_image->copy( $image );
				print "$angle , $x , $y";
        print 'date +%N';
        $new_image->rotate( $angle );
				$c->createImage
		    ( $x,
		      $y,
		      -image => $new_image, 
		      -tags => ['tank'] );
        $c->update;
	}

MainLoop;
