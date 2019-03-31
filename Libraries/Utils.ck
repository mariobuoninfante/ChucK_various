public class Utils
{
    // MIDI
    0x80 => int NOTE_OFF;
    0x90 => int NOTE_ON;
    0xA0 => int POLY_PRESS;
    0xB0 => int CTRL_CHANGE;
    0xC0 => int PROG_CHANGE;
    0xD0 => int CHAN_PRESS;
    0xE0 => int PITCHBEND;
    0x7B => int ALLNOTESOFF;
    0x00 => int CHANNEL;    // device MIDI channel
    0xF8 => int CLOCK;
    0xFA => int START;
    0xFB => int CONTINUE;
    0xFC => int STOP;

    // _MIDI

    second / samp => float SR;      // sample rate

    function float ms2samp( float x )
    {
        this.SR * x * 0.001 => x;

        return x;
    }

    function float samp2ms( float x )
    {
        x * ( 1000 / this.SR ) => x;

        return x;
    }

    function float bpm2ms( float x )
    {
        return( 60000 / x );
    }

    function float ms2bpm( float x )
    {
        return( 60000 / x );
    }
}
