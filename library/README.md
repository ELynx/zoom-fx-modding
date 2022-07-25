# Story so far
[Chapter 1 - modify the visual](CH_1.md).

This will get you started on extracting, disassembling, modifying and flashing your FX.

Strictly speaking, there is no need to know any assembly, or even programming at all, to do the above. I would recommend getting custom image for FX as a first step to verify that all the tools are set up, cables are in order and you know where each component is.

[Chapter 2 - thoughts on LineSel, making of RainSel](CH_2.md).

My thoughts and findings on LineSel, one of effects that was easiest to understand and test. Plus, more textual description of how I made RainSel inspired by it.

This is where you follow after Chapter 1 if you want to make any effect yourself.

[Chapter 3 - how to compile your FX](CH_3.md).

I totally forgot this when writing Chapter 2, oops. Follow there if you have an asm you want to compile and put to unit.

[Chapter 4 - ZDL header format](CH_4.md).

After some analysis, I managed to make custom FX to be added to unit, not replacing original. In Chapter 4 I put my header table findings.

After you have ZDL file made and running, time to make it separate item from original.

This is logical conclusion for making your first effect.

[Chapter 5 - Shrinker](CH_5.md).

A small tool with sharp edges to mass-make ZDLs a bit smaller, one time.

Chapter 6 - Divide by zero

After a lot of effort being spent on making RTFM I realized that single effect will not work, at least to my knowledge. I made second effect Div0 that "separated" left and right channels on Dry buffer. It feels like this was a compatibility workaround on behalf of Zoom Co team to insure compatibility between mono -> stereo and stereo -> stereo devices. Even Dry buffer has space for 2nd channel.

I would not repeat myself here, please read [Div0](../howto/Div0.md) page in language of your choice to see what is done with buffer. And some explanation was added to [R.T.F.M.](../howto/RTFM.md) with some diagrams.

As side effect, I quite improved [asm for R.T.F.M.](../diy/rtfm.asm), not yet C or C++, not loop unroll, but quite better. [asm for Div0](../diy/div0.asm) is derivative of that.

# General downloads and tools
To get the flow started, you will need:
* A hex editor of your choice. I used [wxMEdit](https://wxmedit.github.io/).
* A toolset for target platform. I used ti6000 toolset, comes with IDE! Get it from official TI site [here](https://www.ti.com/tool/CCSTUDIO). Do not forget to grab the toolset, IIRC it is an optional.
* For firmware flasher manipulations, go for [Zoom Firmware Editor](https://github.com/Barsik-Barbosik/Zoom-Firmware-Editor) or [Zoom Effect Manager](https://vk.com/zoomeffectmanager), they both work. And maybe they are the same software, just different versions. I highly recommend at least browsing through Java code of 1st one to know what the hell is actually happening under the hood; at time of writing, branch was more yummy then the trunk.
* Note keeping / text editor / text macros. [Notepad++](https://notepad-plus-plus.org/) for me it is!
* Some form of Python. I do not code in Python, so I just use [Online Python](https://www.online-python.com/).
* Tool for regular expressions. I use my favorite online one [Regex 101](https://regex101.com/).

Set it all up. They are mostly “extract and install”, you will not get lost there hopefully.

# Hardware
* An FX unit. I use MS-60b, “Black” edition. From what I gather, this will work for all regulars in Multistomp family, and probably on 1st gen of floor units.
* A Mini USB cable with data capabilities. They are rare species nowadays, grab one.

This is the minimum, since FX can be powered via USB. I also use signal source, some routing pedals, cabling, audio capture card and so on, but they are convenience, not necessity.

# Reading material
To modify anything past the picture and knobs, read _TMS320C674x DSP CPU and Instruction Set Reference Guide_.

Knowing it all from the beginning is not necessary, just start on how stuff is loaded from memory and stored back, how plus, minus and multiply are spelled. When in doubt, go there. It is actually very well written, and when you get the structure, navigating is a breeze.

My review is 5 out of 5, get your reading at official TI site [here](https://www.ti.com/lit/ug/sprufe8b/sprufe8b.pdf).

Edit: after some _deep research_ I found that information on .fphead is found there as well, no need for extra book. My rating is 5.7 out of 5 then. So:

On subject of “what the hell .fphead is” read section _Compact Instructions on the CPU_. Every time your NOP 4 goes missing, or a register is addressed by star-plus-bracket-star-square-root-of-cat check out if this is not a compact instruction.

To have basic structure understanding of what is going on, have a small dip into _TMS320C6000 Optimizing Compiler v8.3.x User's Guide_.

Just go over section _8.6 Interfacing C and C++ With Assembly Language_ since so far I think original effects are written in this format, and a lot of how functions are called, what are function arguments and what is stack preservation can be gleamed from there.

My review is 4 out of 5, as usual get your at official TI site [here]( https://www.ti.com/lit/ug/sprui04d/sprui04d.pdf).

To know more about tools you have, read, you guessed it, _TMS320C6000 Assembly Language Tools_. Official TI site link is [here](https://www.ti.com/lit/ug/sprui03d/sprui03d.pdf).

4 out of 5, good reading, pings your imagination, but lacks certain _character_.

N.B. It seems updated versions of these documents are not published by the same links. When in doubt, just go to [TI](https://www.ti.com/) and search for them. I doubt they rediscovered how LDW works, but hey, keep the docs flowing.
