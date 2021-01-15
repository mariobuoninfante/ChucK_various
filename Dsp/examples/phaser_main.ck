//--------------------
//-- PHASER-EXAMPLE --
//--------------------




//---------
//-- DSP --
//---------

5 => int polyphony;
SqrOsc Square[polyphony];
Phaser phaser[2];  // stereo phaser
Gain volume[2];

for (0 => int c; c < polyphony; c++)
{
    Square[c] => phaser[0];
    Square[c] => phaser[1];
}
phaser[0] => volume[0] => dac.left;
phaser[1] => volume[1] => dac.right;





//----------
//-- MAIN --
//----------

volume[0].gain(0.5);
volume[1].gain(0.5);


// play a chord with square oscils
[40, 43, 47, 50, 54] @=> int notes[];
for (0 => int c; c < polyphony; c++)
{
    Square[c].freq(Std.mtof(notes[c]));
    Square[c].gain(0.05);
}

// initialize() is mandatory - default waveform is "triangle"
// arg: 0. 4-stages; 1. 6-stages; 2. 8-stages;
phaser[0].initialize(1);
phaser[1].initialize(2);


phaser[0].set_waveform("triangle");  // other waveforms are: random, sine, ramp, ramp2 (inverse)
phaser[0].set_rate_hz(0.52);
phaser[0].set_depth(0.45);
phaser[0].set_feedback(0.65);

phaser[1].set_waveform("random");
phaser[1].set_rate_hz(0.5);
phaser[1].set_depth(0.25);
phaser[1].set_feedback(0.5);


// other rate-related methods are:
// rate()    - user-friendly, it accepts args in a range 0-1
// rate_ms() - set rate in msec
// ---
// all the "set" methods have their "get" equivalent



while (true)  second => now;

