Plot Plot;

float array[512];

// cosine waveform
for(0 => int c; c < 512; c++)
{
    Math.cos(2*Math.PI*(c/511.)) => array[c];
}
Plot.plot(array);

// sawtooth waveform
for(0 => int c; c < 512; c++)
{
    Math.fmod((c*2)/511., 1.) - 1 => array[c];
}
Plot.plot(array);

// exponential waveform
for(0 => int c; c < 512; c++)
{
    Math.fmod((c*3)/511., 1.) => float x;
    x*x*x*x*x => array[c];
}
Plot.plot(array);