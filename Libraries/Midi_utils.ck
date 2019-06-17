public class Midi_utils
{
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

    function void print_midi_ports( MidiIn m_port )
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

    function void print_midi_ports( MidiOut m_port )
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
