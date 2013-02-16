#!/usr/local/bin/perl -w
package MilleniumFalcon;
 our @ISA = "Tank";

 my $color = "green";

 sub step{
   my $self = shift;
   $self->set_color ( $color );
   $self->turnRight(90);
   $self->move_forward(10);
 }

 sub enemy_spotted {
	my $self = shift;
	$color = "red";
	$self->set_color( $color );
	print "I SAW HIM! GONNA BLOW HIS... YOu GOT THE POINT!";
 }

1;
