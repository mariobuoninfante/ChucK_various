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
        // In order to use this method chuck --caution-to-the-wind is needed
        Std.system("chuck PrintMidiInPorts");
    }

    function void connect_from_list()
    {
        // In order to use this method chuck --caution-to-the-wind is needed
        // print list of available MIDI ports and pick one from the console 
        ConsoleInput user_in;
        this.print_midi_ports();
        user_in.prompt( "Select MIDI port (decimal number):" ) => now;
        Std.atoi(user_in.getLine()) => int _port_id;
        this.connect(_port_id);
    }
}
