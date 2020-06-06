public class SysExOut
{
	OscOut sysex;

	3000 => int port;
	sysex.dest("localhost", port);

	function void send(int msg[])
	{
		sysex.start("/sysex/");
	    for(0 => int c; c < msg.size(); c++)
	    {
	      	sysex.add(msg[c]);
	    }
	    sysex.send();
	}
}
