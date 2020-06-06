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


PulseGen PG => NRev reverb => Gain master => dac;

PG.indexInterpolationTime(200);  // index interpolation 't' in msec
reverb.mix(0.03);
master.gain(0.25);

float frequency;
float mod_index;

[36,38,39,41,43,44,46,48] @=> int midi_note[];
0 => int octave;

while(true)
{
    Math.random2f(0, 10) => mod_index;
    Math.random2(0, midi_note.size()-1) => int m_note;
    Math.random2(0, 2) * 12 => octave;
    Std.mtof(midi_note[m_note] + octave) => frequency;

    PG.freq(frequency);
    PG.index(mod_index);

    chout <= "Freq: " <= frequency <= " | Index: " <= mod_index <= IO.nl();
    
    250::ms => now;
}
