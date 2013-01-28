$Tk::PhotoRotateSimple::VERSION = '1.1';

package Tk::Photo;
use Carp;
use strict;

sub rotate_simple {

    my ($photo, $rot, $update) = @_;
    carp "Illegal rotation '$rot'." unless $rot =~ /l90|r90|flip/i;

    my $tmp = $photo->Tk::Widget::image('create', 'photo');
    bless $tmp, 'Tk::Photo';

    my $width = $photo->width;
    my $height = $photo->height;

    if ($rot =~ /l90/i) {

	# To rotate l90 grab to left-most column and put it to the
	# botton row of the temporary Photo, repeating until all
	# columns are rotated.

	for (my $x = 0; $x < $width; $x++) {
	    my $curpix = $photo->data(-from => $x, 0, $x + 1, $height);
	    $curpix = "{$curpix}";
	    $tmp->put($curpix, -to => 0, $width - $x - 1);
	    $photo->idletasks if $update;
	}
    } elsif ($rot =~ /r90/i) {
	
	# To rotate r90 grab to top-most row and put it to the right
	# column of the temporary Photo, repeating until all rows
	# are rotated.

	for (my $y = 0; $y < $height; $y++) {
	    my $curpix = $photo->data(-from => 0, $y, $width, $y + 1);
	    $curpix =~ s/^{(.*)}$/$1/;
	    $tmp->put($curpix, -to => $height - $y - 1, 0);
	    $photo->idletasks if $update;
	}
    } else {

	# Flip is easy because copy's -subsample option automatically
	# flips if it's arguments are negative.

	$tmp->copy($photo, -subsample => -1, -1);
    }

    $photo->blank;
    $photo->copy($tmp);
    $photo->configure(-height => $width, -width => $height) if $rot !~ /flip/i;
    $photo->idletasks if $update;
    
    $tmp->delete;
    
} # end rotate

1;
__END__

=head1 NAME

Tk::PhotoRotateSimple - rotate Photos by 90 degrees.

=head1 SYNOPSIS

 $photo->rotate_simple(direction, [update]);

=head1 DESCRIPTION

Tk::PhotoRotateSimple is a Photo method that either flips an image 180 degress,
or rotates it 90 degrees clockwise or 90 degrees anti-clockwise.

Algorithm from img_rotate.tcl by Ryan Casey.

=head1 OPTIONS

The following option/value pairs are supported:

=over 4

=item B<direction>

I<direction> can be I<flip>, I<l90> or I<r90>, for a 180 degree, 90
degree anti-clockwise, or 90 degree clockwise rotation, respectively.

=item B<update>

I<update> is an optional boolean parameter.  If TRUE,
then idletasks() is called to update the image as it's being rotated.

=head1 EXAMPLE

 $photo->rotate_simple('l90');

=head1 AUTHOR

Stephen.O.Lidie@Lehigh.EDU

Copyright (C) 2001 - 2003, Steve Lidie. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 KEYWORDS

Photo, rotate

=cut
