SndBuf2 sample => blackhole;  // used to load the audio file

// biquad coeffs in the form of [a1, a2, b0, b1, b2]
[-1.69065929318241, 0.73248077421585, 1.53512485958697, -2.69169618940638, 1.19839281085285] @=> float shelving_coeffs[];
[-1.99004745483398, 0.99007225036621, 1.0, -2.0, 1.0]                                        @=> float hipass_coeffs[];
ms/samp => float samps_per_ms;
-70     => float abs_threshold;  // absolute threshold in LKFS - Loudness K-weighted Full Scale
float rel_threshold;
float LUFS;
string filename;  // filename must contain the file extention - ie. my_file.wav
float wavefile[];


// get filename and load the file
if (!fetch_filename(filename))
{
    chout <= "Please try again and make sure you pass the name of the audio file to analyze as argument\n\tie. chuck main.ck:my_file.wav (include the file extention)\nthe file must live in the /audio folder" <= IO.nl();
    me.exit();
}
me.dir() + "audio/" + filename => sample.read;

// check the audio file is there
if (sample.samples() == 0)
{
        chout <= "\nIssue loading the audio file (eg file not in the ./audio folder)\n" <= IO.nl();
    me.exit();
}

sample.rate(0);
sample.pos(0);




//----------------
//-- PROCESSING --
//----------------

chout <= "checking audio file" <= IO.nl();
sample_to_array(sample) @=> wavefile;  // put audio sample in an array
chout <= "K-frequency weighting stage" <= IO.nl();
biquad(wavefile, shelving_coeffs);
biquad(wavefile, hipass_coeffs);

chout <= "absolute threshold stage" <= IO.nl();
gating_blocks(wavefile, abs_threshold) - 10 => rel_threshold;

chout <= "relative threshold stage" <= IO.nl();
gating_blocks(wavefile, rel_threshold) => LUFS;

chout <= filename <= " " <= LUFS <= " LUFS" <= IO.nl();



//---------------
//-- FUNCTIONS --
//---------------

function int fetch_filename(string name)
{
    if (me.args() > 0)
    {
	me.arg(0) => name;
	return true;
    }     
    return false;
}



function float[] sample_to_array(SndBuf s)
{
    // automatically turns mono files into stereo ones
    // we're assuming files are either mono or stereo and don't check for anything else
    
    float buffer[ s.samples()*2 ];
	
    // MONO
    if(s.channels() == 1)
    {
	for (0 => int c; c < s.samples()*2; c++)
	{
	    s.valueAt(c/2) => buffer[c];
	}
	chout <= "turning mono file into a stereo one" <= IO.nl();
    }
    // STEREO
    else
    {
	for (0 => int c; c < s.samples()*2; c++)
	{
	    s.valueAt(c) => buffer[c];
	}	
    }

    return buffer;
}



function float gating_blocks(float buffer[], float threshold)
{
    -120                       => float block_loudness; // in LKFS
    (400 * samps_per_ms) $ int => int T;                // block size in samples
    (T * 0.25 * 2) $ int       => int overlap_start;    // in samples (x2 because it's stereo)

    // number of 400 msec blocks with a 0.75 overlap
    // that can perfectly fit into the sample
    ( ( (buffer.size()/2)::samp/ms - 400) / 100 ) $ int + 1 => int nr_of_blocks;  

    float gated_blocks_square_mean[0];                  // where the mean square of all the blocks over the threshold are collected

    
    // deal only with full blocks
    for (0 => int j; j < nr_of_blocks; j++)
    {
	int delta;
	int offset;
	float val[2];        // mean square for both channels
	0 => float val_sum;  // mean square of the whole block (both channels)
	
	j * overlap_start => offset;

	for (0 => int ch; ch < 2; ch++)
	{
	    mean_square(buffer, T, offset, ch) => val[ch];                                  // mean square per channel
	}
	val[0] + val[1] => val_sum;                                                         // mean square of the block
	-0.691 + 10*Math.log10( Math.max(Math.FLOAT_MIN_MAG, val_sum) ) => block_loudness;  // LKFS
	if (block_loudness > threshold)
	{
	    // collect mean_square() of the block
	    // if its loudness is above the threshold
	    gated_blocks_square_mean << val_sum;
	}
    }

    float sum;
    for (0 => int c; c < gated_blocks_square_mean.size(); c++)
    {
	gated_blocks_square_mean[c] +=> sum;
    }
    (1./gated_blocks_square_mean.size()) *=> sum;
    
    return -0.691 + 10*Math.log10(sum);
}



function float mean_square(float buffer[], int T, int offset, int channel)
{
    // compute the mean_square of over a period of T samples

    0 => float y;
    for (0 => int c; c < T; c++)
    {
	c*2 + channel => int index;
	offset +=> index;
	buffer[index]*buffer[index] +=> y;
    }
    
    return (1./T) * y;
}



function void biquad(float buffer[], float coeffs[])
{
    // offline biquad filter - works at 48k SR only
    // buffer must be a stereo signal

    float a1, a2, b0, b1, b2, w, y, z1, z2;
    coeffs[0] => a1;
    coeffs[1] => a2;
    coeffs[2] => b0;
    coeffs[3] => b1;
    coeffs[4] => b2;
    
    // stereo processing
    for (0 => int channel; channel < 2; channel++)
    {
	0 => w;
	0 => y;
	0 => z1;
	0 => z2;
	
	for (0 => int n; n < buffer.size()/2; n++)
	{
	    buffer[n*2 + channel] - a1*z1 - a2*z2 => w;
	    b0*w + b1*z1 + b2*z2                  => y;
	    z1                                    => z2;
	    w                                     => z1;
	    y                                     => buffer[n*2 + channel];
	}
    }
}



function void print_array(float buffer[])
{
    for (0 => int c; c < buffer.size(); c++)
    {
	chout <= buffer[c] <= IO.nl();
    }
}

