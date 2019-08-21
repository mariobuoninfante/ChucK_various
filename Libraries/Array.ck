public class Array
{
    /*
        Array is a class containing methods to manipulate arrays.
        All the methods in this class will affect the array passed as argument
        instead of returning a new array.
    */

    function static void insert( int array[], int x, int pos )
    {
        int mom_arr[0];
        if( pos < array.size() && pos >= 0 )
        {
            for( pos => int c; c < array.size(); c++ )
            {
                mom_arr << array[c];
            }
            x => array[ pos ];
            array.size( array.size() + 1 );
            for( 0 => int c; c < mom_arr.size(); c++ )
            {
                mom_arr[c] => array[ c + pos + 1 ];
            }
        }
        else if( pos == array.size() )
        {
            array << x;
        }
    }

    function static void insert( float array[], float x, int pos )
    {
        float mom_arr[0];
        if( pos < array.size() && pos >= 0 )
        {
            for( pos => int c; c < array.size(); c++ )
            {
                mom_arr << array[c];
            }
            x => array[ pos ];
            array.size( array.size() + 1 );
            for( 0 => int c; c < mom_arr.size(); c++ )
            {
                mom_arr[c] => array[ c + pos + 1 ];
            }
        }
        else if( pos == array.size() )
        {
            array << x;
        }
    }

    function static void insert( string array[], string x, int pos )
    {
        string mom_arr[0];
        if( pos < array.size() && pos >= 0 )
        {
            for( pos => int c; c < array.size(); c++ )
            {
                mom_arr.size( mom_arr.size() + 1 );
        	    array[c] => mom_arr[ c - pos ];
            }
            x => array[ pos ];
            array.size( array.size() + 1 );
            for( 0 => int c; c < mom_arr.size(); c++ )
            {
                mom_arr[c] => array[ c + pos + 1 ];
            }
        }
        else if( pos == array.size() )
        {
            array << x;
        }
    }

    function static int find( int a[], int x )
    {
        /*
            return 'x' index in case 'x' is in a[] or -1 if there's no match
        */
        for( 0 => int c; c < a.size(); c++ )
        {
            if( a[c] == x )
            {
                return c;
            }
        }

        return -1;
    }

    function static int find( float a[], float x )
    {
        /*
            return 'x' index in case 'x' is in a[] or -1 if there's no match
        */
        for( 0 => int c; c < a.size(); c++ )
        {
            if( a[c] == x )
            {
                return c;
            }
        }

        return -1;
    }

    function static int find( string a[], string x )
    {
        /*
        	return 'x' index in case 'x' is in a[] or -1 if there's no match
        */
        for( 0 => int c; c < a.size(); c++ )
        {
            if( a[c] == x )
            {
                return c;
            }
        }

        return -1;
    }

    function void reverse( int a[] )
    {
        a.size() => int N;

        for( 0 => int c; c < N/2; c++ )
        {
            a[c] => int temp;
            a[ N - 1 - c ] => a[c];
            temp => a[ N - c - 1 ];
        }
    }


    function void reverse( float a[] )
    {
        a.size() => int N;

        for( 0 => int c; c < N/2; c++ )
        {
            a[c] => float temp;
            a[ N - 1 - c ] => a[c];
            temp => a[ N - c - 1 ];
        }
    }


    function void reverse( string a[] )
    {
        a.size() => int N;

        for( 0 => int c; c < N/2; c++ )
        {
            a[c] => string temp;
            a[ N - 1 - c ] => a[c];
            temp => a[ N - c - 1 ];
        }
    }


    function static void print( int a[] )
    {
        for( 0 => int c; c < a.size(); c++ )
        {
            chout <= a[c] <= " ";
        }
        chout <= IO.nl();
    }

    function static void print( float a[] )
    {
        for( 0 => int c; c < a.size(); c++ )
        {
            chout <= a[c] <= " ";
        }
        chout <= IO.nl();
    }

    function static void print( string a[] )
    {
        for( 0 => int c; c < a.size(); c++ )
        {
            chout <= a[c] <= " ";
        }
        chout <= IO.nl();
    }
}
