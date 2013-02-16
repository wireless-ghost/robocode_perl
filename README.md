# robocode_perl

### Overview

This is a robocode written in perl. Inspired by original Robocode game designed for Java.
It is fun and easy way to write your fist lines of perl code.

The game consists of robots(tanks) fighting against each other in a step by step battle. 
Each robot can move, turn, scan for enemies and shoot them. Each robot has power which is
decreased when shot is generated or a hit taken. But if your shot hit another robot he will
lost the power of the shot and you will gain it.

### Installlation:

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
 
 **Issues with Tk on MacOS are noted!**

- Installing Perl::Tk::PhotoRotate
	- In lib directory you will find a folder Tk-PhotoRotate-1.1/
	- When inside Tk-PhotoRotate-1.1:
		- perl Makefile.PL
		- make
		- make test
		- make install


- Installing Perl::AnyEvent
	- In lib directory you will find a folder AnyEvent-7.04/
		- perl Makefile.PL
		- make
		- make test
		- make install

### Getting started

To start playing with robocode first you need write your own robots. Each robot is a perl package(class)
and is placed inside robots directory. The conventions is to name the file with the robot in capitalized
cammel case. The package name **must** be with the name of the file. **Otherwise it couldn't be loaded!**
Each robot should include as as a parant Tank package which is part of the robocode core and contains basic
functionallity for your robot. To do so in each robot you should include the following line:
     our @ISA = 'Tank';
Each robot should also implement two metods - `step()` and `enemy_spoted()`.
`step()` is invoked on each step of the game and `enemy_spoted()` whenever an enemy tank is in range
A scaffold for robot can be found in `robots/SamplaRobot.pm`.

In your code you can use: 

- `shoot()` merhod wich is inherited from Tank. This will generate a shot and decrease
your power with the shoot power
- `set_color()` - wich will set the color for your robot; avaliable options for now are: red, green and blue
- `get_power()` - returns the power of your robot; every generated shoot decreases your robots power with the power of the shoot
- `get_angle()` - return the angle of your robot between -360 && 360
- `turn_left(angle)` - turns your robot left with the angle passed as argument
- `turn_right(angle)` - turns your robot right with the angle passed as argument
- `move_forward(distance)` - moves your robot forward with the distance passed as argument; to move backward just use negative number for distance
- `get_x()` - return the x coordinate of your robot
- `get_y()` - reutrn the y coordinate of your robot
- `get_name()` - return the name of your robot
- `check_enemy(x, y)` - checks if there is an enemy on the coordinates passed as arguments
- `check_power()` - checks if your robot has power
- `set_shot_power()` - sets the power of the nex shot
- `get_shot_x()` - return the x coordinate of your shot
- `get_shot_y()` - return the y coordinate of your shot
 
