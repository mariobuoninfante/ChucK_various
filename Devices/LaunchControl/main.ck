LaunchControl LC;


while (true)
{
    LC.recv();  // this advances in time when MIDI is recv from LC

    if (LC.value != 0)
        LC.set(LC.type, LC.id, "red_flash");
    else
	LC.set(LC.type, LC.id, "off");

    // print anytime a control is used on LC
    chout <= LC.type <= " " <= LC.id <= " " <= LC.value <= IO.nl();

}