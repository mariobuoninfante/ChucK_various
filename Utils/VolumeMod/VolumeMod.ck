public class VolumeMod extends Chugraph {
    // Mono channel designed to have its volume modulated at audio rate
    // useful for volume and pan modulations - e.g. LFOs

    // UGens
    UGen modSource;
    Gain vol, g, rG;
    Step offset, rightOffset;

    // DSP chain
    inlet => vol => outlet;
    rightOffset => rG;
    offset => g => rG => vol;  // modSource will connect to g

    // UGens setup
    offset.next(0.5);  // used to bring signal to 0,+1 range
    rightOffset.next(0);  // used to reverse mod signal
    vol.op(3);  // multiply inputs
    rG.op(2);  // subtract inputs


    // Variables
    0 => int range;
    0 => int mode;

    // Methods
    function void connectMod (UGen mod) {
        // connect the modulation source

        mod @=> modSource;

        modSource => g;
        if ( this.range == 0 ) { 
            modSource.gain(0.5);  // bring signal to -0.5,+0.5 range
        } else if ( this.range == 1 ) {
            modSource.gain(1);  // leave modulation signal's range intact
        }
    }

    function void disconnectMod (UGen mod) {
        // disconnect the modulation source

        modSource =< g;
        modSource.gain(1);
    }

    function void setMode (int m) {
        // set mode to either "standard" (range: 0,1), or "inverse" (range: 1,0)

        if (m == 0) {
            rightOffset.next(0);
            0 => this.mode;
        } else {
            rightOffset.next(1);
            1 => this.mode;
        }
    }

    function void setRangeMode (int r) {
        // mode: 0 - expects -1,+1 range
        // mode: 1 - expects 0,+1 range

        if (r == 0) {  // signal's range is -1,+1 and needs to be scaled
            offset.next(0.5);
            modSource.gain(0.5);  
            if (!offset.isConnectedTo(g)) {
                offset => g;
            }
        } else {
            modSource.gain(1);  // leaves modulation signal's range intact
            if (offset.isConnectedTo(g)) {
                offset =< g;
            }
        }
    }
}
