LUFS (OFFLINE) ANALYZER
---


REQUIREMENTS
---
  - ChucK/audio device sample rate set to 48kHz



HOW TO USE
---
  1. place the audio file(s) you want to analyze in the ./audio folder
  2. from the terminal run the following command:
         > chuck main.ck:my_file.wav
     where "my_file.wav" is the name of the file you want to analyze (my_file) with its file extention (.wav)
     note that the colon ":" is used to pass arguments to a ChucK script
  3. check the results in the terminal



NOTES
---
  - This tool only works with mono/stereo audio files at 48kHz sample rate (but doesn't check neither for the number of channel nor the sample rate, so be careful!).
  - Mono files will be turned into stereo files for analysis purposes (non-distructive process - ie the original file remains intact).

  - The algorightm is based on the following paper: https://www.itu.int/dms_pubrec/itu-r/rec/bs/R-REC-BS.1770-4-201510-I!!PDF-E.pdf

