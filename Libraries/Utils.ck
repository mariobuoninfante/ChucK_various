public class Utils
{
    second / samp => float SR;      // sample rate

    function float ms2samp( float x )
    {
        this.SR * x * 0.001 => x;

        return x;
    }

    function float samp2ms( float x )
    {
        x * ( 1000 / this.SR ) => x;

        return x;
    }

    function float bpm2ms( float x )
    {
        return( 60000 / x );
    }

    function float ms2bpm( float x )
    {
        return( 60000 / x );
    }
}
