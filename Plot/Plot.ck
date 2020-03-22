// In order to use this class install "gnuplot" - http://www.gnuplot.info/download.html
// ChucK must be launched with "--caution-to-the-wind"

public class Plot
{
    FileIO file;

    float xrange[2];
    float yrange[2];
    "lines" => string draw_type;

    function void plot(float a[])
    {
        file.open("data.txt", FileIO.WRITE);

        // this is needed to plot the graph without being in the interactive mode
        // check xrange and yrange
        if(xrange[0] == xrange[1] && yrange[0] == yrange[1])
            file <= "plot [x=0:" <= Std.itoa(a.size()-1) <= "] \"-\" with " <= draw_type <= IO.nl();
        else if(xrange[0] != xrange[1] && yrange[0] == yrange[1])
            file <= "plot [x=" <= Std.ftoa(xrange[0], 6) <= ":" <= Std.ftoa(xrange[1], 6) <= "] \"-\" with " <= draw_type <= IO.nl();
        else if(xrange[0] != xrange[1] && yrange[0] != yrange[1])
            file <= "plot [x=" <= Std.ftoa(xrange[0], 6) <= ":" <= Std.ftoa(xrange[1], 6) <= "] [" <= Std.ftoa(yrange[0], 6) <= ":" <= Std.ftoa(yrange[1], 6) <= "] \"-\" with " <= draw_type <= IO.nl();
        for(0 => int c; c < a.size(); c++)
        {
            file <= Std.itoa(c) <= "\t" <= Std.ftoa(a[c], 6) <= IO.newline();
        }

        file.close();
        // launch gnuplot and then delete the data file
        Std.system("gnuplot -p \"data.txt\"");
        Std.system("rm data.txt");
    }


    function void plot(int a[])
    {
        file.open("data.txt", FileIO.WRITE);

        // this is needed to plot the graph without being in the interactive mode
        file <= "plot [x=0:" <= Std.itoa(a.size()-1) <= "] \"-\" with lines" <= IO.nl();
        for(0 => int c; c < a.size(); c++)
        {
            file <= Std.itoa(c) <= "\t" <= Std.ftoa(a[c], 6) <= IO.newline();
        }

        file.close();
        // launch gnuplot and then delete the data file
        Std.system("gnuplot -p \"data.txt\"");
        Std.system("rm data.txt");
    }
}