public class Utils
{
    second / samp => static float SR;      // sample rate

    function static float ms2samp( float x )
    {
        SR * x * 0.001 => x;

        return x;
    }

    function static float samp2ms( float x )
    {
        x * ( 1000 / SR ) => x;

        return x;
    }

    function static float bpm2ms( float x )
    {
        return( 60000 / x );
    }

    function static float ms2bpm( float x )
    {
        return( 60000 / x );
    }


    /*
        long overloading - the function static(s) returns the data type as string
    */
    function static string type( Object obj )
    {
        obj.toString() => string s;
        if( s == "" )
            "string:" => s;
        else if ( s.find( "@" ) != -1 )
            "array:" => s;
        return s.substring( 0, s.rfind( ":" ) );
    }

    function static string type( string x )
    {
        return "string";
    }

    function static string type( int x )
    {
        return "int";
    }

    function static string type( float x )
    {
        return "float";
    }

    function static string type( polar x )
    {
        return "polar";
    }

    function static string type( complex x )
    {
        return "complex";
    }

    function static string type( dur x )
    {
        return "dur";
    }

    function static string type( time x )
    {
        return "time";
    }

    function static string type( vec3 x )
    {
        return "vec3";
    }

    function static string type( vec4 x )
    {
        return "vec4";
    }
}


// create an instance of the class to initialize the class members
// see 'class constructors' here: https://chuck.cs.princeton.edu/doc/language/class.html#intro
Utils _Utils;