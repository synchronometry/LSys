/*
#  title: Context-Free Lindenmayer System
# author: Bruce Dawson
#   date: February 2, 2015
#
# L-SYSTEM LEGEND:
# ---------------
# A -> BA
# B -> A
#
#
*/

// L-SYSTEM ~~~~~~~~~~~~~~~~~
"A" @=> string axiom;
axiom @=> string str;
int axiom_list[0];
int axiom_temp[0];
string axiom_output;
//L-Sys Depth Level
int depthLevel; 
// L-SYSTEM ~~~~~~~~~~~~~~~~~

// MAUI ELEMENTS ~~~~~~~~~~~~~

400 => int guiWidth;
175 => int guiHeight;
MAUI_View control_view;
MAUI_Slider depthSlider;
MAUI_Button bang;
MAUI_Button reset;

// bang button
bang.pushType();
bang.size( 150, 80 );
bang.position( ((guiWidth/10)*1), 0 );
bang.name( "MUTATE!" );

// reset button
reset.pushType();
reset.size( 150, 80 );
reset.position( ((guiWidth/10)*5), 0 );
reset.name( "RESET!" );

// depth slider
0 => int sliderMin;
10 => int sliderMax;

depthSlider.range( sliderMin, sliderMax );
depthSlider.size( 200, depthSlider.height() );
depthSlider.position( 100, 100 );
depthSlider.precision(1);
depthSlider.value() $ int => depthLevel;
depthSlider.name( str );

// set view
control_view.addElement( bang );
control_view.addElement( reset );
control_view.addElement( depthSlider );
control_view.display();
control_view.size( guiWidth, guiHeight );
control_view.name( "Lindenmayer Chord Generator =>" );
// MAUI ELEMENTS ~~~~~~~~~~~~~

// MIDI SECTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

// number of the device to open (see: chuck --probe)
2 => int device;
1 => int moutPort;
// get command line
if( me.args() ) me.arg(0) => Std.atoi => device;
// the midi in, out, and midi message to be sent
MidiIn min;
MidiOut mout;
MidiMsg msg;

if( !mout.open(moutPort) )
{
    <<< "ERROR: MIDI Port did not open on port: ", moutPort >>>;
    me.exit();
};

//
// MIDI SECTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fun void guiBang()
{
    while( true )
    {
        // wait for the button to be pushed down
        bang => now;
        
        if( bang.state() != 0)
        {
            <<< "depth: ", depthLevel >>>;
            <<< "Axiom :         ", str >>>;
            depthSlider.value() $ int @=> depthLevel;
            mutateAxiom(depthLevel, str);
        }
    }   
}

fun void guiReset()
{
    while( true )
    {
        // wait for the button to be pushed down
        reset => now;
        
        depthSlider.value() $ int @=> depthLevel;
        axiom @=> str;
        
        depthSlider.name( str );
    }   
}

0 => float midi_max;
0 => float slider_scale;

fun void midi_msg_in()
{
    <<< "Awaiting MIDI Input..." >>>;
    // open the device
    if( !min.open( device ) ) me.exit();
    
    // print out device that was opened
    <<< "MIDI device:", min.num(), " -> ", min.name() >>>;
    // infinite time-loop
    while( true )
    {
        // wait on the event 'min'
        min => now;
        
        // get the message(s)
        while( min.recv(msg) )
        {
            //send midi msg
            mout.send(msg);   
            //receive CC change from slider
            if( msg.data1 == 191 )
            {
                //scale slider to 1.0 and turn slider with it 
                if( msg.data3 > midi_max ) { msg.data3 => midi_max; }
                
                (((msg.data3 / midi_max) $ float) * sliderMax) => slider_scale;
                depthSlider.value(slider_scale);
                axiom @=> str;
                depthSlider.name( str );
                depthSlider.value() $ int @=> depthLevel;
                mutateAxiom(depthLevel, str);
                
                //reset axiom if slider is at zero
                if( slider_scale == 0 ) { axiom @=> str; }
            }
            
            //iterate through l-sys, find B, make notes
            for( 0 => int i; i < str.length(); i++)
            {
                //Add note to midi message for every 'B'
                if( str.charAt( i ) == 'B' ) 
                {
                    msg.data2 + i => msg.data2;
                    mout.send(msg); 
                }
            }
        }
    }
}

//function for axiom mutation (core of l-sys)
fun void mutateAxiom( int depth, string str )
{
    for( 1 => int i; i <= depth; i++)
    {
        // analyze string into dynamic array
        for( 0 => int i; i < str.length(); i++)
        {
            if( str.charAt( i ) == 'A' ) { axiom_list << 'A'; }
            else { axiom_list << 'B'; }
        }
        
        //grow dynamic array according to depth level
        for( 0 => int i; i < axiom_list.size(); i++)
        {
            if( axiom_list[i] == 'A' )
            {
                axiom_temp << 'B';
                axiom_temp << 'A';
            }
            else
            {
                axiom_temp << 'A';
            }
        }
        
        for( 0 => int i; i < axiom_temp.size(); i++)
        {
            if( axiom_temp[i] == 65 )
            {
                "A" +=> axiom_output;
            }
            else "B" +=> axiom_output;
        }
        
        //output final axiom mutation
        axiom_output @=> str;
        
        // clear axiom output
        "" @=> axiom_output;
        
        axiom_list.clear();
        axiom_temp.clear();
        
        //print mutation output
        if( i == depth ){ <<< "Iteration #", i, ": ", str >>>; }
    }
    
    depthSlider.name( str );
    50::ms => now;
}

spork ~ midi_msg_in();
spork ~ guiBang();
spork ~ guiReset();

while( true )
{
    1::day => now;   
}