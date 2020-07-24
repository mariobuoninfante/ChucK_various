// Pulse Generator
// ---
// based on Miller Puckette Pulse Train Generator
// from "The Theory and Technique of Electronic Music"
//
// PulseGen uses Clip and Line Chugins
// https://github.com/mariobuoninfante/ChucK_chugins
//
// Copyright 2020 - Mario Buoninfante
// mario.buoninfante@gmail.com


private class DCRemover extends Chubgraph
{
    inlet => Gain subtract => outlet;
    inlet => OnePole onepole  => subtract; 

    0.9995 => float p;
    subtract.op(2);
    onepole.pole(p);
    // for p > 0:
    //     onepole.pole(p)
    // is equivalent to:
    //     onepole.b0(1-p); onepole.a1(-p);
}

public class PulseGen extends Chubgraph
{
    // DSP

    Phasor phasor => Envelope line => Gain pOffset => Clip clip => SinOsc osc => DCRemover highpass => outlet;
    Step pStep => pOffset;

    pStep.next(-0.25);
    osc.sync(1);
    clip.range(-0.25, 0.75);
    line.target(1);
    line.time(0.01); // interpolation 't' in seconds
    
    


    // MEMBER VARIABLES

    0   => float frequency;
    0   => float mod_index;    
    10  => float index_interp;  // index interpolation 't' in msec
    phasor.freq(frequency);



    
    // MEMBER FUNCTIONS

    function void freq(float f)
    {
	// freq in Hz

	f => frequency;
	phasor.freq(frequency);
    }

    
    function void index(float i)
    {
	// this parameter can cause aliasing
	
	i => mod_index;
	if (mod_index < 0)
	{
	    line.target(1 - mod_index);
	}
	else
	{
	    line.target(1 + mod_index);
	}    
    }

    
    function void indexInterpolationTime(float ii)
    {
	// arg in msec

	ii => index_interp;
	line.time(index_interp * 0.001);
    }
}