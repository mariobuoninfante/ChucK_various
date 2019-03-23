//----------GLOBAL-VARIABLES----------
OscTrigger osc_trigger;	// OSC msg from GUI_recv and to GUI objects
OscTrigger gui_msg;		// OSC msg from GUI objects
GUI_recv GUI_recv;		// OSC receiver
OscOut GUI_send;		// OSC sender
GUI Pan;
GUI Volume;
GUI Cutoff;

"localhost" 	=> string hostname;
3000 			=> int osc_out_port;		// from ChucK to Pd

GUI_send.dest( hostname, osc_out_port );
GUI_recv.initialize( osc_trigger );

Volume.initialize( osc_trigger, GUI_send, gui_msg );
Volume.display( 10, 25, "h_slider", "volume", 0, 127 );
Volume.set_value_passive(100);
Pan.initialize( osc_trigger, GUI_send, gui_msg );
Pan.display( 100, 150, "v_slider", "pan", -100, 100 );
Pan.set_value_passive(0);
Cutoff.initialize( osc_trigger, GUI_send, gui_msg );
Cutoff.display( 200, 150, "knob", "cutoff", 20, 1500 );
Cutoff.set_value_passive(150);

while( true )
{
	// get msg every time a GUI object is moved in Pd
	gui_msg => now;

	<<< gui_msg.str, gui_msg.value >>>;
}
