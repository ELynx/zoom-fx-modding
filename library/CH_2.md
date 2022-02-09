# Chapter 2 - thoughts on LineSel, making of RainSel
## Preamble
This will be more conversational, and less instructive. I will explain how I made RainSel, but beside that I will share all I have learned and remember from making of it.

To do something like this, you will need knowledge in programming. Low(er) level languages such as C/C++, or Assembly itself, are the best. You will also need pretty good reading and memory skills, since writing in assembly has _plethora_ of gotchas and details, and you need to keep them all in mind to do just about anything.

I published the part of RainSel that I wrote, from [scraah](https://youtu.be/BZ_bhwCgtXg?t=565), in the [DIY section](diy/rainsel.asm). Hopefully, that will be an example that will shed some light on how the FX actually ticks.

In my humble opinion, LineSel is both a good starting place, and trick book. I highy recommend putting it through disassembly process and reading the result. Just make sure that you have legally obtained copy of source material, and you do not publish what is not yours.

Finally, I am sure that there is an easier / easiest / more automated / fully automated way to do all this. If you know it, or want to implement it - share it, I would add it here if license permits, I will probably use it myself. Most of the time I found myself just _thinking_; followed by doing tests with different audio and settings; followed by reading through all rules for how pipeline works. Time I spent actually compiling and merging the result is so small in comparison that I don't want to optimize it.

## Make your own learning material
To study how LineSel works, and maybe even compile version of yours, you will need to see it's structure in Assembly.

Visit [Chapter 1](CH_1.md) on tools and commands, dis6x is the tool you are looking for. I recomment using "no raw" option so produced .asm file will be almost compile-able.

With that in mind, I will detail some of my thoughts on different parts of FX, to best of my understanding. Find a section I talk about, read my explanation and follow the code you see. Usually I skim over immediate details of "how", unless they are important, and talk about "what".

Of course, text below is my interpretation of what is going on.

## .text - Reading state, parameters
Starting with on off label, we can tell that this code is expected to be called as function. Why, you may ask? Because it has all telltales:
* Storing return address and reserving the stack (by convention return address is given in B3 and stack position is tracked in B15)
* Making a copy of 1st argument for later use (by convention, A4 is first argument)

Then, this function sets up the call to some other function. The address is loaded from A6[31], which is "1st argument"[31], into B31 (another convention), and A4 and B4 are initialized with arguments to that function. Returned value A4 is stored for later use into B0. I most likely find this was call to some "get parameters state" function, that will, depending on context, return values from stored patch, defaults, or last used values.

`[B0]` in front of instruction means that it is taken when B0 is not zero. So, value returned from function call determines which portion of code is executed. This is very likely an Assembly version of `if ... else ...` statement. In terms of "what", it is almost certainly a check if input value for FX state was On or Off.

Watch B4. To call the funcion, it was set to 0. If effect was Off, it remains to be 0; but if effect was On, it becomes floating point 1.0:
* `MVK.S2 0x007f,B4` places binary `01111111` into B4
* `SHL.S2 B4,0x17,B4` moves it 23 bits to the left, to make 0x3F800000
* And that is [IEEE-754](https://www.h-schmidt.net/FloatConverter/IEEE754.html) way to say 1.0 in float
  * Overall, most of constants I saw are either some address, or some float constant

Now B4 holds a float value that represents if FX is On or Off. I will later on refer to this value as k0.

Then, function call logic is applied in reverse: stack is released, return address is restored, jump to return address is initiated.

Both of "edit" functions do (give or take) the same as "on off" function. Difference is in what is given as 2nd argument to "get parameters state" call. Efx gives 2, and Out gives 3. I assume these are IDs that happen in [Knob position](CH_1.md#optional-knob-positions). This is reinforced, because value 151 is used, and I assume this is "less than" border set on visually from 0 to 150 knob value.

Next, see that by magic of address aritmetics, Efx is stored with offset 20, whereas Out is stored with offset 24, one word after another.

Later on, I will refer to float value derived from Efx as k5 and from Out as k6, because they are loaded from offsets 5 and 6 correspondingly, again one word after another.

As of now, I cannot tell what is the significance of constant 0x44306666. Some effect unique identifier? Or address of some function, buffer? I cannot tell, and it does not make much reason when seen as float, because it is ~705 and I don't see this as useful multiplier. Would be glad to hear your thoughts.

Function "init" is essentially calling all three of above in order, feeding them address 0x80000378 as a parameter. Notice, there is a "table" by that address. Could it be that values are stored by that address? But then how multiple instances of same FX work, without overwriting each other's parameters?

Call stubs, and stub returns, are seems to be the part of TI's tooling SDK for integrating C/C++ and Assembly, and provides a pre-made way of calling functions observing all conventions and returning back from them. Read upon this if you want to, omit otherwise.

Next actual function, in my opinion, is called when unit needs to set up an image for FX. It loads addresses of picture and knob parameters, and return it back to caller in some structure.

## .const and .fardata - The static things
There is not much here to add, beside what is already covered in [Chapter 1](CH_1.md). Image, labels and knob parameters are found here.

This section is not executable, so here is not much to assume structure from. Some values stand out and described already, others are completely unknown.

## .audio - The logic of FX
This section seems very long and involved, especially for FX as simple as output switch. But if you are familiar with compiler optimizations, you will recognize [Loop unrolling](https://en.wikipedia.org/wiki/Loop_unrolling).

There is a clear "setup" section in the beginning, where pointers are taken from input structue, and local variables are set. Notice, here is another method of producing float "1.0" is used. My guess is that original developers just used literal "1.0" and form it took depends on logical unit compiler decided to place the operation.

Then external loop of two steps is set up to run twice: once for left channel, once for right.

Internal loop is unrolled 8 times, this means samples for left / right are interleaved by step of 8. Something like LLLL LLLL RRRR RRRR LLLL LLLL RRRR RRRR and so on.

Now the loop consists of four logical operations, repeated with only difference of used registers. "Once you see it, you cannot unsee it".
* Some value is taken from moving address and stored into static one. I presume this is buffer addressing, or position tracking
* Reading and writing of Effect value
* Reading and writing of Guitar value
* Adding original signal to the processing end
