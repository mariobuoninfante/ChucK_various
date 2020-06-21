//-------------------------------
// UCtrl Class
// ---
// UGen gain and pan interpolator
// ------------------------------
// ------------------------------
// Mario Buoninfante - 2020
// mario.buoninfante@gmail.com
//-------------------------------



public class UCtrl
{
    // interpolations happen on different shred

    Shred gainInterp;
    Shred panInterp;
    3 => int rate;  // samples
    ms / samp => float sampInMsec;
    rate / sampInMsec => float coeff;
    
    // GAIN
    function void gain(UGen ugen, float target, float t)
    {
	if (gainInterp.done() == 0)
	{
	    if (gainInterp.id() != 0)
	    {
		Machine.remove(gainInterp.id());
	    }
	}
	spork ~ _gain(ugen, target, t) @=> gainInterp;
    }
    
    function void _gain(UGen ugen, float target, float t)
    {
	ugen.gain() => float current;
	target - current => float delta;
	(delta / t) * coeff => float steps;

	if (delta > 0)
	{
	    while (current < target)
	    {
		steps +=> current;
		if (current > target)
		{
		    target => current;
		}
		ugen.gain(current);
		rate::samp => now;
	    }
	}
	else if (delta < 0)
	{
	    while (current > target)
	    {
		steps +=> current;
		if (current < target)
		{
		    target => current;
		}
		ugen.gain(current);
		rate::samp => now;
	    }
	}
    }



    
    // PAN
    function void pan(Pan2 ugen, float target, float t)
    {
	if (panInterp.done() == 0)
	{
	    if (panInterp.id() != 0)
	    {
		Machine.remove(panInterp.id());
	    }
	}
	spork ~ _pan(ugen, target, t) @=> panInterp;
    }

    function void _pan(Pan2 ugen, float target, float t)
    {
	ugen.pan() => float current;
	target - current => float delta;
	(delta / t) * coeff => float steps;

	if (delta > 0)
	{
	    while (current < target)
	    {
		steps +=> current;
		if (current > target)
		{
		    target => current;
		}
		ugen.pan(current);
		rate::samp => now;
	    }
	}
	else if (delta < 0)
	{
	    while (current > target)
	    {
		steps +=> current;
		if (current < target)
		{
		    target => current;
		}
		ugen.pan(current);
		rate::samp => now;
	    }
	}
    }
}