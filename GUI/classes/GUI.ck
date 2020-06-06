public class GUI
{
    /*
        GUI element
        OSC msg to and from Pd graphical objects
    */

    OscOut 			osc_out;      // connected to MAIN OscOut
    OscTrigger		trigger;      // from GUI_recv.ck
    OscTrigger      to_main;      // talk to MAIN OscTrigger

    // DEFAULT_PARAMS
    0 				=> float value;
    20 				=> int xpos;
    20 				=> int ypos;
    "test" 			=> string obj_name;
    0 				=> int rangemin;
    127 			=> int rangemax;
    // _DEFAULT_PARAMS

    "/ChucK"		=> string osc_start;
    ["h_slider", "v_slider", "knob"] @=> string obj_types[];
    string obj_type;

    function void initialize( OscTrigger from_Pd, OscOut to_Pd, OscTrigger main_trig )
    {
        // connect obj to MAIN OscTrigger and OscOut
        from_Pd	    @=> this.trigger;
        to_Pd 		@=> this.osc_out;
        main_trig   @=> this.to_main;
    }

    function void display( int x, int y, string type, string name, int rmin, int rmax )
    {
        // create the GUI object
        this.osc_out.start( osc_start + "/create" );
        this.osc_out.add( x ); 		x => this.xpos;
        this.osc_out.add( y );		y => this.ypos;
        this.osc_out.add( type );	type => this.obj_type;
        this.osc_out.add( name );	name => this.obj_name;
        this.osc_out.add( rmin );	rmin => this.rangemin;
        this.osc_out.add( rmax ); 	rmax => this.rangemax;
        this.osc_out.send();
        spork ~ this._run();
    }

    function void set_value( float x )
    {
        // updated GUI object value
        x => this.value;
        this.osc_out.start( osc_start + "/value" );
        this.osc_out.add( this.obj_name );
        this.osc_out.add( this.value );
        this.osc_out.send();
    }

    function void set_value_passive( float x )
    {
        // updated GUI object value without making it send any OSC msg
        x => this.value;
        this.osc_out.start( osc_start + "/value_passive" );
        this.osc_out.add( this.obj_name );
        this.osc_out.add( this.value );
        this.osc_out.send();
    }

    function float get_value()
    {
        // get object value
        return this.value;
    }

    function void _run()
    {
        // receive messages from Pd on a separate shred
        while( true )
        {
            this.trigger => now;
            if( this.trigger.str == this.obj_name )
            {
                this.trigger.value  => this.to_main.value;
                this.trigger.str    => this.to_main.str;
                this.to_main.broadcast();
            }
        }
    }
}
