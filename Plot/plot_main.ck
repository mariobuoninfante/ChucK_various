Plot Plot;

float array[512];

// cosine waveform
for(0 => int c; c < 512; c++)
{
    Math.cos(2*Math.PI*(c/511.)) => array[c];
}

Plot.plot(array);
