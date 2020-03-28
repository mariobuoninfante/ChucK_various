
MidiIn min;
// print list of available MIDI ports
string midi_port_name[0];
0 => int _c;

min.printerr(0);  // don't print error when trying to open port that doesn't exist
chout <= "\nMIDI IN PORTS\n---" <= IO.nl();
min.open(_c);
while( min.name() != "" )
{
    midi_port_name.size( midi_port_name.size() + 1 );
    min.name() => midi_port_name[_c];
    chout <= _c <= " " <=  midi_port_name[_c] <= IO.nl();
    _c++;
    min.open(_c);
}
min.printerr(1);  // now we can re-enable printerr
chout <= "---" <= IO.nl();
