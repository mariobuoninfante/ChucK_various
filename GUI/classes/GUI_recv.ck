public class GUI_recv
{
    /*
        receive OSC messages from Pure Data and trigger events in MAIN
    */

    OscTrigger trigger;
    OscIn osc_in;
    OscMsg msg_in;

    3001 			=> int osc_in_port;     // from Pd to ChucK

    function void initialize( OscTrigger t )
    {
        /*
            connect to Pd and to OscTrigger object that is used in GUI.ck
        */

        this.osc_in.port( this.osc_in_port );
        this.osc_in.listenAll();
        t @=> this.trigger;
        spork ~ this._run();
    }

    function void _run()
    {
        while( true )
        {
            this.osc_in => now;
            while( this.osc_in.recv( this.msg_in ) )
            {
                this.msg_in.getString(0) => string osc_string;
                if( this.msg_in.address == "/value" )
                {
                    osc_string => this.trigger.str;
                    this.msg_in.getFloat(1) => float x;
                    x => this.trigger.value;
                    this.trigger.broadcast();
                }
            }
        }
    }
}
