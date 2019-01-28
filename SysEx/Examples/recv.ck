/*
SCRIPT USED IN 'example_recv.ck'
*/

SysExIn SYSEX_IN;

Event fromSysEx;  //

15 => int sysexSize;
int msg[sysexSize];

SYSEX_IN.initialize(fromSysEx);

// receive sysex
while(true)
{
	fromSysEx => now;

	// print incoming SysEx
	for(0 => int c; c < SYSEX_IN.message.size(); c++)
	{
		chout <= SYSEX_IN.message[c];
		chout <= " ";
	}

	chout <= IO.nl();
}
