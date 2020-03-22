// In order to use this class install "gnuplot" - http://www.gnuplot.info/download.html
// ChucK must be launched with "--caution-to-the-wind"

public class Plot
{
    FileIO file;

    float xrange[2];
    float yrange[2];
    "lines"     => string draw_type;
    "plot"      => string title;
    0 => int export;    // whether or not to save the gnuplot script
    "__data.gnuplot" => string filename;

    function void plot(float a[])
    {
        file.open(filename, FileIO.WRITE);

        // this is needed to plot the graph without being in the interactive mode
        // check xrange and yrange
        file <= "set title '" <= title <= "'" <= IO.nl();
        if(xrange[0] != xrange[1])
            file <= "set xrange[" <= Std.ftoa(xrange[0], 6) <= ":" <= Std.ftoa(xrange[1], 6) <= "]" <= IO.nl();
        if(yrange[0] != yrange[1])
            file <= "set yrange[" <= Std.ftoa(yrange[0], 6) <= ":" <= Std.ftoa(yrange[1], 6) <= "]" <= IO.nl();    
        file <= "plot [x=0:" <= Std.itoa(a.size()-1) <= "] \"-\" with " <= draw_type <= IO.nl();
        for(0 => int c; c < a.size(); c++)
        {
            file <= Std.itoa(c) <= "\t" <= Std.ftoa(a[c], 6) <= IO.newline();
        }

        file.close();
        // launch gnuplot and then delete the data file
        Std.system("gnuplot -p \"__data.gnuplot\"");
        if(!export)
            Std.system("rm __data.gnuplot");
    }

    function void raw(string input)
    {
        string cmd;
        "gnuplot -p -e \"" => cmd;
        cmd + input + "\"" => cmd;
        Std.system(cmd);
    }

    function int record(UGen input, dur duration)
    {
        if(duration <= 0::samp)
            return 1;
        spork ~ _record(input, duration);
    }

    function void _record(UGen input, dur duration)
    {
        float rec_buffer[(duration/samp) $ int]; 
        now => time t0;
        0 => int n;
        while((now-t0) < duration)
        {
            input.last() => rec_buffer[n++];
            samp => now;
        }

        this.plot(rec_buffer);
    }
}
