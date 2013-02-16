#!/usr/local/bin/perl -w
package SampleRobot;

our @ISA = "Tank";

sub step{
  my $self = shift;

  $self->x(50);
  $self->y(50);

  #put your step logic here
}

sub enemy_detected{
  # do something with the enemy in front of you
}

1;
