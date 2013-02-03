robocode_perl
=============

this is a robocode written in perl.

============

Installing:

	- To run this code you need perl installed (v5.14.2 or higher) and the following modules:
		- Tk 
		- Tk::PhotoRotate
		- AnyEvent
	
	If you don't have these modules - follow the instructions in order to install them.
	
	- Installing Perl::Tk module:
		- For Ubuntu users: sudo apt-get install perl-tk
		- Other:
			- perl -MCPAN -e shell
			- cpan> install Bundle::CPAN
			- cpan> reload cpan
			- cpan> install Tk
	
	- Installing Perl::Tk::PhotoRotate
		- In the current dir you will find a folder Tk-PhotoRotate-1.1/
		- When inside Tk-PhotoRotate-1.1:
			- perl Makefile.PL
			- make
			- make test
			- make install
	
	- Installing Perl::AnyEvent
		- In the current dir you will find a folder AnyEvent-7.04/
			- perl Makefile.PL
			- make
			- make test
			- make install
