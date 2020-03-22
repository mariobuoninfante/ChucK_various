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
    Math.fmod((c*2)/511., 1.) - 1 => array[c];
}
// change xrange
[128., 383] @=> Plot.xrange;
"sawtooth" => Plot.title;
Plot.plot(array);

// exponential waveform
for(0 => int c; c < 512; c++)
{
    Math.fmod((c*3)/511., 1.) => float x;
    x*x*x*x*x => array[c];
}
// change xrange and yrange
[0., 511] @=> Plot.xrange;
[-0.5, 0.5] @=> Plot.yrange;
// change draw type - check gnuplots types
"points" => Plot.draw_type;
"exp" => Plot.title;
Plot.plot(array);