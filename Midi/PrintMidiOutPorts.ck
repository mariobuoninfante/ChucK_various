
MidiOut mout;
// print list of available MIDI ports
string midi_port_name[0];
0 => int _c;

mout.printerr(0);  // don't print error when trying to open port that doesn't exist
chout <= "\nMIDI OUT PORTS\n---" <= IO.nl();
mout.open(_c);
while( mout.name() != "" )
{
    midi_port_name.size( midi_port_name.size() + 1 );
    mout.name() => midi_port_name[_c];
    chout <= _c <= " " <=  midi_port_name[_c] <= IO.nl();
    _c++;
    mout.open(_c);
}
mout.printerr(1);  // now we can re-enable printerr
chout <= "---" <= IO.nl();
