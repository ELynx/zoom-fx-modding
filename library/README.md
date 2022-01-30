# Story so far
[Chaper 1 - modify the visual](CH_1.md). This will get you started on extracting, disassembling, modifying and flashing your FX.

# General downloads and tools
To get the flow started, you will need:
* A hex editor of your choice. I used [wxMEdit](https://wxmedit.github.io/).
* A toolset for target platform. I used ti6000 toolset, comes with IDE! Get it from official TI site [here](https://www.ti.com/tool/CCSTUDIO). Do not forget to grab the toolset, IIRC it is an optional.
* For firmware flasher manipulations, go for [Zoom Firmware Editor](https://github.com/Barsik-Barbosik/Zoom-Firmware-Editor) or [Zoom Effect Manager](https://vk.com/zoomeffectmanager), they both work. And maybe they are the same software, just different versions. I highly recommend at least browsing through Java code of 1st one to know what the hell is actually happening under the hood; at time of writing, branch was more yummy then the trunk.
* Note keeping / text editor / text macros. [Notepad++](https://notepad-plus-plus.org/) for me it is!
* Some form of Python. I do not code in Python, so I just use [Online Python](https://www.online-python.com/).

Set it all up. They are mostly “extract and install”, you will not get lost there hopefully.

# Hardware
* An FX unit. I use MS-60b, “Black” edition. From what I gather, this will work for all regulars in Multistomp family, and probably on 1st gen of floor units.
* A Mini USB cable with data capabilities. They are rare species nowadays, grab one.

This is the minimum, since FX can be powered via USB. I also use signal source, some routing pedals, cabling, audio capture card and so on, but they are convenience, not necessity.

# Reading material
To modify anything past the picture and knobs, read _TMS320C674x DSP CPU and Instruction Set Reference Guide_.

Knowing it all from the beginning is not necessary, just start on how stuff is loaded from memory and stored back, how plus, minus and multiply are spelled. When in doubt, go there. It is actually very well written, and when you get the structure, navigating is a breeze.

My review is 5 out of 5, get your reading at official TI site [here](https://www.ti.com/lit/ug/sprufe8b/sprufe8b.pdf).

To have basic structure understanding of what is going on, have a small dip into _TMS320C6000 Optimizing Compiler v8.3.x User's Guide_.

Just go over section _8.6 Interfacing C and C++ With Assembly Language_ since so far I think original effects are written in this format, and a lot of how functions are called, what are function arguments and what is stack preservation can be gleamed from there.

My review is 4 out of 5, as usual get your at official TI site [here]( https://www.ti.com/lit/ug/sprui04d/sprui04d.pdf).

To know more about tools you have, read, you guessed it, _TMS320C6000 Assembly Language Tools_. At the time of writing official TI site gives an error, but I am sure you can figure it out. Just browse over what binaries do what, I will call them by name any way when necessary. 3 out of 5 since I cannot get them now from main site.

Very optional reading, on subject of “what the hell .fphead is”, _TMS320C66x DSP CPU and Instruction Set_, section _Compact Instructions on the CPU_. Get it from official TI site [here]( https://www.ti.com/lit/ug/sprugh7/sprugh7.pdf), and every time your NOP 4 goes missing, or a register is addressed by star-plus-bracket-star-square-root-of-cat check out if this is not a compact instruction. “No idea out” of 5, I was there only for header explanation.
