/*
* TODO create a "loop" function (random loop with "crush")
*/
//-----------------------------------------
//------------GLOBAL-VARIABLES-------------
//-----------------------------------------

second/samp => float SR;
0.166666667 => float twoDividedBy12;


//-----------------------------------------
//-----------------------------------------

SndBuf sample => Envelope env => NRev reverb => Gain mOut => dac;
dac => WvOut2 record => blackhole;
record.record(0);   // don't start recording

SndBuf groove => Envelope grooveEnv => mOut;

Shred GLITCH;
Shred SUB_GLITCH;

//---------------------PARAMETERS------------------------
75 => float bpm;   // main loop BPM
1 => int interrupter;   // mute or not main loop when glitch plays
"audio/drum_75.wav" => string grooveName;
"audio/drum_75.wav" => string fileName;
["8", "8T", "16", "16T", "32", "32T"] @=> string sync[]; // type of sync rates to use
0 => int randPitchMode; // glitch pitch mode: 0. octave pitch (-1,0,+1); 1. chromatic pitch (-12,+12)
25 => int playChance;   // chance that a SECTION is played
2 => int numberOfLoops;
25 => float reverbMix;  // reverb mix in a range 0-100
//-------------------------------------------------------

// check 'settings.txt'
me.dir() + "/settings.txt" => string filename;

FileIO settings;

settings.open( filename, FileIO.READ );

if( !settings.good() )
{
    cherr <= "can't open file: " <= filename <= " for reading..." <= IO.nl();
    me.exit();
}

string str;

while( settings.more() )
{
    settings => str;
    if(str == "#")
    {
        settings.readLine() => string intoTheVoid;
    }
    else
    {
        setParams(settings, str);
    }
}

// check if there are already 'export.wav' files in the folder and give a unique name to the recording
me.dir() + "export_1.wav" => string recordName;
FileIO guineaPig;
guineaPig.open(recordName, FileIO.BINARY);
1 => int guineaCounter;
while(guineaPig.good())
{
    guineaCounter++;
    me.dir() + "export_" + guineaCounter + ".wav" => recordName;
    guineaPig.open(recordName, FileIO.BINARY);
}
recordName => record.wavFilename;
chout <= "==============\n";
chout <= "EXPORT FILE NAME: " <= recordName <= IO.nl();

me.dir() + "audio/" + grooveName => grooveName;
me.dir() + "audio/" + fileName => fileName;
int fileSizeSamps;
float fileSizeMsec;
float playRate;
0.7 => float sampleAmp;
4 => int sections;  // number of SECTIONS to use in the main loop
float start[sections];
float end[sections];
float delta[sections];  // (end-start)
int startEnd;   // pointer for start[], end[] and delta[]
string selectedSync[sections];
1 => int crush;
0 => int midiPitch;
1 => float pitch;
[0.25, 0.375, 0.5, 0.75, 1., 1.5, 2., 3., 4., 6., 8., 12.] @=> float coefficient[];
["1", "1T", "2", "2T", "4", "4T", "8", "8T", "16", "16T", "32", "32T"] @=> string divisionName[];
float divisionValue[0]; // associative array (ie array["2T"] = 0.75)
// create an associative array (ie array["2T"] = 0.75)
for(0=>int c; c<12; c++)
{
    coefficient[c] => divisionValue[divisionName[c]];
}

reverb.mix(reverbMix * 0.002);
env.time(0.00);
groove.read(grooveName);
groove.rate(0);
sample.read(fileName);
sample.gain(sampleAmp);
sample.rate(0);
sample.samples() => fileSizeSamps;
sample.length()/ms => fileSizeMsec;
mOut.gain(0.7); // main volume
grooveEnv.time(0.005);
grooveEnv.target(1);

chout <= "==============\n";
chout <= "BPM: " <= bpm;
chout <= "\n==============\n";
chout <= IO.nl();

// create an 'n' number of SECTIONS to recall during the main loop
for(0=>int c; c<sections; c++)
{
    Math.random2f(0, 0.85) => start[c];
    sync[Math.random2(0, sync.size()-1)] => string r;
    r => selectedSync[c];
    start[c] + (timeDivision(bpm, divisionValue[r]) / fileSizeMsec) => end[c];
    Math.fabs(start[c]-end[c]) => delta[c];
}

1.5::second => now;

record.record(1);   // start recording
spork ~ playGroove(groove, 1, 1);

//---------------------------------
//--------------MAIN---------------
//---------------------------------
0 => int loopCounter;

