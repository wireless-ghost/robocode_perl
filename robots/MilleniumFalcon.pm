#!/usr/local/bin/perl -w
package MilleniumFalcon;
 our @ISA = "Tank";
 sub step{
   my $self = shift;
   $self->set_color ( "green" );
   $self->turnRight(90);
   $self->move_forward(10);
 }
1;
