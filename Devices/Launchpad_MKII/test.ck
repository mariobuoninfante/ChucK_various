/*
    Used in 'example.ck'
*/

Event trigger_from_LP;
// Launchpad MKII
LP_MKII LP;

LP.__doc__();                                       // print class documentation

LP.initialize();                                // initialize MIDI ports
LP.clear_surface();
spork ~ LP.midi_receiver( trigger_from_LP );    // shread that deals with incoming MIDI
spork ~ receive_from_LP();                      // function that prints received MIDI msgs

second => now;

//------------MAIN------------

while( true )
{
    // light up random pads with random colors
    Math.random2( 0, 79 ) => int random_pad;
    Math.random2( 1, 127 ) => int random_color;
    LP.light_single_pad( random_pad, random_color );

    second => now;
}


//-----------FUNCTIONS-------------

function void receive_from_LP()
{
    while( true )
    {
        /*
            when the device generates a MIDI message
            this function gets the raw MIDI values: LP.last_msg[] (returns the 3 raw bytes)
            and the (more) human readible alter-ego: LP.last_press[] (returns pad/button nr and value)
        */

        trigger_from_LP => now;
        <<< LP.last_msg[0], LP.last_msg[1], LP.last_msg[2] >>>;
        <<< "PAD nr: " + LP.last_press[0] + " || " + "VALUE: " + LP.last_press[1] >>>;
    }
}
