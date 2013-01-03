use Tk;

# Main Window
my $mw = new MainWindow;

my $ent = $mw -> Entry() -> pack();
my $but = $mw -> Button(-text => "Push Me", -command =>\&push_button);

$but -> pack();

MainLoop;

#This is executed when the button is pressed 
sub push_button {
  $ent -> insert( 'end', "Hello" );
}
