#!/usr/local/bin/perl -w
use List::Util qw(shuffle);
use Time::HiRes;
use Tk;
use Tk::widgets qw/JPEG PNG/;
use Tk::Compound;
use Tk::PhotoRotate;
use subs qw/rotate/;
use Tank;
use lib "../robots";
use AnyEvent;

$\ = "\n";

my $tank_colors;

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

sub scan {

	print $tank1->getAngle();
		
	if ( $tank1->getAngle() > 360 ){
		my $k = $tank1->getAngle() / 360;
		$tank1->getAngle() = $tank1->getAngle() - ( $k * 360);
	}

	print $tank1->getAngle();

	$kp = 0;
	
	my $total_angle = 0 + $tank1->getAngle();
	for ( my $cur_angle = 360 + $tank1->getAngle(); 
			$cur_angle >= $total_angle; 
			$cur_angle--) {
		if ( $kp == 1 )
		{
			move_forward();
			last;
		}
		$tank1->turnRight( 1  );
		move_tank( $tank1->getAngle() , $tank1->getX(), $tank1->getY() );
	}

}

sub move_forward {
	print "moving forward!!!";
	$kp = 1;
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
	my $tank = shift;
  my $my_angle = $tank->getAngle();
	my $my_x = $tank->getX();
	my $my_y = $tank->getY();

	$canvas->delete( $tank->get_name() );

	my $new_image = $mw->Photo;
	$new_image->copy( $tank_colors->{$tank->get_color()});

	print "angle: $my_angle , x: $my_x , y: $my_y";

	$new_image->rotate( $my_angle );

	$canvas->createImage
		( $my_x,
		  $my_y,
		  -image => $new_image, 
		  -tags => [$tank->get_name()] );

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

  my $tank1 = shift;

  my @tanks = shift;

	while (1){		
  if ( $tank1->getShotX() >= 510 or $tank1->getShotX() <= 2 
              or $tank1->getShotY() >= 510 or $tank1->getShotY() <= 2 ) {
            last;
					}
					else {
						$tank1->shoot_it();
						draw_shot( $tank1->getShotX(), $tank1->getShotY() );

            my @del_indexes;

            foreach my $current_tank (@tanks){
              next if !defined($current_tank);
              if ( $current_tank->get_name()
                ne $tank1->get_name() ) {
               if ( $current_tank->check_for_intersection( $tank1->getShotX(), $tank1->getShotY() ) == 1 ){
                 $current_tank->recieve_hit( $tank1->getShotPower() );
                  $tank1->bullseye();
                  if( $current_tank->checkPower() == 1 ) {
                    @del_indexes = reverse(grep { $tanks[$_] eq $current_tank->get_name() } 0..$#tanks);
                    last;
                  }
               }
              }
            }
        
          foreach my $item (@del_indexes) {
            splice ( @tanks, $item, 1 );
          }

					}
	}
  $tank1->set_shooting(0);
	print "Tank stopped shooting...";
}

sub draw_shot {
	my $x = shift;
	my $y = shift;

  $canvas->delete( 'shot' );
    
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

sub loop {
  my @tanks = @_;
  while(1){
    foreach my $current_tank ( @tanks ){
      $current_tank->step(); 
      draw_tank($current_tank);
      if ( $current_tank->check_enemies( @tanks ) == 1 ) {
        $current_tank->enemy_spotted();
      }
      if ( $current_tank->tank_shooting() == 1 ) {
        shoot_up($current_tank, @tanks);
      }
    } 
  }

}

MAIN: {
       my @tanks = (); 
	      $mw = MainWindow->new;
        $tank_colors = {
          'blue' => $mw->Photo( -file => "images/tank_blue.png" ),
          'red' => $mw->Photo( -file => "images/tank_red.png" ),
          'green' => $mw->Photo( -file => "images/tank_green.png" ),
        };

	      $canvas = $mw->Canvas( -width => 512, -height => 512, -background => 'black' ) -> pack;

	      $mw->protocol( 'WM_DELETE_WINDOW', \&exit_app );
	      $mw->bind( "<q>"         			=> \&exit_app );
	      $mw->bind( "<Control-c>" 			=> \&exit_app );
	      $kp = 0; #key pressed
	      $shot_image  = $mw->Photo( -file => "images/shot.png" );

        my $robots_dir = '../robots';
        opendir (DIR, $robots_dir) or die $!;

        while (my $file = readdir(DIR)){
          next if ($file !~ m/(.*)\.pm/); 
          require $file;
          my $tank = new $1($1);

	        $canvas->createImage( $tank->getX(),$tank->getY(),
				      -image => $tank_colors->{$tank->get_color()},
				      -tags => [$1] );
	      
	        $canvas->createImage( $tank->getX(),
			      $tank->getY() + 1,
			      -image => $shot_image,
			      -tags => ['shot'] );
          push(@tanks, $tank);
        }

        shuffle @tanks;
	loop( @tanks );
	MainLoop;
}
