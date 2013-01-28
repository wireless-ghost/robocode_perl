#!perl -w
use lib 'blib/lib/Tk';
use Test;
use strict;

BEGIN { plan tests => 8 };

eval { require Tk; };
ok($@, "", "loading Tk module");

my $mw;
eval {$mw = Tk::MainWindow->new();};
ok($@, "", "can't create MainWindow");
ok(Tk::Exists($mw), 1, "MainWindow creation failed");
eval { $mw->geometry('+10+10'); };

eval "use Tk::PhotoRotate";
ok ($@, "", "Error creating PhotoRotate methods");

my $p;
eval { $p = $mw->Photo(-file => 'Icon.gif') };
ok ($@, "", "Error during Photo creation");

eval { $p->rotate(45) };
ok ($@, "", "Error rotating 45 degrees");
eval { $p->rotate_simple('flip') };
ok ($@, "", "Error rotating 180 degrees");

eval { $p->delete };
ok($@, "", "Can't delete Photo");

1;
