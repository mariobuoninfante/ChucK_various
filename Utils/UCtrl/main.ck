SinOsc sine => Pan2 master => dac;

sine.freq(400);
master.gain(0.5);

UCtrl UC;

while (true)
{
    Math.random2f(0, 1) => float amp;
    Math.random2f(-1, 1) => float p;
    Math.random2f(10, 2000) => float t;
    UC.gain(sine, amp, t);
    UC.pan(master, p, t);
    chout <= "Amplitude: " <= amp <= " | Pan: " <= p <= " | msec: " <= t  <= IO.nl();
    
    1.5::second => now;
}