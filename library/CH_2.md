# Chapter 2 - thoughts on LineSel, making of RainSel
## Preamble
This will be more conversational, and less instructive. I will explain how I made RainSel, but beside that I will share all I have learned and remember from making of it.

To do something like this, you will need knowledge in programming. Low(er) level languages such as C/C++, or Assembly itself, are the best. You will also need pretty good reading and memory skills, since writing in assembly has _plethora_ of gotchas and details, and you need to keep them all in mind to do just about anything.

I published the part of RainSel that I wrote, from [scraah](https://youtu.be/BZ_bhwCgtXg?t=565), in the [DIY section](../diy/rainsel.asm). Hopefully, that will be an example that will shed some light on how the FX actually ticks.

In my humble opinion, LineSel is both a good starting place, and trick book. I highly recommend putting it through disassembly process and reading the result. Just make sure that you have legally obtained copy of source material, and you do not publish what is not yours.

Finally, I am sure that there is an easier / easiest / more automated / fully automated way to do all this. If you know it, or want to implement it - share it, I would add it here if license permits, I will probably use it myself. Most of the time I found myself just _thinking_; followed by doing tests with different audio and settings; followed by reading through all rules for how pipeline works. Time I spent actually compiling and merging the result is so small in comparison that I don't want to optimize it.

## Make your own learning material
To study how LineSel works, and maybe even compile version of yours, you will need to see its structure in Assembly.

Visit [Chapter 1](CH_1.md) on tools and commands, dis6x is the tool you are looking for. I recommend using "no raw" option so produced .asm file will be almost compile-able.

With that in mind, I will detail some of my thoughts on different parts of FX, to best of my understanding. Find a section I talk about, read my explanation and follow the code you see. Usually, I skim over immediate details of "how", unless they are important, and talk about "what".

Of course, text below is my interpretation of what is going on.

## .text - Reading state, parameters
Starting with on off label, we can tell that this code is expected to be called as function. Why, you may ask? Because it has all telltales:
* Storing return address and reserving the stack (by convention return address is given in B3 and stack position is tracked in B15)
* Making a copy of 1st argument for later use (by convention, A4 is first argument)

Then, this function sets up the call to some other function. The address is loaded from A6[31], which is "1st argument"[31], into B31 (another convention), and A4 and B4 are initialized with arguments to that function. Returned value A4 is stored for later use into B0. I most likely find this was call to some "get parameters state" function, that will, depending on context, return values from stored patch, defaults, or last used values.

`[B0]` in front of instruction means that it is taken when B0 is not zero. So, value returned from function call determines which portion of code is executed. This is very likely an Assembly version of `if ... else ...` statement. In terms of "what", it is almost certainly a check if input value for FX state was On or Off.

Watch B4. To call the function, it was set to 0. If effect was Off, it remains to be 0; but if effect was On, it becomes floating point 1.0:
* `MVK.S2 0x007f,B4` places binary `01111111` into B4
* `SHL.S2 B4,0x17,B4` moves it 23 bits to the left, to make `0x3F800000`
* And that is [IEEE-754](https://www.h-schmidt.net/FloatConverter/IEEE754.html) way to say 1.0 in float
  * Overall, most of constants I saw are either some address, or some float constant

Now B4 holds a float value that represents if FX is On or Off. I will later on refer to this value as __k0__.

Then, function call logic is applied in reverse: stack is released, return address is restored, jump to return address is initiated.

Both of "edit" functions do (give or take) the same as "on off" function. Difference is in what is given as 2nd argument to "get parameters state" call. Efx gives 2, and Out gives 3. I assume these are IDs that happen in [Knob positions](CH_1.md#optional-knob-positions). This is reinforced, because value 151 is used, and I assume this is "less than" border set on visually from 0 to 150 knob value.

Next, see that by magic of address arithmetic, Efx is stored with offset 20, whereas Out is stored with offset 24, one word after another.

Later on, I will refer to float value derived from Efx as __k5__ and from Out as __k6__, because they are loaded from offsets 5 and 6 correspondingly, again one word after another.

As of now, I cannot tell what is the significance of constant `0x44306666`. Some effect unique identifier? Or address of some function, buffer? I cannot tell, and it does not make much reason when seen as float, because it is ~705 and I don't see this as useful multiplier. Would be glad to hear your thoughts.

Function "init" is essentially calling all three of above in order, feeding them address `0x80000378` as a parameter. Notice, there is a "table" by that address. Could it be that values are stored by that address? But then how multiple instances of same FX work, without overwriting each other's parameters?

Next come call stubs, and stub returns. They seem to be the part of TI's tooling SDK for integrating C/C++ and Assembly, and provide a pre-made way of calling functions observing all conventions and returning back from them. Read upon this if you want to, omit otherwise.

In between stubs and helpers resides the last utility function. In my opinion, is called when unit needs to set up an image for FX. It loads addresses of picture and knob parameters, and return it back to caller in some structure.

Notice how optimizing compiler uses both registers, in parallel, to speed up the process. Resulting instructions are bigger (32-bit opcodes vs potential 16-bit opcodes) but total time spent in function is shorter. From this and similar examples I presume that optimization was set to favor speed at the cost of size.

## .const and .fardata - The static things
There is not much here to add, beside what is already covered in [Chapter 1](CH_1.md). Image, knob parameters and labels are found here, in that order.

This section is not executable, so here is not much to assume structure from. Some values stand out and described already, others are completely unknown.

There is a label at address `0x80000378`, where I presume __k0__,__k5__ and __k6__ are stored. There is also value __k4__, but I did not notice where it is set. I haven't seen other values in this range being used.

Fardata at the end seems to store parameters for the knobs.

## .audio - The logic of FX
This section seems very long and involved, especially for FX as simple as output switch. But if you are familiar with compiler optimizations, you will recognize [Loop unrolling](https://en.wikipedia.org/wiki/Loop_unrolling).

There is a clear "setup" section in the beginning, where pointers are taken from input structure, and local variables are set.

Notice, here is another method of producing float 1.0 is used. My guess is that original developers just used literal 1.0, and steps compiler takes depend on logical unit that was free from other operations.

1.0 is created in B5, but then stored in B8 for use throughout the function.

Next, external loop of two steps is set up: once for left channel, once for right.

Internal loop is unrolled to 8 instances, this means samples for left / right are interleaved by step of 8. Something like LLLLLLLL RRRRRRRR LLLLLLLL RRRRRRRR and so on.

The loop consists of four logical operations, repeated with only difference of used registers. "Once you see it, you cannot unsee it".
* Some value is taken from moving address and stored into static one. I presume this is buffer addressing, or position tracking
* Reading and writing of Effect signal
* Reading and writing of Guitar signal
* Adding Effect signal to the final output

### Reading and writing some unmodified values
Values are taken from pointer A7[0] to A7[7], and stored into A6[0].

Here is the first example of processing logic: LDW takes 4 steps to load and store data, and only then loaded value is stored into another address by STW. All these constrains and details come from Assembly reference. I recommend at minimum searching for all instances of instruction of interest, because different constraints are written in different sections.

### Processing Effect signal
Coefficients __k0__, __k4__ and __k5__ are repeatedly loaded, as well as single sample of Effect signal _X_.

In several multiplications, _X_ is multiplied by all coefficients, and written back over original _X_.

### Processing Guitar signal
Coefficient __k0__ and original incoming signal _phi_ are repeatedly loaded.

_phi_ and __k0__ are multiplied and stored over original _phi_.

### Adding Effect signal to the final output
Coefficients __k0__, __k4__ and __k6__ are repeatedly loaded, as well as single sample of final output signal _Y_.

Notice how in every iteration, value _X_ is also preserved for use here.

Coefficient __k0__ is used together with 1.0 to make (1.0 - __k0__).

_X_ is multiplied with (1.0 - __k0__), __k4__ and __k6__.

Then, to that contraption, _Y_ is added unconditionally.

Result overrides original _Y_ value.

### And now to "what"
Fantastic, but what all those things _do_?.

__k4__ x __k5__ to me seems like normalized value of EFX_L knob. That is, when knob is set to 100, this product is equal to 1.0. Same goes for __k4__ x __k6__ presenting OUT_L.

|                              | Effect signal: _X_ x __k0__ x EFX_L, becomes | Guitar signal: _phi_ x __k0__, becomes | Output value: _X_ x (1.0 - __k0__) x OUT_L + _Y_, becomes |
|------------------------------|----------------------------------------------|----------------------------------------|-----------------------------------------------------------|
| Effect is On, __k0__ is 1.0  | _X_ x EFX_L                                  | _phi_                                  | _Y_                                                       |
| Effect is Off, __k0__ is 0.0 | 0.0                                          | 0.0                                    | _X_ x OUT_L + _Y_                                         |

Now look at the trick:

When effect is On, Effect signal is multiplied by your knob setting, and sent out, as well as original Guitar signal is sent out. Plus, output buffer is not affected.

When effect is Off, both Effect signal and original Guitar signal are suppressed. This means that any following effect will receive 0.0 as input. But incoming Effect signal is added to output, affected by knob setting.

From point of view of `LineSel`, it is "always on". The difference between On and Off is responsibility of FX itself. This means that, in theory, it is possible to make "double function" effects or keep twice as much presets within single block.

Notice addition to output buffer, not overriding. To me this seems to be made to preserve trails of any effects that have them. Since all effects after `LineSel` are still processing input (albeit direct next is receiving 0.0), all trails still come out, be processed and placed to the out.

It is clear that some effects require not only silencing of Effect, but also of Guitar. One such effect is (IMO) `Bomber` that reacted only to raw Guitar signal. I accidentally learned this when I set Guitar to zero, and it was silent despite Effect actually coming through. `ZNR` has option to gate Effect or Guitar.

Now you see why this is quite the trick book? This effect does not do much on itself, but _heavily_ messes with whole signal chain. From here, any combination of processed and dry signal is available, as well as options to modify any of them. Only limitation that is present is quite logical. Any modifications to output are not final. Next effect in chain will have its influence, and its only agreement output value is modified by adding, not hard setting (and I think it is sometimes broken by FXes). For example, you cannot _set_ output to some value, if this is not last effect, only _modify_ it.

### And now to simple logic of RainSel
`RainSel` does not work with output buffer _Y_ at all. I found that not very useful for different processing of L and R channels. Effects from unit that are placed next in chain have _very_ mixed logic of processing stereo signals.

Similar situation goes with Guitar signal. There is no need to modify it here, since silencing of following effect is not necessary.

For `RainSel`, output is:

__ka__ x WET x _X_ + __kb__ x DRY x _phi_

Initially, __ka__ is set to 1.0, and __kb__ is taken from __k0__.

So, when effect is On, mode is "BOTH MIX". Output is a sum of Effect x WET and Guitar X DRY signals. When effect is Off, L is only _X_ x WET.

For next pass, __ka__ and __kb__ are swapped. If __kb__ was 1.0, there is no difference and "BOTH MIX" logic applies. When effect is Off, R is only _phi_ X DRY.

|        | __ka__ | __kb __ |
|--------|--------|---------|
| L, On  | 1.0    | 1.0     |
| R, On  | 1.0    | 1.0     |
| L, Off | 1.0    | 0.0     |
| R, Off | 0.0    | 1.0     |
