# Chapter 3 - how to compile your FX
This is very general description that expect that if you had successfully made an asm file, you can work with an IDE.

To simplify my workflow, I modify one section at a time, so start with `.audio` section for executable part.

## Set up CCS project
Open CCS, and create a project that:

* Targets `Generic C674x device`
* Has a project name :)
* Has a compiler, I used 8.3.8 and 8.3.11 so far
* In an `Empty Assembly-only project`

Put an asm file into the project folder, and add it to the build set.

_Alternatively, just add new .asm file, and paste your code there_.

Suppose that file was named `foo.asm`

Set build configuration Release as active.

_"Pro" tip: disable optimizations if you want, but I saw no difference._

Build the project.

Now, inside `Release` folder, you should find `foo.obj` of size above zero.

If it does not compile, you have more coding to do.

## Take out binary information from object file
This is convoluted, I know. I am sure someone somewhere can automate this to full extend. Run build, get modified .zdl and .ips. If you are this person, please share.

Put `foo.obj` somewhere `dis6x` is visible as well. Just copying .obj to tools folder forked for me.

Run `dis6x foo.obj foo_out.asm`

You should have a decompiled version of your asm. Why, you ask? Opcodes. You compile mnemonics, and get out opcodes. Those are bytes between 8-digit addresses and mnemonics.

_Pro tip: there is a thing called "Build targets", this allows you to set custom steps in IDE. I added a manual step that called disassembler on object file, and placed named as file where I expected. Saved some clicks.

## Make chunky opcode block
Time to visit prepared expression at [Regex 101](https://regex101.com/r/yTVMQv) and do some copy-pasting. Please upvote if found it useful.

Copy content of `foo_out.asm` to `Test string` field on website. Do not forget to remove sample data!

Copy processed content from `List` output below. With magic of prepared regex, you have binary chunk ready.

## Embed opcodes into ZDL
With this mixture on hand, you have yourself executable part of FX.

As in [Chapter 1](CH_1.md) find a place where original executable part started, and replace it with yours.

_N.B. for executable section, padding with zeros until end of section is very important_.

If your opcode block is longer than original, time to optimize.

Viola! After some very convoluted steps, you have FX with custom executable part.

## Extra step for ips release
I use LunarIPS for making patch releases. Use original ZDL file as source, and modified as modified, not that hard to guess.

Remember, content of full ZDL belongs to Zoom Co, do not post it directly. Post only parts that you made, and ips is a tool for that.
