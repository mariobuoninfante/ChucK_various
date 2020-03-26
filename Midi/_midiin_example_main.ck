// MIDI input example
// basic MIDI monitor

M_MidiIn min;
M_Msg msg;

// select MIDI in port
min.open(6);

while(true)
{
    min => now;
    while(min.recv(msg))
    {
        msg.print();
    }
}