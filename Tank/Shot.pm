use Math::Trig;

package Shot;

$\ = "\n";

sub getX() {
	my ($self) = @_;
	print "shot x is: $self->{_x}";
	return $self->{_x};
}

sub getY() {
	my ($self) = @_;
	print "shot y is: $self->{_y}";
	return $self->{_y};
}

sub shoot() {
	print "Shooting!";
	my ($self, $angle) = @_;
	$self->{_x} += sin($angle);
	$self->{_y} += cos($angle);
	print "Shot at ($self->{_x}, $self->{_y})";
}

sub new{
	my $class = shift;
	my ($x, $y) = shift;
	my $self = {
		_x => $x,
		_y => $y
	};
	bless $self, $class;
	print "Shot Created";
	return $self;
}
1;
