// M_MidiIn.ck
// ---
// MIDI In class
// 
// @author         Mario Buoninfante
// @copyright      2019-20


public class M_MidiIn extends MidiIn
{
    "" => string device_name;
    -1 => int device_id;    // if opening MIDI port using int

    function int connect(string s)
    {
        s => this.device_name;

        if( !this.open(this.device_name) )
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            // me.exit();
            return 0;
        }
        this.num() => this.device_id;
        return 1;
    }

    function int connect(int p)
    {
        p => this.device_id;
        if( !this.open(this.device_id) )
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            // me.exit();
            return 0;
        }
        this.name() => this.device_name;
        return 1;
    }

    function MidiIn get_midi_port()
    {
        return this;
    }

    function void print_midi_ports()
    {
        // better not to use this since ChucK (1.4.0.0) leaves all the MIDI ports open
        // print list of available MIDI ports
        string midi_port_name[0];
        0 => int _c;

        this.printerr(0);  // don't print error when trying to open port that doesn't exist
        chout <= "\nMIDI IN PORTS\n---" <= IO.nl();
        this.open(_c);
        while( this.name() != "" )
        {
            midi_port_name.size( midi_port_name.size() + 1 );
            this.name() => midi_port_name[_c];
            chout <= _c <= " " <=  midi_port_name[_c] <= IO.nl();
            _c++;
            this.open(_c);
        }
        this.printerr(1);  // now we can re-enable printerr
        chout <= "---" <= IO.nl();
    }

    function void connect_from_list()
    {
        // better not to use this since ChucK (1.4.0.0) leaves all the MIDI ports open
        // print list of available MIDI ports and pick one from the console 
        ConsoleInput user_in;
        this.print_midi_ports();
        user_in.prompt( "Select MIDI port (decimal number):" ) => now;
        Std.atoi(user_in.getLine()) => int _port_id;
        this.connect(_port_id);
    }
}
