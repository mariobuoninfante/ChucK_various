class Line extends Chubgraph
{
    /*
        Linear interpolator
    */
    Step _step => Envelope _env => outlet;
    _step.next(1);
    
    0 => float targ;
    0 => float t;
    _env.time(t);
    _env.target( targ );
    
    function void set_time( float x )
    {
        // set 't' in msec
        x => t;
        _env.time ( t * 0.001 );
    }
    
    function void set_target( float x )
    {
        x => targ;
        _env.target( targ );
    }
}
