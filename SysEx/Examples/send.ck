/*
SCRIPT USED IN 'example_send.ck'
*/

SysExOut SYSEX_OUT;

15 => int sysexSize;
int msg[sysexSize];

// send random sysex
while(true)
{
  240 => msg[0];
 	for(1 => int c; c < (sysexSize - 1); c++)
 	{
     Math.random2(0, 127) => msg[c];
  }
  247 => msg[sysexSize-1];

  SYSEX_OUT.send(msg);

  second => now;
}
