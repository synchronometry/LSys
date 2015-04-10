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
*/

"ABBA" @=> string str;
int axiom_list[0];
int axiom_temp[0];
string axiom_output;

5 => int depth; 

//depth level
for( 0 => int i; i <= depth; i++)
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
    <<< "Iteration #", i, ": ", str >>>;
}
