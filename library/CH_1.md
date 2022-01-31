# Chapter 1 – modify the visual
Get firmware flasher manipulator, pick one of listed in [README](README.md) or any other that you have.

Get ZDL file you want to modify. Manipulators have them prepared, or can extract them from firmware updates.

Now, ZDL file is an [ELF]( https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) file with some ZDL prefix information. At time of writing, I do not know what that ZDL information header is, so let’s just cut it off =)

With hex editor, open ZDL file, and cut off everything before ELF magic. Note, it starts with 0x7F, not letter E. Save yourself some sanity and cut where it should be. Save the result as you wish, I just placed it into folder with binary toolset.

Invoke the disassembler! Given you started with FOO.ZDL and named your truncated file FOO.ELF, call:
* ```dis6x FOO.ELF foo.asm```
* ```dis6x FOO.ELF -b -s foo_data_as_bytes.asm```

For now, use `foo_data_as_bytes.asm`.

Find a section .data with name starting with `pic` or `picture` and effect name in it.

Scroll down, find a label (looks like this `SomeLabel:`) that marks beginning of another piece of information.

Bingo, this is where the picture is encoded.

Copy the text between start of the section and label.

For each line, remove excess whitespaces, remove .byte prefix, and put a comma after each element except for the last. Text editor with macros is a great help.

Paste the resulting ledger of misery into [decoder](../diy/decode_picture.py) into inputBytes and run.

If everything goes well, you will have an ASCII presentation of the FX you are looking for.

For interested: compression algorithm is brilliant in it's simplicity. Duplicate groups of pixels are compressed into length-independent blocks, so with careful image planning image is compressed around two to three times. For details, see [decoder](../diy/decode_picture.py), it has a byte sample already, just give it a run.

Edit at your heart’s desire, just keep resulting size not bigger than original. Remember that used box symbols are quite to scale with pixels on screen: IRL pixels are not squares, but rectangles. In NPP, do maximum zoom out and it actually looks like a screen =)

Note that knobs are painted over by external code, so if they are missing from design, do not be afraid, they will be there as positioned. Some effects do have knobs painted on, but whether this is design pipeline, choice or just inconsistency I cannot tell. From compression perspective, image without knobs have less of "difference" and can compress smaller, if some thought is applied.

One technique I found useful for compression is to break down an image each eight lines, so you know which blocks will be tested for equality on each step.

Ready? Copy your text into [encoder](../diy/encode_picture.py) into inputText, and run.

You will get a hex output at the bottom.

Small notice: I publish these algorithms without doubt because I derived them using my brain alone. I did not look into any source code or assembly, just spent some time figuring out how image on screen correlates to bytes in front of me.

Open the ZDL you want to modify, and find the start of original picture. Usually searching first word (four bytes) gives a unique match.

Replace starting from start address with your hex. Hex editor I use have great feature "paste with override", just make sure to enable "paste as hex" in options so your hexadecimals go into hex panel (left by default) without any conversion.

Do not forget to pad the remainder with zeros, if your result is smaller than the original. You need to write zeros down to label you found earlier.

# Optional: label texts
Look for ASCII OnOff either in binary, or (reversed) in foo.asm. Mind that disassembler does not mark ASCII for you in `foo.asm`, and gives words in "reverse". Use ASCII -> hex code converter, some thinking, and you will prevail.

Following OnOff, you will find other labels, including visible effect name and captions over knobs in the edit menu. As usual, hex editor will display them as ASCII, disassembler will just show bytes or word in "reverse".

After the label, there are stored maximum and default values for knobs; but so far, I think they are replaced with hardcoded constants (or derived values) across binary, so editing them will create some side effects. Did not try that one yet, had no need.

#Optional: knob positions
Look for .data section with label that is called "effect type info" in `foo.asm`. It usually follows the bytes with image, or is at least close. Look for specific values, I expect 128 x 64 to be pretty universal.

So far I know that structure is (by word):

| Offset from label, in words | Value I saw  | My idea of what it is                                |
|-----------------------------|--------------|------------------------------------------------------|
| 0                           | 0            | ?                                                    |
| 1                           | 1            | ?                                                    |
| 2                           | 0            | ?                                                    |
| 3                           | 128          | width of image                                       |
| 4                           | 64           | height of image                                      |
| 5                           | differs      | ?                                                    |
| 6                           | differs      | ?                                                    |
| 7                           | differs      | ?                                                    |
| 8                           | 2 to 10      | number of knobs described below                      |
| 9                           | 2            | id of a knob described                               |
| 10                          | some x IRL   | on screen x of knob described                        |
| 11                          | some y IRL   | on screen y of knob described                        |
| 12                          | .fardata ptr | hex address of parameters of chosen knob image       |
| 13                          | 3 (4, 5 ...) | id of a next knob, and then x y and ptr are repeated |

So far I think knob IDs are used when effect code loads or stores knob values. ID 1 seems to be reserved or related to OnOff.

Positions are targeted at left top corner, not center, at least where I saw it.

Modifying x and y of knobs actually worked for me. Do not forget to change corresponding hex in ZDL.

Knob info section has structure of:

| Offset from start of section | Value I saw | My idea of what it is |
|------------------------------|-------------|-----------------------|
| 0                            | 20          | width of a knob       |
| 1                            | 15          | height of a knob      |
| 2                            | 11          | inner circle width ?  |
| 3                            | 0           | ?                     |
| 4                            | 5           | inner circle height ? |
| 5                            | 0           | ?                     |

Never edited it, had no need to.

Remember that pixels are not square, and 20 x 15 is actually a circle on screen, if little edgy.

# Baking it all together
Do not forget to apply _all_ the changes you want to ZDL.

Now, with modified ZDL, _replace_ the original ZDL you have, with original name, where your flashing tool picks it up. Make sure your flashing tool is using your version.

I leave flashing instructions to tool you chose, they are typically simple and consist of three steps, as original firmware update:
* Boot effect in firmware mode; for Multistomp it is UP + DOWN pressed when powering the unit.
* Run modified flasher.
* Wait until flashing is complete, close the flasher and power cycle the unit.

You should have a modified visual by now!
