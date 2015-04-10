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
# to-do:
# ~ compare axiomScale against known scales to find "most similar" scale.
# ~ transpose current output to most similar found scale.
*/

// AXIOM:
// Major Scale: "AABAABABAABAABAABA" 
// Minor Scale: "AABABAABAABABAABAA"
// et cetera. Have fun. 
"B" @=> string axiom;

// SCALE ARRAYS
["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] @=> string scale[];
[60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71] @=> int midi_scale[];

// empty axiom scale for scale-checking
string known_axioms[0];
int axiom_scale_compare[0];
int axiom_scale_compare_temp[0];
0 => int scaleSelectionCounter;
int midi_transpose[8];

[0, 0, 0, 0, 0, 0, 0] @=> int scaleOptions[];
[0, 0, 0, 0, 0, 0, 0] @=> int axiom_scale[];
[0, 0, 0, 0, 0, 0, 0] @=> int axiom_scale_mout[];

// known scales
[2, 2, 1, 2, 2, 2, 1] @=> int major_scale[]; known_axioms << "major";
[2, 1, 2, 2, 1, 2, 2] @=> int minor_scale[]; known_axioms << "minor";
[2, 1, 2, 2, 1, 2, 2] @=> int natural_minor_scale[]; known_axioms << "natural minor";
[2, 1, 2, 2, 1, 3, 1] @=> int harmonic_minor_scale[]; known_axioms << "harmonic minor";
[2, 1, 2, 2, 2, 2, 1] @=> int melodic_minor_scale[]; known_axioms << "melodic minor";
[2, 2, 3, 2, 3, 2, 2] @=> int major_pentatonic_scale[]; known_axioms << "major pentatonic";
[3, 2, 2, 3, 2, 3, 2] @=> int minor_pentatonic_scale[]; known_axioms << "minor pentatonic";
[3, 2, 1, 1, 3, 2, 3] @=> int blues_scale[]; known_axioms << "blues scale ";
[2, 1, 2, 1, 1, 1, 2] @=> int minor_blues_scale[]; known_axioms << "minor blues scale ";
[2, 1, 1, 1, 1, 1, 2] @=> int major_blues_scale[]; known_axioms << "major blues scale ";
[2, 2, 2, 2, 2, 2, 2] @=> int augmented_scale[]; known_axioms << "augmented scale";
[2, 1, 2, 1, 2, 1, 2] @=> int diminished_scale[]; known_axioms << "diminished scale";
[1, 3, 1, 2, 1, 2, 2] @=> int phrygian_dominant_scale[]; known_axioms << "phrygian dominant scale";
[2, 1, 2, 2, 2, 1, 2] @=> int dorian_scale[]; known_axioms << "dorian scale";
[1, 2, 2, 2, 2, 1, 2] @=> int dorian_b2_scale[]; known_axioms << "dorian (b2) scale";
[1, 2, 2, 2, 1, 2, 2] @=> int phrygian_scale[]; known_axioms << "phrygian scale";
[2, 2, 2, 1, 2, 2, 1] @=> int lydian_scale[]; known_axioms << "Lydian scale";
[2, 2, 2, 1, 2, 1, 2] @=> int lydian_b7_scale[]; known_axioms << "Lydian (b7) scale";
[2, 2, 2, 2, 1, 2, 1] @=> int lydian_augmented_scale[]; known_axioms << "Lydian augmented scale";
[2, 2, 1, 2, 2, 1, 2] @=> int mixolydian_scale[]; known_axioms << "mixolydian scale";
[2, 2, 1, 2, 1, 2, 2] @=> int mixolydian_b13_scale[]; known_axioms << "mixolydian (b13) scale";
[1, 2, 2, 1, 2, 2, 2] @=> int locrian_scale[]; known_axioms << "locrian scale";
[2, 1, 2, 1, 2, 2, 2] @=> int locrian2_scale[]; known_axioms << "locrian #2 scale";
[2, 1, 2, 1, 2, 2, 2] @=> int super_locrian_scale[]; known_axioms << "super locrian scale";
[2, 1, 2, 2, 2, 2, 1] @=> int jazz_melodic_minor_scale[]; known_axioms << "jazz melodic minor scale";
[2, 1, 2, 1, 2, 1, 2] @=> int whole_half_diminished_scale[]; known_axioms << "whole half diminished scale";
[1, 3, 2, 2, 2, 1, 1] @=> int enigmatic_scale[]; known_axioms << "enigmatic scale";
[1, 3, 1, 2, 1, 3, 1] @=> int double_harmonic_scale[]; known_axioms << "double harmonic scale";
[2, 1, 3, 1, 1, 3, 1] @=> int hungarian_scale[]; known_axioms << "hungarian scale";
[1, 3, 1, 1, 2, 3, 1] @=> int persian_scale[]; known_axioms << "persian scale";
[2, 2, 1, 1, 2, 2, 2] @=> int arabian_scale[]; known_axioms << "arabian scale";
[1, 4, 2, 1, 4, 1, 4] @=> int japanese_scale[]; known_axioms << "japanese scale";
[2, 3, 2, 3, 2, 2, 3] @=> int egyptian_scale[]; known_axioms << "egyptian scale";
[2, 1, 4, 1, 4, 2, 1] @=> int hirajoshi_scale[]; known_axioms << "hirajoshi scale";


//grow scaling comparison variable 
for( 0 => int i; i < known_axioms.size(); i++ )
{ 
    axiom_scale_compare << 0;
    <<< "axioms ", i, ": ", known_axioms[i] >>>; 
}

<<< "size: ", axiom_scale_compare.size() >>>;

// L-SYSTEM ~~~~~~~~~~~~~~~~~
axiom @=> string str;
int axiom_list[0];
int axiom_temp[0];
string axiom_output;
int depthLevel; 
int scaleChoice;
string scaleName;

// counter for scale checking function. 
0 => int scaleCounter;


// midi / gui variables
0 => float midi_max;
0 => float slider_scale;

// L-SYSTEM ~~~~~~~~~~~~~~~~~

// MAUI ELEMENTS ~~~~~~~~~~~~~

400 => int guiWidth;
175 => int guiHeight;
MAUI_View control_view;
MAUI_Slider scaleSlider;
MAUI_Slider depthSlider;
MAUI_Button bang;
MAUI_Button reset;
MAUI_Button scaleButton;

// bang button
bang.pushType();
bang.size( 150, 60 );
bang.position( ((guiWidth/10)*1), 25 );
bang.name( "MUTATE!" );

// reset button
reset.pushType();
reset.size( 150, 60 );
reset.position( ((guiWidth/10)*5), 25 );
reset.name( "RESET!" );

// scale button / label
scaleButton.pushType();
scaleButton.size( 310, 55 );
scaleButton.position( (guiWidth/10), 0 );
scaleButton.name( "Chord: Base" );

// depth slider
0 => int sliderMin;
15 => int sliderMax;

scaleSlider.range( 0, 6 );
scaleSlider.size( 200, depthSlider.height() );
scaleSlider.position( 100, 50 );
scaleSlider.value() $ int => scaleChoice;
scaleSlider.precision(1);

depthSlider.range( sliderMin, sliderMax );
depthSlider.size( 200, depthSlider.height() );
depthSlider.position( 100, 100 );
depthSlider.precision(1);
depthSlider.value() $ int => depthLevel;
depthSlider.name( str );

// set view
control_view.addElement( bang );
control_view.addElement( reset );
control_view.addElement( scaleButton );
control_view.addElement( depthSlider );
control_view.addElement( scaleSlider );
control_view.display();
control_view.size( guiWidth, guiHeight );
control_view.name( "Lindenmayer Chord Generator =>" );
// MAUI ELEMENTS ~~~~~~~~~~~~~

// MIDI SECTION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

// number of the device to open (see: chuck --probe)
3 => int device;
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

// FUNCTIONS
fun int findTone( string key )
{
    for( 0 => int i; i < scale.size(); i++)
    {
        if( key == scale[i] ){ return i; }
    }
}

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
            // compare axiom against known scales
            scaleCheck();   
            
            //receive CC change from slider
            if( msg.data1 == 191 && msg.data2 == 27 )
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
                if( slider_scale == 0 ) 
                { 
                    axiom @=> str;
                    <<< "Axiom :         ", str >>>;
                    [0, 0, 0, 0, 0, 0, 0] @=> axiom_scale;
                    0 @=> scaleCounter;
                }
            }
            
            // scale Slider
            if( msg.data1 == 191 && msg.data2 == 91 )
            {
                //scale slider to 1.0 and turn slider with it 
                if( msg.data3 > midi_max ) { msg.data3 => midi_max; }
                
                (((msg.data3 / midi_max) $ float) * sliderMax) => slider_scale;
                scaleSlider.value(slider_scale) $ int => int scaleValue;
                // <<< "Chosen Scale: ", known_axioms[scaleOptions[scaleValue]] >>>;
                setScale( scaleOptions[scaleValue] );
            }
            
            // send out transposed midi notes
            if( msg.data1 != 191 ){ chordTranspose( depthLevel ); }
        }
    }
}

