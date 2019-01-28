/*
    LAUNCHPAD MKII class
    It allows to send/receive MIDI to/from the device
*/

public class LP_MKII
{
    //--------GLOBAL-VARIABLES--------

    0x80 => int NOTE_OFF;
    0x90 => int NOTE_ON;
    0xA0 => int POLYTOUCH;
    0xB0 => int CTRL_CHANGE;
    0xC0 => int PGM_CHANGE;
    0xD0 => int AFTERTOUCH;
    0xE0 => int PITCHBEND;
    0x00 => int MIDI_CHANNEL;   // in a range 0-15


    // pads and right buttons when in SESSION layout
    [11, 12, 13, 14, 15, 16, 17, 18, 19,
     21, 22, 23, 24, 25, 26 ,27, 28, 29,
     31, 32, 33, 34, 35, 36, 37, 38, 39,
     41, 42, 43, 44, 45, 46, 47, 48, 49,
     51, 52, 53, 54, 55, 56, 57, 58, 59,
     61, 62, 63, 64, 65, 66, 67, 68, 69,
     71, 72, 73, 74, 75, 76, 77, 78, 79,
     81, 82, 83, 84, 85, 86, 87, 88, 89] @=> int SESSION_PADS[];    // NOTE_ON msg

    // top row buttons when in SESSION layout
    [104, 105, 106, 107, 108, 109, 110, 111] @=> int SESSION_TOP_BUTTONS[];   // CTRL_CHANGE msg

    /*
        create and initialize associative array to recall pad nr from pad ID
        (ie received MIDI note 11 returns pad nr 0 - first pad)
    */
    int SURFACE_BY_ID[0];
    for( 0 => int c; c < 80; c++ )
    {
        if( c < 72 )
        {
            c => this.SURFACE_BY_ID[ Std.itoa( this.SESSION_PADS[c] ) ];
        }
        else
        {
            c => this.SURFACE_BY_ID[ Std.itoa( this.SESSION_TOP_BUTTONS[ c - 72 ] ) ];
        }
    }

    int last_msg[3];        // contains the last (raw) message received from LP
    int last_press[2];      // last pad/button pressed and its value

    //---------MIDI----------

    MidiIn from_LP;
    MidiMsg msg_in;
    MidiOut to_LP;
    MidiMsg msg_out;

    // TODO add device name for different OSs
    "Launchpad MK2" => string device_name;  // this might be different on different OSs

    function void initialize()
    {
        /*
            initialize MIDI ports
        */

        if( !from_LP.open( device_name ) )
        {
            // MIDI INPUT
            chout <= "issue opening the MIDI device" <= IO.nl();
            me.exit();
        }
        else
        {
            // MIDI OUTPUT
            if( !to_LP.open( device_name ) )
            {
                chout <= "issue opening the MIDI device" <= IO.nl();
                me.exit();
            }
        }
    }

    function void light_single_pad( int pad_nr, int color )
    {
        /*
            light up pads and buttons by number - bottom to top, left to right
        */

        if( pad_nr < 72 )
        {
            // NOTE_ON msg
            this._send_msg( this.NOTE_ON + this.MIDI_CHANNEL, this.SESSION_PADS[ pad_nr ], color & 0x7F );
        }
        else
        {
            // CTRL_CHANGE msg
            this._send_msg( this.CTRL_CHANGE + this.MIDI_CHANNEL, this.SESSION_TOP_BUTTONS[ pad_nr - 72 ], color & 0x7F );
        }
    }

    function void clear_surface()
    {
        /*
            clear entire surface sending NOTE_ON and CTRL_CHANGE with data3 = 0
        */
        for( 0 => int c; c < 80; c++)
        {
            if( c < 72 )
            {
                // NOTE_ON msg
                this._send_msg( this.NOTE_ON + this.MIDI_CHANNEL, this.SESSION_PADS[ c ], 0 );
            }
            else
            {
                // CTRL_CHANGE msg
                this._send_msg( this.CTRL_CHANGE + this.MIDI_CHANNEL, this.SESSION_TOP_BUTTONS[ c - 72 ], 0 );
            }
        }
    }

    function void midi_receiver( Event trigger )
    {
        /*
            receive MIDI from LP - to run as separate shred
            it needs to be hooked up to an Event in MAIN
        */

        while( true )
        {
            from_LP => now;
            while( from_LP.recv( msg_in ) )
            {
                // update 'last_msg'
                msg_in.data1 => this.last_msg[0];
                msg_in.data2 => this.last_msg[1];
                msg_in.data3 => this.last_msg[2];

                // update 'last_press'
                SURFACE_BY_ID[ Std.itoa( msg_in.data2 ) ]   => this.last_press[0];
                msg_in.data3                                => this.last_press[1];


                trigger.broadcast();
            }
        }
    }

    function void _send_msg( int byte_1, int byte_2, int byte_3 )
    {
        /*
            send 3 bytes MIDI msg
        */
        byte_1 => msg_out.data1;
        byte_2 => msg_out.data2;
        byte_3 => msg_out.data3;
        to_LP.send( msg_out );
    }

    function void __doc__()
    {
        /*
            print all the class functions
        */

        chout <= "---------------------\n";
        chout <= "LP_MKII class methods\n";
        chout <= "---------------------\n";
        chout <= "initialize():                              initialize MIDI ports\n";
        chout <= "light_single_pad(int pad_nr, int color):   light up pad/button using pad nr (0-79) and color (0-127)\n";
        chout <= "clear_surface():                           clear entire surface sending NOTE ON and CC with value 0\n";
        chout <= "midi_receiver(Event e):                    to be run as separate shred - deals with incoming MIDI - triggers the Event with MIDI is received\n";

        chout <= IO.nl();
    }
}
