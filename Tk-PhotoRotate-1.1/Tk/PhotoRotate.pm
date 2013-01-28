$Tk::PhotoRotate::VERSION = '1.1';

package Tk::Photo;

use POSIX qw/atan/;
use Tk::PhotoRotateSimple;
use Carp;
use strict;

sub rotate {

    my ($photo, $angle, $update) = @_;

    if ($angle eq 0) {
	return;
    } elsif ($angle ==  90) {
	$photo->rotate_simple('l90', $update);
    } elsif ($angle == 180) {
	$photo->rotate_simple('flip', $update);
    } elsif ($angle == 270) {
	$photo->rotate_simple('r90', $update);
    } else {

	# This algorithm arose from a collaborative effort between Richard Suchenwirth,
        # George Staplin and Donal Fellows. They call it "bi-linear interpolation"
	# anti-aliasing.  
	#
	# As a simple approximation, Donal devised a formula for calculating the
	# contribution a rotated pixel's 4 neighbors have upon itself. Quoating from
	# the Wiki page (http://mini.net/tcl/3986):
	#
	# "Think of each pixel as being represented by a point (in its centre, say).
	# Now compute the distance between the point which you are trying to colour
	# and each of the points that you are taking colour from (let these be d(1),
	# d(2), d(3) and d(4).) Now, the weight of the contribution from pixel n
	# should be the ratio between the sums of the other three distances and the
	# total distance: (d(total)-d(n)) / d(total)"
	#
	# "This has the good properties that 
	#
	# 1. When the point is much closer to one pixel than to others, the weight
	#    given to that pixel is much greater, and when the pixels are roughly
	#    equidistant, the weights are the same. 
	# 2. The total of the weights is 1, so no fancy rescaling is necessary."

        my $w = $photo->width;
        my $h = $photo->height;
	my $tmp = $photo->Tk::Widget::image('create', 'photo');
	bless $tmp, 'Tk::Photo';
        $tmp->copy($photo);
        $photo->blank;

        my @buf = ();

	my $a = atan(1) * 8 * $angle / 360.0;
	my $xm = $w / 2.0;
	my $ym = $h / 2.0;
	my $w2 = round( abs($w * cos($a)) + abs($h * sin($a)) );
	my $xm2 = $w2 /2.0;
	my $h2 = round( abs($h * cos($a)) + abs($w * sin($a)) );
	my $ym2 = $h2 / 2.0;
	$photo->configure(-width => $w2, -height => $h2);

	for (my $i = 0; $i < $h2; $i++) {
	    my $toX =  -1;
	    for (my $j = 0;  $j < $w2; $j++) {

		my $rad = hypot( $ym2 - $i, $xm2 - $j);
		my $th = atan2( $ym2 - $i, $xm2 - $j) + $a;
		my $x = $xm - $rad * cos($th);
		next if $x < 0  or $x >= $w;
		my $y = $ym - $rad * sin($th);
		next if $y < 0 or $y >= $h;
		my $x0 = int($x);
		my $x1 = ($x0 + 1) < $w ? $x0+1 : $x0;
		my $dx = $x1 -$x;
		my $y0 = int($y);
		my $y1 = ($y0 + 1) < $h? $y0 + 1: $y0;
		my $dy = $y1 - $y;
		my ($R, $G, $B) = (0, 0, 0);

		my ($r, $g, $b) = $tmp->get($x0, $y0);
		$R = $R + $r * $dx * $dy;
		$G = $G + $g * $dx * $dy;
		$B = $B + $b * $dx * $dy;

		($r, $g, $b) = $tmp->get($x0, $y1);
		$R = $R + $r * $dx * (1.0 - $dy);
		$G = $G + $g * $dx * (1.0 - $dy);
		$B = $B + $b * $dx * (1.0 - $dy);

		($r, $g, $b) = $tmp->get($x1, $y0);
		$R = $R + $r * (1.0 - $dx) * $dy;
		$G = $G + $g * (1.0 - $dx) * $dy;
		$B = $B + $b * (1.0 - $dx) * $dy;

		($r, $g, $b) = $tmp->get($x1, $y1);
		$R = $R + $r * (1.0 - $dx) * (1.0 - $dy);
		$G = $G + $g * (1.0 - $dx) * (1.0 - $dy);
		$B = $B + $b * (1.0 - $dx) * (1.0 - $dy);

		($r, $g, $b) = (round($R), round($G), round($B));
		push @buf,  sprintf("#%02x%02x%02x", $r, $g, $b);
		$toX = $j if $toX == -1;

	    } # forend $j

	    if ($toX >= 0) {
		$photo->put('{' . join(' ', @buf) . '}', -to => $toX, $i);
		@buf = ();
		$photo->idletasks if $update;
	    }

	} # forend $i
    
        $tmp->delete;

    } # ifend $angle

} # end rotate

sub hypot {
    return sqrt ($_[0] * $_[0] + $_[1] * $_[1]);
}

sub round {
    return int($_[0] + 0.5);
}

1;
__END__

=head1 NAME

Tk::PhotoRotate - rotate Photos by arbitrary angles.

=head1 SYNOPSIS

 $photo->rotate(angle, [update]);

=head1 DESCRIPTION

Tk::PhotoRotate is a Photo method that rotates an image by an arbitrary amount.  
If 90, 180 or 270 degrees, then Tk::PhotoRotateSimple is used.

Zero degrees is "north", 90 degrees is "west", 180 degrees is "south",  and 270
degrees is "east".

Translated verbatim from Richard Suchenwirth's version on the Tcl-ers' Wiki.
With assistance from George Staplin and Donal Fellows.

=head1 OPTIONS

The following option/value pairs are supported:

=over 4

=item B<angle>

I<angle> is a positive integer (degrees) between 1 and 359, inclusive.

=item B<update>

I<update> is an optional boolean parameter.  If TRUE,
then idletasks() is called to update the image as it's being rotated.

=head1 EXAMPLE

 $photo->rotate(45, 1);

=head1 AUTHOR

Stephen.O.Lidie@Lehigh.EDU

Copyright (C) 2001 - 2003, Steve Lidie. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 KEYWORDS

Photo, rotate

=cut
