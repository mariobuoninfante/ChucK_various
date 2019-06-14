/*
    TODO
    add Str.rep() for repetition
    add Str.gsub() - global subsitution. Replace all occurences of a pattern in a string with another string
*/

public class Str
{
    /*
        Str is a class containing methods to manipulate strings.
        All the methods in this library will return a new string
        instead of affecting the one passed as argument.
    */

    function static string[] split( string s )
    {
        /*
            Check a string and return an array of strings
            made of the elements in the string that are
            separated by a comma. all 'white spaces'
            in the string are removed.
            Being an array the result needs to be pass using '@=>'.
        */

        string output[0];
        string residue;
        0 => int nr_of_comma;
        if( s.length() != 0 )
        {
            for( 0 => int c; c < s.length(); c++ )
            {
                // find number of commas in 's'
                if( s.charAt(c) == 44 )
                {
                    nr_of_comma++;
                }
                // get rid of white spaces (space and tabs)
                if( s.charAt(c) == 32 || s.charAt(c) == 9 || s.charAt(c) == 13 || s.charAt(c) == 10 )
                {
                    s.erase( c, 1 );
                    c - 1 => c;     // update counter in case something gets erased
                }
            }
            // string with comma(s)
            if( nr_of_comma != 0 )
            {
                output.size( nr_of_comma + 1 );   // assuming there's always an element after a comma - this can be improved - overkill for now!
                for( 0 => int c; c < ( nr_of_comma + 1 ); c++ )
                {
                    s.find(",") => int comma;
                    if( comma != -1 )
                    {
                        s.substring( 0, comma ) => output[c];
                        s.substring( comma + 1 ) => s;
                    }
                    else
                    {
                        s => output[ nr_of_comma ];
                    }
                }
            }
            // string without a comma
            else
            {
                output.size(1);
                s => output[ nr_of_comma ];
            }
        }

        return output;
    }

    function static string append( string s, string a )
    {
        // for 'prepend' just swap args
        return s + a;
    }

    function static string concat( int a[] )
    {
        /*
        convert array of integer to string - no spaces between numbers
        */
        "" => string output;
        for( 0 => int c; c < a.size(); c++ )
        {
            Std.itoa( a[c] ) => string s;
            output + s => output;
        }

        return output;
    }

    function static string concat( float a[] )
    {
        /*
        convert array of float to string - no spaces between numbers
        fixed precision check Std.ftoa()
        */
        "" => string output;
        for( 0 => int c; c < a.size(); c++ )
        {
            Std.ftoa( a[c], 6 ) => string s;
            output + s => output;
        }

        return output;
    }

    function static string concat( string a[] )
    {
        /*
        convert array of string to string - no spaces between numbers
        */
        "" => string output;
        for( 0 => int c; c < a.size(); c++ )
        {
            output + a[c] => output;
        }

        return output;
    }

    function static string reverse( string s )
    {
        string output;
        for( s.length() - 1 => int c; c > -1; c-- )
        {
            s.substring( c, 1 ) => string x;
            output + x => output;
        }

        return output;
    }

    function static string type( string file_path, string s )
    {
        /*
            This is ridiculously clunky and there's no reason why this is a method of the Str class.
            Plus at the moment doesn't deal with any UGen - so there's no reason why it should be used!!!!!
            ARGS:
            1. it must always be "me.path()"
            2. variable name as string
            This method can only be used in a file that has been saved!!!!!
        */

        FileIO file;
        file.open( file_path, FileIO.READ);

        int oracle;
        string mom;
        ["int", "float", "dur", "complex", "time", "polar", "vec3", "vec4", "string", "Event"] @=> string data_type[];
        while( !file.eof() )
        {
            file.readLine() => string line;
            for( 0 => int c; c < data_type.size(); c++ )
            {
                s + "[" => mom;
                line.find( mom ) => oracle;
                if( oracle != -1 )
                {
                    file.close();
                    return "array";
                }
                data_type[c] + " " + s => mom;
                line.find( mom ) => oracle;
                if( oracle != -1 )
                {
                    file.close();
                    return data_type[c];
                }
            }
        }
        return "none";
    }
}
