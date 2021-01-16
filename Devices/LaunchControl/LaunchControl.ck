public class LaunchControl
{
    //-----------------------------------
    // TO BE USED WITH FACTORY TEMPLATE 1 
    //-----------------------------------

    
    //----------
    //-- MIDI --
    //----------
    
    MidiIn   input;
    MidiOut  output;
    MidiMsg  msg;
    MidiMsg  msg_out;

    
    "Launch Control MIDI 1" => string device_name;  // port name on Linux when device ID is 1
    if (!input.open(device_name) || !output.open(device_name))
    	chout <= "ISSUE OPENING THE MIDI DEVICE" <= IO.nl();


    
    //----------------------
    //-- MEMBER VARIABLES --
    //----------------------
    
    8                  => int MIDI_CH;     // 0-index (0-15)
    144                => int NOTE_ON;
    128                => int NOTE_OFF;
    176                => int CTRL_CH;
    NOTE_ON+MIDI_CH    => int PAD_MIDI_ON;
    NOTE_OFF+MIDI_CH   => int PAD_MIDI_OFF;
    CTRL_CH+MIDI_CH    => int CTRL_CH_MIDI;


    0 => int _flash_status;  // flash mode flag (OFF by default)
    string type;  // pad, knob, button
    int id;       // 0-n - in accord with "type"
    int value;
    [9, 10, 11, 12, 25, 26, 27, 28] @=> int pad_id[];
    
    [12, 13, 15, 29, 63, 62, 28, 60, 11, 59, 58, 56] @=> int color_values[];
    ["off", "red_low", "red_full", "amber_low", "amber_full",
    "yellow", "green_low", "green_full", "red_flash",
    "amber_flash", "yellow_flash", "green_flash"] @=> string color_names[];
    int colors[0];  // associative array

    // populate associative array
    for (0 => int c; c < color_values.size(); c++)
    {
	color_values[c] => colors[color_names[c]];
    }
    


    //--------------------
    //-- MEMBER METHODS --
    //--------------------

    function void _flash_mode_on()
    {
	// enable "flash mode"
	// this is called every time a pad/button is set
	// it can't be set once at the start up cause
	// we don't know when the MIDI port is ready (even when ChucK reports it's connected)
	// and putting an arbitraty wait doesn't seem really sensible!
	// so the first time the user sets a pad/button, this gets called first (and only once)
	
	if (!_flash_status)
	{
	    184 => msg_out.data1;
	    0   => msg_out.data2;
	    40  => msg_out.data3;
	    output.send(msg_out);
	    1 => _flash_status;
	}
    }


    function void set_pad(int id, string color)
    {
	_flash_mode_on();
	PAD_MIDI_ON     => msg_out.data1;
	pad_id[id & 7]  => msg_out.data2;
	colors[color]   => msg_out.data3;
	output.send(msg_out);
    }


    function void set_button(int id, string color)
    {
	// button_nr: 0-3 - from top-left to bottom-right

	_flash_mode_on();
	CTRL_CH_MIDI    => msg_out.data1;
	(id & 3) + 114  => msg_out.data2;
	colors[color]   => msg_out.data3;
	output.send(msg_out);
    }
    

    function void set(string type, int id, string color)
    {
	if (type == "pad")          set_pad(id, color);
	else if (type == "button")  set_button(id, color);
    }

    
    function void reset()
    {
	CTRL_CH_MIDI => msg_out.data1;
	0            => msg_out.data2;
	0            => msg_out.data3;
	output.send(msg_out);
	0 => _flash_status;  // because this method resets the flash mode as well
    }


    function void check_ctrl(int byte1, int byte2, int byte3)
    {
	// used in recv() this updates "id", "value" and "type" everytime
	// a MIDI msg is set by the Launchcontrol (ie user press a pad)
	
	if (byte1 == PAD_MIDI_ON || byte1 == PAD_MIDI_OFF)
	{
	    if (byte2 > 8 && byte2 < 13)
	    {
		byte2 - 9  => id;
		byte3      => value;
		"pad"      => type;
	    }
	    else if (byte2 > 24 && byte2 < 29)
	    {
		byte2 - 21 => id;
		byte3      => value;
		"pad"      => type;
	    }
	}

	else if (byte1 == CTRL_CH_MIDI)
	{
	    if (byte2 > 20 && byte2 < 29)
	    {
		byte2 - 21   => id;
		byte3        => value;
		"knob"       => type;
	    }
	    else if (byte2 > 40 && byte2 < 49)
	    {
		byte2 - 33  => id;
		byte3       => value;
		"knob"      => type;
	    }
	    else if (byte2 > 113 && byte2 < 118)
	    {
		byte2 - 114 => id;
		byte3       => value;
		"button"    => type;
	    }
	}
    }

    
    function void recv()
    {
	input => now;
	while (input.recv(msg))
	{
	    check_ctrl(msg.data1, msg.data2, msg.data3);
	}
    }
    
    //_LAUNCHCONTROL_END
}