// EXAMPLE
// this scrips sends MIDI msg 

M_MidiOut mout;
M_Msg msg;

// select a MIDI out port from termoutal
mout.connect(0);

// NOTE ON: pitch, velocity, channel
msg.note_on(48, 120, 1);
mout.send(msg);
chout <= msg.type() <= IO.nl();
second => now;

// NOTE OFF: pitch, velocity, channel
msg.note_off(48, 0, 1);
mout.send(msg);
chout <= msg.type() <= IO.nl();
second => now;

// CTRL CHANGE: value, cc nr, channel
for(0 => int c; c < 128; c++)
{
    msg.cc(c, 10, 8);
    mout.send(msg);
    25::ms => now;
}
chout <= msg.type() <= IO.nl();
second => now;

// PITCHBEND: value, channel
for(0 => int c; c < 16384; c++)
{
    msg.pitchbend(c, 5);
    mout.send(msg);
    1::ms => now;
}
chout <= msg.type() <= IO.nl();
second => now;

// PROGRAM CHANGE: value, channel
for(0 => int c; c < 128; c++)
{
    msg.program_change(c, 5);
    mout.send(msg);
    25::ms => now;
}
chout <= msg.type() <= IO.nl();
second => now;

// POLYPHONIC AFTERTOUCH: value, note nr, channel
for(0 => int c; c < 128; c++)
{
    msg.polytouch(c, 60, 3);
    mout.send(msg);
    25::ms => now;
}
chout <= msg.type() <= IO.nl();
second => now;


// AFTERTOUCH: value, channel
for(0 => int c; c < 128; c++)
{
    msg.aftertouch(c, 15);
    mout.send(msg);
    25::ms => now;
}
chout <= msg.type() <= IO.nl();
second => now;


// REALTIME
msg.realtime("start");
mout.send(msg);
250::ms => now;
msg.realtime("clock");
mout.send(msg);
msg.realtime("stop");
mout.send(msg);
msg.realtime("continue");
mout.send(msg);
msg.realtime("reset");
mout.send(msg);
chout <= msg.type() <= IO.nl();
second => now;