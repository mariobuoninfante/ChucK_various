public class DDelay extends Chugraph
{

    // DDelay - delay with filtered feedback chain
    // ---
    // this Chugraph can be unstable, especially
    // for high feedback values and narrow filter ranges 
    // ---
    //
    // Mario Buoninfante - copyright 2021
    // mario.buoninfante@gmail.com

    

    
    //---------
    //-- DSP --
    //---------
    
    inlet => Gain dry => outlet;
    inlet => Gain wet => DelayP delay => LPF lopass => HPF hipass => outlet;
    hipass => Gain f_back => delay;

    

    //----------------------
    //-- MEMBER VARIABLES --
    //----------------------

    150          => float MIN_CUTOFF;
    15000        => float MAX_CUTOFF;
    10000        => float MAX_LENGTH_MS;
    10::second   => dur   MAX_LENGTH;

    
    0       => float feedback;
    100::ms => dur delay_t;
    100     => float delay_t_ms;
    second  => dur delay_length;
    1000    => float delay_length_ms;
    1       => float dry_volume;
    1       => float wet_volume;
    20      => float interpolation;
    150     => float hi_cutoff;
    15000   => float lo_cutoff;
    1       => float filter_range;
    



    
    _init_();  // initialize instance



    
    //--------------------
    //-- MEMBER METHODS --
    //--------------------
    
    function void _init_()
    {
	// initialize instance
	
	delay.max(delay_length);
	delay.delay(delay_t);
	delay.window(interpolation::ms);
	f_back.gain(feedback);
	lopass.set(MAX_CUTOFF, 2);
	hipass.set(MIN_CUTOFF, 2);
	hipass.gain(0.5);
    }
	

    function void set_dry(float vol)
    {
	
        vol => dry_volume;
        dry.gain(dry_volume);
    }


    function float get_dry()
    {
	return dry_volume;
    }

    
    function void set_wet(float vol)
    {
        vol => wet_volume;
        wet.gain(wet_volume);
    }


    function float get_wet()
    {
	return wet_volume;
    }
    
    
    function void set_filter_range(float r)
    {
	if (r < 0)       0 => r;
	else if (r > 1)  1 => r; 
	1 - r => filter_range;

	filter_range*filter_range => float exp_range;
	exp_range*500 + MIN_CUTOFF    => hi_cutoff => hipass.freq;
	MAX_CUTOFF - exp_range*5000   => lo_cutoff => lopass.freq;
    }


    function float get_filter_range()
    {
	return filter_range;
    }

    
    function void set_length(dur t)
    {
	if (t < 0::ms)            0::ms      => t;
	else if (t > MAX_LENGTH)  MAX_LENGTH => t;
        t => delay_length;
	delay_length / ms => delay_length_ms;
        delay.max(delay_length);
    }


    function dur get_length()
    {
	return delay_length;
    }
    
    
    function void set_length_ms(float t_msec)
    {
	if (t_msec < 0)                   0 => t_msec;
	else if (t_msec > MAX_LENGTH_MS)  MAX_LENGTH_MS => t_msec;
        t_msec => delay_length_ms;
        delay_length_ms::ms => delay_length;
        delay.max(delay_length);
    }


    function float get_length_ms()
    {
	return delay_length_ms;
    }
    
    
    function void set_time(dur t)
    {
        t => delay_t;
	delay_t / ms => delay_t_ms;
        delay.delay(t);
    }


    function dur get_time()
    {
	return delay_t;
    }
    
    
    function void set_time_ms(float t_msec)
    {
        t_msec          => delay_t_ms;
        delay_t_ms::ms  => delay_t;
        delay.delay(delay_t);
    }


    function float get_time_ms()
    {
	return delay_t_ms;
    }
    
    
    function void set_feedback(float f)
    {
	if (f < -1)      -1 => f;
	else if (f > 1)   1 => f;
        f => feedback;
        f_back.gain(feedback);
    }


    function float get_feedback()
    {
	return feedback;	
    }
    
    
//_DDELAY_END    
}
