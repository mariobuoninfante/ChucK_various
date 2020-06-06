public class Feedback_Delay extends Chubgraph
{
    /*
        simple delay with feedback
    */

    inlet => Gain dry => outlet;
    inlet => Gain wet => DelayL delay => outlet;
    delay => Gain f_back => delay;

    0       => float feedback;
    100::ms => dur delay_time;
    100     => float delay_msec;
    second  => dur delay_length;
    1000    => float delay_length_msec;
    1       => float dry_volume;
    1       => float wet_volume;

    delay.max( delay_length );
    delay.delay( delay_time );
    f_back.gain( feedback );

    function void set_dry( float vol )
    {
        /*
            dry volume
        */

        vol => dry_volume;
        dry.gain( dry_volume );
    }

    function void set_wet( float vol )
    {
        /*
            wet volume
        */

        vol => wet_volume;
        wet.gain( wet_volume );
    }

    function void set_delay_length( dur t )
    {
        /*
            set delay lenth using 'dur' arg
        */

        t => delay_length;
        delay.max( delay_length );
    }

    function void set_delay_length_msec( float t_msec )
    {
        /*
            set delay lenth using 'float' arg - time in msec
        */

        t_msec => delay_length_msec;
        delay_length_msec::ms => delay_length;
        delay.max( delay_length );
    }

    function void set_delay_time( dur t )
    {
        /*
            set delay time using 'dur' arg
        */

        t => delay_time;
        delay.delay( t );
    }

    function void set_delay_time_msec( float t_msec )
    {
        /*
            set delay time using 'float' arg - time in msec
        */

        t_msec          => delay_msec;
        delay_msec::ms  => delay_time;
        delay.delay( delay_time );
    }

    function void set_feedback( float f )
    {
        /*
            set feedback - (should be) in a range 0-1
        */

        f => feedback;
        f_back.gain( feedback );
    }

    function void __doc__()
    {
        /*
            print class methods
        */
        chout <= "----------------------------\n";
        chout <= "Feedback_Delay class methods\n";
        chout <= "----------------------------\n";
        chout <= "set_delay_length(dur t)              ||      set delay lenth using 'dur' arg\n";
        chout <= "set_delay_length_msec(float t)       ||      set delay lenth using 'float' arg - time in msec\n";
        chout <= "set_delay_time(dur t)                ||      set delay time using 'dur' arg\n";
        chout <= "set_delay_time_msec(float t)         ||      set delay time using 'float' arg - time in msec\n";
        chout <= "set_feedback(float f)                ||      set feedback - (should be) in a range 0-1\n";
        chout <= "set_dry(float v)                     ||      set dry volume\n";
        chout <= "set_wet(float v)                     ||      set wet volume\n";
        chout <= IO.nl();
    }
}
