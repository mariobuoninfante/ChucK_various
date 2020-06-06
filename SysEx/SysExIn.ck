public class SysExIn
{
	OscIn sysex;
	OscMsg sysexMsg;

	3001 => int port;
	sysex.port(port);
	sysex.addAddress("/sysex, s");	// receive sysex msg as strings
	int message[0];

	Event extEvent;


	// hook extEvent to an extarnal event used to drive the MAIN and then spork receive()
	function void initialize(Event e)
	{
		e @=> extEvent;
		spork ~ this.receive();
	}

	// infinite loop
	function void receive()
	{
		while(true)
		{
			sysex => now;
			while(sysex.recv(sysexMsg))
			{
				// get the sysex and pass it to 'message' array
				sysexMsg.getString(0) => string sysMsg;
				this.message.size(sysMsg.length());

				240 => this.message[0];
				for(0 => int c; c < sysMsg.length(); c++)
				{
					// Pd doesn't seem to send 240 and 247 - they are received as negative numbers
					if(sysMsg.charAt(c) >= 0)
					{
						sysMsg.charAt(c) => this.message[c];
					}
				}
				247 => this.message[this.message.size() - 1];

				extEvent.broadcast();
			}
		}
	}
}
