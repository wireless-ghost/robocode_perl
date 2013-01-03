#!/usr/local/bin/perl -w
use Tk;
use Tk::widgets qw/JPEG PNG/;
use Tk::Compound;
use Tk::PhotoRotateSimple;
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

sub move_up {
		move_tank('original');
	}

sub move_down {
		move_tank('flip');
	}
	
	sub move_right {
		move_tank('r90');
	}
	
	sub move_left {
		move_tank('l90');
	}
	
sub move_tank {
				my $direction = shift;
				$c->delete('all');
				my $new_image = $mw->Photo;
				$new_image->copy($image);
				print $direction;
				$new_image->rotate_simple($direction) unless $direction != 'original';
				#$image->rotate_simple($direction);
				$c->createImage
		  (++$x,
		   ++$y,
		   -image => $new_image, 
		   -tags => ['tank']);
	}

MainLoop;
