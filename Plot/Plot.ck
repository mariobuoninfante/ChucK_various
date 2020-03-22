// In order to use this class install "gnuplot" - http://www.gnuplot.info/download.html
// ChucK must be launched with "--caution-to-the-wind"

public class Plot
{
    function void plot(float a[])
    {
        FileIO file;
        file.open("data.txt", FileIO.WRITE);

        // this is needed to plot the graph without being in the interactive mode
        file <= "plot [0:" <= Std.itoa(a.size()-1) <= "] \"-\" with lines" <= IO.nl();
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
        FileIO file;
        file.open("data.txt", FileIO.WRITE);

        // this is needed to plot the graph without being in the interactive mode
        file <= "plot [0:" <= Std.itoa(a.size()-1) <= "] \"-\" with lines" <= IO.nl();
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