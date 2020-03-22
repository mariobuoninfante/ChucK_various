Plot Plot;

float array[512];

// cosine waveform
for(0 => int c; c < 512; c++)
{
    Math.cos(2*Math.PI*(c/511.)) => array[c];
}
"cosine" => Plot.title;
Plot.plot(array);

// sawtooth waveform
for(0 => int c; c < 512; c++)
{
    2*Math.fmod((c*2)/511., 1.) - 1 => array[c];
}
// change xrange and yrange
[128., 383] @=> Plot.xrange;
[-0.5, 0.5] @=> Plot.yrange;
// change draw type - check gnuplots types
"points" => Plot.draw_type;
"sawtooth" => Plot.title;
Plot.plot(array);

// write custom script
"set ticslevel 0; splot (x**2)*(y**2)" => string script;
Plot.raw(script);