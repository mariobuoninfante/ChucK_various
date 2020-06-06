Basic GUI API for ChucK Programming Language - Mario Buoninfante 2019
---

PREREQUISITES
---
  - ChucK Programming Language - http://chuck.cs.princeton.edu/
  - Pure Data - http://msp.ucsd.edu/software.html
  - moonlib Pure Data external library

HOW IT WORKS
---
  - GUI elements are created in Pure Data
  - ChucK communicate via OSC with Pure Data to create elements, set and get values
  - Messages from ChucK to Pd are sent on port 3000, while from Pd to ChucK on port 3001
  - Pure Data 'GUI.pd' ('GUI_Pd' folder) patch must be open before launching any ChucK script that uses GUI elements
  - The patch is automatically saved every time a new GUI object is created
  - It is not possible to create 2 or more objects with the same name (the check happens in 'GUI.pd')
  - If GUI objects are manually deleted (in Pd), they should also be (manually) removed from [text define -k OBJECTS] that is in [pd CORE]
  - The idea is that of copying a new version of the 'GUI_pd' folder in every ChucK script folder where a GUI is needed

GUI OBJECTS
---
  - h_slider - horizontal slider
  - v_slider - vertical slider
  - knob - potentiometer