while(loopCounter < numberOfLoops)
{
    SUB_GLITCH.exit();
    GLITCH.exit();
    spork ~ playGlitch(SUB_GLITCH, playChance, randPitchMode) @=> GLITCH;

    loopCounter++;

    <<< "MAIN LOOP" >>>;

    (bpm2ms(bpm)*4)::ms => now;
}

record.closeFile();

//--------------------------------------
//--------------FUNCTIONS---------------
//--------------------------------------
function void setPhase(SndBuf player, float pointA, float pointB, float t, float p, float crusher)
{
    /*
    * read SndBuf 'player' from 'pointA' to 'pointB' in a time 't' with a pitch 'p' and a crush level equal to 'crusher'
    * the 'crush' effect is obtained changin the 'scanRate', that can be considered as the 'sampling rate' of this algorithm
    * also the 'pitch' of the sample is changed in accord with 'scanRate'
    */

    SR * 0.001 => float sr;
    Math.max(Math.min(1000, crusher), 1) => float scanRate;
    Math.fabs(pointB - pointA) => float d;
    d / ((t*sr) / scanRate) => float steps;
    pointA => float x;
    scanRate * p => scanRate;   // calculate 'scanRate' in accord with pitch 'p'

    if(pointA < pointB)
    {
        while(x < pointB)
        {
            x + steps => x;
            player.phase(x);

            scanRate::samp => now;
        }

    }
    // if 'reverse'
    else if(pointA > pointB)
    {
        while(x > pointB)
        {
            x - steps => x;
            player.phase(x);

            scanRate::samp => now;
        }
    }
}

function float midiToRate(float x)
{
    return(Math.pow(2, -x/12.));
}

function float timeDivision(float tempo, float div)
{
    return(60000 / (tempo * div));
}

function float bpm2ms(float x)
{
    return(60000 / x);
}

function void playGroove(SndBuf playback, int rate, float amp)
{
    while(true)
    {
        playback.gain(amp);
        playback.pos(0);
        playback.rate(rate);

        playback.length() => now;
    }
}

function void playGlitch(Shred Sub, int likelihood, int pitchMode)
{
    float sectionLengthMsec;
    int envTrigger;

    while(true)
    {
        Math.random2(0,sections-1) => startEnd; // pick a random SECTION
        fileSizeMsec*delta[startEnd] => sectionLengthMsec;
        Math.random2(1,10) => crush;

        // octave pitch
        if(pitchMode == 1)
        {
            Math.random2(0,2) => int momR;
            if(momR == 0)
                -12 => midiPitch;
            else if(momR == 1)
                0 => midiPitch;
            else
                12 => midiPitch;
        }

        // chromatic pitch
        else if(pitchMode == 2)
        {
            Math.random2(-12,12) => midiPitch;
        }
        else
        {
            0 => midiPitch;
        }

        midiToRate(midiPitch) => pitch;
        spork ~ setPhase(sample, start[startEnd], end[startEnd], sectionLengthMsec, pitch, crush) @=> Sub;
        if(Math.random2(0,100) <= likelihood)
        {
            1 => envTrigger;
            if(interrupter)
            {
                grooveEnv.target(0);
            }
        }
        else
        {
            0 => envTrigger;
            if(interrupter)
            {
                grooveEnv.target(1);
            }
        }

        env.keyOn(envTrigger);


        <<< "PART: " + startEnd + " \t|| " + "SYNC: " + selectedSync[startEnd] + " \t|| " + "PITCH: " + midiPitch + " \t|| " + "CRUSH: " + crush + " \t|| TRIGGER: " + envTrigger  >>>;

        sectionLengthMsec::ms => now;
    }
}

function string checkParams(FileIO file, string param)
{
    "=" => string output;
    // skip the "=" in the text file and return the value that follows
    while(output == "=")
    {
        file => output;
    }

    return output;
}

function void setParams(FileIO file, string word)
{
    // assign values to global variables
    if(word == "mainLoop")
    {
        checkParams(file, word) => word;

        word => grooveName;
    }
    else if(word == "glitch")
    {
        checkParams(file, word) => word;

        word => fileName;
    }
    else if(word == "bpm")
    {
        checkParams(file, word) => word;

        word.toFloat() => bpm;
    }
    else if(word == "interrupter")
    {
        checkParams(file, word) => word;

        word.toInt() => interrupter;
    }
    else if(word == "pitchMode")
    {
        checkParams(file, word) => word;

        word.toInt() => randPitchMode;
    }
    else if(word == "randomness")
    {
        checkParams(file, word) => word;

        word.toInt() => playChance;
    }
    else if(word == "loops")
    {
        checkParams(file, word) => word;

        word.toInt() => numberOfLoops;
    }
    else if(word == "reverbMix")
    {
        checkParams(file, word) => word;

        word.toFloat() => reverbMix;
    }
}
