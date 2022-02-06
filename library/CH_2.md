# Chapter 2 - thoughts on LineSel, making of RainSel

This will be more conversational, and less instructive. I will explain how I made RainSel, but beside that I will share all I have learned and remember from making of it.

To do something like this, you will need knowledge in programming. Low(er) level languages such as C/C++, or Assembly itself, are the best. You will also need pretty good reading and memory skills, since writing in assembly has _plethora_ of gotchas and details, and you need to keep them all in mind to do just about anything.

I published the part of RainSel that I wrote, from [scraah](https://youtu.be/BZ_bhwCgtXg?t=565), in the [DIY section](diy/rainsel.asm). Hopefully, that will be an example that will shed some light on how the FX actually ticks.

In my humble opinion, LineSel is both a good starting place, and trick book. I highy recommend putting it through disassembly process and reading the result. Just make sure that you have legally obtained copy of source material, and you do not publish what is not yours.

## .audio section

It seems FX processing code naming convention is .audio. I did not try too hard, but I was never getting this name in final assembly, so I think this name is either custom addition, to product of some more sophisticated toolchain.

This is where the logic actually resides.
