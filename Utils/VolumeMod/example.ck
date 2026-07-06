//-----------------------
// Pan modulation example
//-----------------------

@import "VolumeMod.ck"


VolumeMod panMod[2];
TriOsc oscil; 
Phasor lfo;

oscil => panMod[0] => dac.left;
oscil => panMod[1] => dac.right;

400 => float oscilFreq;
0.8 => float lfoFreq;
0.2 => float amp;

oscil.gain(amp);
oscil.freq(oscilFreq);
lfo.gain(0.5);
lfo.freq(lfoFreq);


panMod[0].connectMod(lfo);
panMod[1].connectMod(lfo);
panMod[1].setMode(1);  // set mode to either 0 (range: 0,1), or 1 (range: 1,0)
panMod[0].setRangeMode(1);
panMod[1].setRangeMode(1);


chout <= "\nFilter LFO example\n" <= IO.nl(); 

5::second => now;


<<< "disconnect LFO" >>>;

panMod[0].disconnectMod(lfo);
panMod[1].disconnectMod(lfo);

2::second => now;


