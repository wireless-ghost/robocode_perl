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
    my $total_time = time() + 180;
    my $last_time = time();
    for ( my $time = time(); $time < $total_time; $time = time() ) {
       rotate( ( $total_time - $time ) * 10, $x, $y );
       $last_time = time();
    }
  }

sub rotate {
    my $angle = shift;
    my $x = shift;
    my $y = shift;

    move_tank( $angle, $x, $y );
  }

sub move_up {
		move_tank( 0, $x, --$y );
	}

sub move_down {
		move_tank( 180, $x, ++$y );
	}
	
	sub move_right {
    move_tank( 270, ++$x, $y );
	}
	
	sub move_left {
		move_tank( 90, --$x, $y );
	}
	
sub move_tank {
				my $angle = shift;
        my $x = shift;
        my $y = shift;
				$c->delete( 'all' );
				my $new_image = $mw->Photo;
				$new_image->copy( $image );
				print "$angle , $x , $y";
        print time();
        $new_image->rotate( $angle );
				$c->createImage
		    ( $x,
		      $y,
		      -image => $new_image, 
		      -tags => ['tank'] );
        $c->update;
	}

MainLoop;
