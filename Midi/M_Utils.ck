// M_Utils.ck
// ---
// MIDI Utilities
// 
// @author         Mario Buoninfante
// @copyright      2019-20 


public class M_Utils
{
    0x80 => static int NOTE_OFF;
    0x90 => static int NOTE_ON;
    0xA0 => static int POLY_PRESS;
    0xB0 => static int CTRL_CHANGE;
    0xC0 => static int PROG_CHANGE;
    0xD0 => static int CHAN_PRESS;
    0xE0 => static int PITCHBEND;
    0x7B => static int ALLNOTESOFF;
    0x00 => static int CHANNEL;    // device MIDI channel
    0xF0 => static int SYSEX_START;
    0xF7 => static int SYSEX_END;
    0xF8 => static int CLOCK;
    0xFA => static int START;
    0xFB => static int CONTINUE;
    0xFC => static int STOP;
    0xFE => static int ACTIVE_SENSING;  // ChucK has this disable by default
    0xFF => static int RESET;
}

// create an instance of the class to initialize the class members
// see 'class constructors' here: https://chuck.cs.princeton.edu/doc/language/class.html#intro
M_Utils _M_Utils;