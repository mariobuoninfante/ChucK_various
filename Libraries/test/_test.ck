// Libraries quick test

//---------------
//-----UTILS-----
//---------------
chout <= "---\nLibraries Test\n---" <= IO.nl();
chout <= "SAMPLE RATE: " <= Utils.SR <= IO.nl();
chout <= Utils.ms2samp(1) <= IO.nl();
chout <= Utils.samp2ms(1) <= IO.nl();
chout <= Utils.bpm2ms(120) <= IO.nl();
chout <= Utils.ms2bpm(1000) <= IO.nl();

int i;          <<< Utils.type(i) >>>;
float f;        <<< Utils.type(f) >>>;
string s;       <<< Utils.type(s) >>>;
polar p;        <<< Utils.type(p) >>>;
complex c;      <<< Utils.type(c) >>>;
dur d;          <<< Utils.type(d) >>>;
time t;         <<< Utils.type(t) >>>;
vec3 v3;        <<< Utils.type(v3) >>>;
vec4 v4;        <<< Utils.type(v4) >>>;
int a_i[0];     <<< Utils.type(a_i) >>>;
float a_f[0];   <<< Utils.type(a_f) >>>;
string a_s[0];  <<< Utils.type(a_s) >>>;
SinOsc sine;    <<< Utils.type(sine) >>>;
Gain gain;      <<< Utils.type(gain) >>>;
Envelope e[0];  <<< Utils.type(e) >>>;



//---------------
//------STR------
//---------------
"t, e, s, t" => s;
Str.split(s) @=> string s_split[];
for(0 => int c; c < s_split.size(); c++)
{
    chout <= c <= ": " <= s_split[c] <= IO.nl();
}

"this is " => string s1; 
"a test!" => string s2;
chout <= Str.append(s1, s2) <= IO.nl();
[0,1,2,3,4] @=> a_i;
chout <= Str.concat(a_i) <= IO.nl();
[1.1,1.2,1.3,1.4] @=> a_f;
chout <= Str.concat(a_f) <= IO.nl();
["Just", "An", "Array", "Of", "String"] @=> a_s;
chout <= Str.concat(a_s) <= IO.nl();
"!SSAP a s'ti llew ,em daer nac uoy fI" => string rvs;
chout <= Str.reverse(rvs) <= IO.nl();



//---------------
//-----ARRAY-----
//---------------
[0,1,2,3,4] @=> int my_i[];
Array.insert(my_i, -100, 2);
Array.print(my_i);
chout <= Array.find(my_i, 2) <= IO.nl();
Array.reverse(my_i);
Array.print(my_i);

[1.0,1.1,1.2,1.3,1.4] @=> float my_f[];
Array.insert(my_f, -100.1, 2);
Array.print(my_f);
chout <= Array.find(my_f, 2000) <= IO.nl();
Array.reverse(my_f);
Array.print(my_f);

["the ", "answer ", "is: "] @=> string my_s[];
Array.insert(my_s, "42" , 3);
Array.print(my_s);
chout <= Array.find(my_s, "42") <= IO.nl();
Array.reverse(my_s);
Array.print(my_s);