// transpose chord out according to current scale.
fun void chordTranspose( int itr )
{
    // scale array axiom_scale_mout[i]
    
    // base chord
    if( itr <= 1 ){ mout.send(msg); scaleButton.name( "Chord: Base" ); }
    
    // fifth chord
    else if( itr == 2 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1] + axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        scaleButton.name( "Chord: Fifth Chord" );
    }
    
    // triad chord
    else if( itr == 3 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        scaleButton.name( "Chord: Triad Chord" );
    }
    
    // seventh chord
    else if( itr == 4 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // seventh
        scaleButton.name( "Chord: Seventh Chord" );
    }
    
    // ninth chord
    else if( itr == 5 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // seventh
        (axiom_scale_mout[6] + axiom_scale_mout[0]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // nineth
        scaleButton.name( "Chord: Nineth Chord" );
    }
    
    // eleventh chord
    else if( itr == 6 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // seventh
        (axiom_scale_mout[6] + axiom_scale_mout[0]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // nineth
        (axiom_scale_mout[1] + axiom_scale_mout[2]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // eleventh
        scaleButton.name( "Chord: Eleventh Chord" );
    }
    
    
    // thirteenth chord
    else if( itr == 7 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // seventh
        (axiom_scale_mout[6] + axiom_scale_mout[0]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // nineth
        (axiom_scale_mout[1] + axiom_scale_mout[2]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // eleventh
        (axiom_scale_mout[3] + axiom_scale_mout[4]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // thirteenth
        scaleButton.name( "Chord: Thirteenth Chord" );
    }
    
    // added nineth chord
    else if( itr == 8 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5] + axiom_scale_mout[6] + axiom_scale_mout[0]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // nineth
        scaleButton.name( "Chord: Added Nineth Chord" );
    }
    
    // sus chord
    else if( itr == 9 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1] + axiom_scale_mout[2]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fourth
        (axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        scaleButton.name( "Chord: Sus Chord" );
    }
    
    // sus7 chord
    else if( itr == 10 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1] + axiom_scale_mout[2]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fourth
        (axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // seventh
        scaleButton.name( "Chord: Sus7 Chord" );
    }
    
    // sixth chord
    else if( itr == 11 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // sixth
        scaleButton.name( "Chord: Sixth Chord" );
    }
    
    // sixth/nineth chord
    else if( itr == 12 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // sixth
        (axiom_scale_mout[5] + axiom_scale_mout[6] + axiom_scale_mout[0]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // nineth
        scaleButton.name( "Chord: Sixth / Nineth Chord" );
    }
    
    // sixth/nineth chord
    else if( itr >= 13 ){ 
        mout.send(msg); // root
        (axiom_scale_mout[0] + axiom_scale_mout[1]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // third
        (axiom_scale_mout[2] + axiom_scale_mout[3]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // fifth
        (axiom_scale_mout[4] + axiom_scale_mout[5] + axiom_scale_mout[6] + axiom_scale_mout[0] + axiom_scale_mout[1] + axiom_scale_mout[2]) +=> msg.data2; Math.random2(64, 127) => msg.data3; mout.send(msg); // eleventh
        scaleButton.name( "Chord: Added Eleventh Chord" );
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
        
        if( str.length() > 15 )
        {
            if( i == depth ){ <<< "Iteration #", i, ": ", str.substring( 0, 15) >>>; }
        }
        else 
        {
            if( i == depth ){ <<< "Iteration #", i, ": ", str >>>; } 
        }
    }
    
    depthSlider.name( str );
    50::ms => now;
}

fun void scaleCheck()
{
    // Counter reset:
    // this allows us to check any axiom iteration for chord similarities, 
    // without the need of manually resetting the slider to position 0 each attempt.
    [0, 0, 0, 0, 0, 0, 0] @=> axiom_scale;
    0 @=> scaleCounter;
    
    for( 0 => int n; n < midi_scale.size(); n++)
    {
        if( msg.data2 == midi_scale[n]  && msg.data3 == 0)
        {
            for( 0 => int i; i < str.length(); i++)
            {
                if( axiom_scale.size() > scaleCounter)
                {
                    if( str.charAt( i ) == 'A' ) 
                    { 
                        // <<< "counter: ", scaleCounter >>>;
                        <<< " \n---------- AXIOM VALUES ----------\n ", "" >>>;
                        axiom_scale[scaleCounter]++;                  
                        for( 0 => int x; x < axiom_scale.size(); x++)
                        {
                            <<< "Value of axiom scale position ", x, ": ", axiom_scale[x] >>>;
                        }
                        
                    }
                    else 
                    { 
                        scaleCounter++; 
                    }
                }
            }
        }
    }
    
    // check axiom scale against known scales
    int temp_largest_scale;
    int largest;
    
    if(msg.data1 != 191 ){ <<< "\n---------- Scale Options ----------\n", "" >>>; }
    for( 0 => int x; x < axiom_scale.size(); x++)
    {
        0 @=> largest;
        for( 0 => int x; x < axiom_scale_compare.size(); x++)
        {
            if( x == 1 )
            { 
                if( axiom_scale_compare[x] > temp_largest_scale )
                {
                    axiom_scale_compare[x] => temp_largest_scale;
                    temp_largest_scale => largest;
                }
                
                if( msg.data3 == 0 )
                {                   
                    <<< "Scale Option #", scaleSelectionCounter, ": ", known_axioms[axiom_scale_compare[largest]] >>>; 
                    if( scaleSelectionCounter < 6 )
                    {
                        scaleSelectionCounter++;
                        axiom_scale_compare[largest] @=> scaleOptions[scaleSelectionCounter];
                    }
                    else 
                    {
                        0 => scaleSelectionCounter;
                        axiom_scale_compare[largest] @=> scaleOptions[scaleSelectionCounter];
                    }
                }
            }
            0 @=> axiom_scale_compare[x]; 
            0 @=> temp_largest_scale;
        }
        
        // See current axiom scale array       
        for( 0 => int y; y < axiom_scale_compare.size(); y++)
        {
            if( axiom_scale[x] == major_scale[x]                 ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == minor_scale[x]                 ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == natural_minor_scale[x]         ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == harmonic_minor_scale[x]        ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == melodic_minor_scale[x]         ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == major_pentatonic_scale[x]      ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == minor_pentatonic_scale[x]      ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == blues_scale[x]                 ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == minor_blues_scale[x]           ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == major_blues_scale[x]           ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == augmented_scale[x]             ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == diminished_scale[x]            ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == phrygian_dominant_scale[x]     ) axiom_scale_compare[y]++; 
            if( axiom_scale[x] == dorian_scale[x]                ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == dorian_b2_scale[x]             ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == phrygian_scale[x]              ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == lydian_scale[x]                ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == lydian_b7_scale[x]             ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == lydian_augmented_scale[x]      ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == mixolydian_scale[x]            ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == mixolydian_b13_scale[x]        ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == locrian_scale[x]               ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == locrian2_scale[x]              ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == super_locrian_scale[x]         ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == jazz_melodic_minor_scale[x]    ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == whole_half_diminished_scale[x] ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == enigmatic_scale[x]             ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == double_harmonic_scale[x]       ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == hungarian_scale[x]             ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == persian_scale[x]               ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == hungarian_scale[x]             ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == japanese_scale[x]              ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == egyptian_scale[x]              ) axiom_scale_compare[y]++;
            if( axiom_scale[x] == hirajoshi_scale[x]             ) axiom_scale_compare[y]++;
        }
    }
}
fun void setScale( int scale )
{
    // EXAMPLE: setScale( scaleOptions[scaleValue] );
    [0, 0, 0, 0, 0, 0, 0] @=> axiom_scale_mout;
    scaleSlider.name( known_axioms[scale] );
    
    for( 0 => int i; i < axiom_scale_mout.size(); i++ )
    {
        if( scale == 0  ){ major_scale[i] =>axiom_scale_mout[i]; }       
        if( scale == 1  ){ minor_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 2  ){ natural_minor_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 3  ){ harmonic_minor_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 4  ){ melodic_minor_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 5  ){ major_pentatonic_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 6  ){ minor_pentatonic_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 7  ){ blues_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 8  ){ minor_blues_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 9  ){ major_blues_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 10 ){ augmented_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 11 ){ diminished_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 12 ){ phrygian_dominant_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 13 ){ dorian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 14 ){ dorian_b2_scale [i]=>axiom_scale_mout[i]; }
        if( scale == 15 ){ phrygian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 16 ){ lydian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 17 ){ lydian_b7_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 18 ){ lydian_augmented_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 19 ){ mixolydian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 20 ){ mixolydian_b13_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 21 ){ locrian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 22 ){ locrian2_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 23 ){ super_locrian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 24 ){ jazz_melodic_minor_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 25 ){ whole_half_diminished_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 26 ){ enigmatic_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 27 ){ double_harmonic_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 28 ){ hungarian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 29 ){ persian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 30 ){ hungarian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 31 ){ japanese_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 32 ){ egyptian_scale[i] =>axiom_scale_mout[i]; }
        if( scale == 33 ){ hirajoshi_scale[i] =>axiom_scale_mout[i]; }
    }
}

spork ~ midi_msg_in();
spork ~ guiBang();
spork ~ guiReset();

while( true ){ 1::day => now; }