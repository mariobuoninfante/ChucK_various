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


    /*
        long overloading - the function(s) returns the data type as string
    */
    function string type( Object obj )
    {
        obj.toString() => string s;
        if( s == "" )
            "string:" => s;
        else if ( s.find( "@" ) != -1 )
            "array:" => s;
        return s.substring( 0, s.rfind( ":" ) );
    }

    function string type( string x )
    {
        return "string";
    }

    function string type( int x )
    {
        return "int";
    }

    function string type( float x )
    {
        return "float";
    }

    function string type( polar x )
    {
        return "polar";
    }

    function string type( complex x )
    {
        return "complex";
    }

    function string type( dur x )
    {
        return "dur";
    }

    function string type( time x )
    {
        return "time";
    }

    function string type( vec3 x )
    {
        return "vec3";
    }

    function string type( vec4 x )
    {
        return "vec4";
    }
}
