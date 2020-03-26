// M_MidiOut.ck
// ---
// MIDI Out class
// 
// @author         Mario Buoninfante
// @copyright      2019-20 

public class M_MidiOut extends MidiOut
{
    MidiMsg _msg;

    "" => string device_name;
    -1 => int device_id;

    function void send(int msg[])
    {
        /*
            this deals with array of bytes
            useful to send sysex msg
        */
        for(0 => int c; c < msg.size(); c++)
        {
            if(c % 3 == 0)
            {
                msg[c] => this._msg.data1;
                if(c == msg.size() - 1)
                {
                    this.send(this._msg);
                }
            }
            else if(c % 3 == 1)
            {
                msg[c] => this._msg.data2;
                if(c == msg.size() - 1)
                {
                    this.send(this._msg);
                }
            }
            else if(c % 3 == 2)
            {
                msg[c] => this._msg.data3;
                this.send(this._msg);
            }
        }
        
    }

    function int connect(string s)
    {
        s => this.device_name;

        if(!this.open(this.device_name))
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            return 0;
        }
        this.num() => this.device_id;
        return 1;
    }

    function int connect(int p)
    {
        p => this.device_id;

        if(!this.open(this.device_id))
        {
            <<< "ISSUE WITH MIDI DEVICE!!!!!" >>>;
            return 0;
        }
        this.name() => this.device_name;
        return 1;
    }

    function void print_midi_ports()
    {
        // better not to use this since ChucK (1.4.0.0) leaves all the MIDI ports open
        // print list of available MIDI ports
        string midi_port_name[0];
        0 => int _c;

        this.printerr(0);  // don't print error when trying to open port that doesn't exist
        chout <= "\nMIDI OUT PORTS\n---" <= IO.nl();
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
