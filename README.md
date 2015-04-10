# LSys
Lindenmayer System Chord Generator (ChucK v1.0)

Please install the latest chucK package from the princeton website.
This program requires MINIAUDICLE to run. 

Chuck:
http://chuck.cs.princeton.edu/

README:
This program transposes MIDI through from localhost's MIDI input, and outputs transposition to localhost's IAC driver.

The basic concept of L-Systems, and the numerous derivatives of an L-System, 
is that of string rewriting – rewriting given strings according to set parameters. “In 1968 Aristid Lindenmayer, 
a biologist, introduced a formal method for modeling the development of plants. Now called L-systems, Lindenmayer's
method is a type of rewriting system, a general tool for constructing complex objects by starting with a simple 
object and recursively replacing parts according to instructions provided by a set of rewriting rules.”

A typical use scenario begins with opening the project code with miniAudicle, an integrated development environment (IDE)
for software development with the chucK programming language. At this time, using miniAudicle to open the code is the only
publicly available way to display GUI elements within the chucK programming language. Using the GUI interface, axiom iteration
depth can be determined, which then determines which musical scale, chords, and chord progressions will be output via the user’s
local IAC Bus. 

Future Plans: 
  User parameter control for manipulating the chord progression will become available – allowing a user to 
“lock” a discovered chord progression, as well as move through the currently selected chord progression forward, backwards, 
forward-and-backwards, and random selection.
