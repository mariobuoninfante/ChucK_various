public class Midi_utils
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
    0xF8 => static int CLOCK;
    0xFA => static int START;
    0xFB => static int CONTINUE;
    0xFC => static int STOP;

    function static void print_midi_ports( MidiIn m_port )
    {
        string midi_port_name[0];
        0 => int _c;

        m_port.printerr(0);  // don't print error when trying to open port that doesn't exist
        m_port.open(_c);
        while( m_port.name() != "" )
        {
            midi_port_name.size( midi_port_name.size() + 1 );
            m_port.name() => midi_port_name[_c];
            <<< _c, midi_port_name[_c] >>>;
            _c++;
            m_port.open(_c);
        }
        m_port.printerr(1);  // now we can re-enable printerr
    }

    function static void print_midi_ports( MidiOut m_port )
    {
        string midi_port_name[0];
        0 => int _c;

        m_port.printerr(0);  // don't print error when trying to open port that doesn't exist
        m_port.open(_c);
        while( m_port.name() != "" )
        {
            midi_port_name.size( midi_port_name.size() + 1 );
            m_port.name() => midi_port_name[_c];
            <<< _c, midi_port_name[_c] >>>;
            _c++;
            m_port.open(_c);
        }
        m_port.printerr(1);  // now we can re-enable printerr
    }
}
