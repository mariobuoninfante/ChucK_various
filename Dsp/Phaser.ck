public class Phaser extends Chugraph
{

    // 4-6-8 stages Phaser
    // -------------------
    // Copyright 2021 - Mario Buoninfante
    // mario.buoninfante@gmail.com


    
    //----------------------
    //-- MEMBER-VARIABLES --
    //----------------------

    PoleZero AP[0];
    Gain g;
    Gain fback;
    
    4 => int stages;
    0.99 => float MAX_FBACK;
    0.99 => float MAX_DEPTH;
    0.005 => float MIN_RATE;
    5 => float MAX_RATE;
    1000./MIN_RATE => float MIN_RATE_MS;
    1000./MAX_RATE => float MAX_RATE_MS;
    0 => float allpass;
    0.2 => float depth;
    0 => float rate;  // actual rate in Hz
    0 => float rate_t;  // rate in ms for _lfo()
    0 => float rate_ms; // rate in msec
    0 => float user_rate;  // rate from a user perspective (range 0,1 - this value gets scaled internally) 
    0 => float feedback;

    512 => int WAVESIZE;
    float sinewave[WAVESIZE];
    float trianglewave[WAVESIZE];
    float rampwave[WAVESIZE];
    float ramp2wave[WAVESIZE];
    float randwave[WAVESIZE];
    float waveform[WAVESIZE];  // waveform currently played

    

    
    //--------------------
    //-- MEMBER-METHODS --
    //--------------------

    function void initialize(int mode)
    {
	// 0. 4 stages
	// 1. 6 stages
	// 2. 8 stages

	if (mode == 1)       6 => stages;
	else if (mode == 2)  8 => stages;
	else                 4 => stages;
	
	PoleZero AllPass[stages] @=> AP;

	inlet => AP[0];
	inlet => g => outlet;
	
	for (0 => int c; c < (stages-1); c++)
	{
	    AP[c] => AP[c+1];
	}
	AP[stages-1] => outlet;
	AP[stages-1] => fback => AP[0];


	g.gain(0.5);
	set_rate(0.2);
	set_feedback(0.2);
	init_waves();
	spork ~ _lfo(1);		
    }
    
    
    function void init_waves()
    {
	float x;
	float rand_x;
	for (0 => int c; c < WAVESIZE; c++)
	{
	    c / WAVESIZE $ float => x;

	    // sine
	    (Math.sin(x * Math.TWO_PI) * 0.5) + 0.5 => sinewave[c];
	    
	    // triangle
	    if (c < (WAVESIZE/4))              x*2 + 0.5        => trianglewave[c];
	    else if (c < (WAVESIZE/2))         1 - (x*2 - 0.5)  => trianglewave[c];
	    else if (c < ((WAVESIZE/4)*3))     1-((x-0.25)*2)   => trianglewave[c];
	    else                               (x-0.75)*2       => trianglewave[c];

	    // ramp
	    x => rampwave[c];

	    // inverse ramp
	    1-x => ramp2wave[c];

	    // random
	    if (c % (WAVESIZE/16) == 0)  Math.random2f(0, 1) => rand_x;
	    rand_x => randwave[c];
	}

	// triangle is the default waveform
	trianglewave @=> waveform;
    }


    function void set_waveform(string wave)
    {
	if (wave == "sine")           sinewave @=> waveform;
	else if (wave == "triangle")  trianglewave @=> waveform;
	else if (wave == "ramp")      rampwave @=> waveform;
	else if (wave == "ramp2")     ramp2wave @=> waveform;
	else if (wave == "random")    randwave @=> waveform;
    }

    
    function void set_allpass(float x)
    {
	if (x < -1) -1 => x;
	else if (x > 1) 1 => x;
	x => allpass;
	for (0 => int c; c < stages; c++)
	{
	    AP[c].allpass(allpass);
	}
    }

    
    function float get_allpass()
    {
	return allpass;
    }

    
    function float set_depth(float d)
    {
	if (d < 0) 0 => d;
	else if (d > MAX_DEPTH) MAX_DEPTH => d;
	d => depth;
    }


    function void set_feedback(float fb)
    {
	if (fb < 0)                0 => feedback;
	else if (fb > MAX_FBACK)   MAX_FBACK => feedback;
	else                       fb => feedback;

	fback.gain(feedback);
    }
    

    function float get_feeback()
    {
	return feedback;
    }


    function void set_rate_ms(float r)
    {
	if (r > 0)
	{
	    if (r < MIN_RATE_MS)       MIN_RATE_MS => rate_ms;
	    else if (r > MAX_RATE_MS)  MAX_RATE_MS => rate_ms;
	    else                       r => rate_ms;

	    rate_ms / WAVESIZE => rate_t;
	    1000./rate_ms => rate;
	    Math.pow((rate - MIN_RATE)/(MAX_RATE - MIN_RATE), 0.25) => user_rate;
	}
	
	else  0 => rate => user_rate => rate_ms;
    }


    function float get_rate_ms()
    {
	return rate_ms;
    }


    function void set_rate_hz(float r)
    {
	if (r <= 0)
	    0 => rate => user_rate;
	else
	{
	    if (r > MAX_RATE)
	        MAX_RATE => rate;
	    else
	        r => rate;

	    (1000./rate) => rate_ms;
	    rate_ms / WAVESIZE => rate_t;
	    Math.pow((rate - MIN_RATE)/(MAX_RATE - MIN_RATE), 0.25) => user_rate;
	}
    }


    function float get_rate_hz()
    {
	return rate;
    }
    

    function void set_rate(float r)
    {
	// arg in a range 0,1
	
	if (r < 0)        0 => r;
	else if (r > 1)   1 => r;
	r => user_rate;
	r*r*r*r => r;
	if (r != 0)
	{
	    r * (MAX_RATE - MIN_RATE) + MIN_RATE => rate;
	    (1000./rate) => rate_ms;
	    rate_ms / WAVESIZE => rate_t;
	}
	else 0 => rate;
    }


    function float get_rate()
    {
	// return the user rate in a range 0,1
	// this value is internally scale and doesn't match the actual rate (ie freq in Hz)
	
	return user_rate;
    }


    function void _lfo(int x)
    {
	// modulate allpass coefficient
	// runs on a paralled shred

	0 => int c;
	0 => float x;
	
	while (true)
	{
	    if (rate != 0)
	    {
		for (0 => c; c < WAVESIZE; c++)
		{
		    MAX_DEPTH - depth + waveform[c]*depth => x;
		    set_allpass(-x);
		    
		    rate_t::ms => now;
		}
	    }
	    else  ms => now;
	}
    }
    
// _PHASER_END    
}
