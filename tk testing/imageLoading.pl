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

#my $f = $mw->Frame->grid(-row => 0, -column => $column++, -sticky => 'n' );

my $image = $mw->Photo(-file => "tank.png");
#$f->Label(-image => $image)->grid;

#my $f2 = $mw->Frame->grid(-row =>1, -column => $column);
#$f2->Label(-image => $image)->grid;

my $c = $mw->Canvas(-width => 512, -height => 512, -background => 'black')->pack;

$mw->protocol('WM_DELETE_WINDOW', \&exit_app);
$mw->bind("<q>"         => \&exit_app);
$mw->bind("<Control-c>" => \&exit_app);
$mw->bind("<w>"					=> \&move_up);
$mw->bind("<s>"					=> \&move_down);
$mw->bind("<d>"					=> \&move_right);
$mw->bind("<a>"					=> \&move_left);
$mw->bind("<r>"         => \&rotate_tank);

#my $tank1 = $c->Label(-image => $image)->place('-x' => 20,
#						   '-y' => 10);
my $x;
my $y;
$x = 10; $y = 10;
my $tank1 = $c->createImage($x,$y,
														-image => $image,
														-tags => ['tank']);
														
#$top->Label(-textvariable => \$punkte_text)->place('-x' => LINKER_RAND,
	#					   '-y' => BUTTONS_UNTEN);

sub exit_app {
    $mw->destroy;
    exit;
}

sub rotate_tank {
    
#    my $time = $start_time + 1;
    my $total_time = time() + 30;
    my $last_time = time();
    for ( my $time = time(); $time < $total_time; $time = time() ) {
      if ( $time - $last_time == 1){
       move_tank($total_time - $time, $x, $y);
       $last_time = time();
      }
    }
  }

sub move_up {
		move_tank(0, $x, --$y);
	}

sub move_down {
		move_tank(180, $x, ++$y);
	}
	
	sub move_right {
#		move_tank('r90', ++$x, $y);
    move_tank(270, ++$x, $y);
	}
	
	sub move_left {
		move_tank(90, --$x, $y);
	}
	
sub move_tank {
				my $direction = shift;
        my $x = shift;
        my $y = shift;
				$c->delete('all');
				my $new_image = $mw->Photo;
				$new_image->copy($image);
				print $direction;
        print time();
#				$new_image->rotate_simple($direction) unless $direction eq 'original';
        $new_image->rotate($direction);
				#$image->rotate_simple($direction);
				$c->createImage
		  (++$x,
		   ++$y,
		   -image => $new_image, 
		   -tags => ['tank']);
	}

MainLoop;
