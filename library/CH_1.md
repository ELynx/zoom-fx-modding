# Chapter one – how to change a picture
Get firmware flasher manipulator, pick one of listed in [README](README.md) or any other that you have.

Get ZDL file you want to modify. Manipulators have them prepared, or can extract them. Grab the one you like to experiment upon.

Now, ZDL file is an [ELF]( https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) file with some ZDL prefix information. At time of writing, I could not know what that ZDL information header is, so let’s just cut it off =)

With hex editor, open ZDL file, and cut off everything before ELF magic. Note, it starts with 0x7F, not letter E. Save yourself some sanity and cut where it should be. Save the result as you wish, I just placed it into folder with binary toolset.

Invoke the disassembler! Given you started with FOO.ZDL and named your truncated file FOO.ELF, call:
* dis6x FOO.ELF foo.asm
* dis6x FOO.ELF -b -s foo_data_as_bytes.asm

For now, use foo_data_as_bytes.asm. Find a section .data with name starting with `pic` or `picture` and effect name in it. Bingo, this is where the picture is encoded.

Copy the whole section, get rid of the .byte prefix and put a comma after each one but last. Text editor with macros can help a lot.

Paste the resulting ledger of misery into [decoder](../diy/decode_picture.py) into inputBytes and run.

If everything goes well, you will have an ASCII presentation of the FX you are looking for.

Edit at your heart’s desire, just keep resulting size smaller than original. Remember that used box symbols are quite to scale with pixels on screen, they are not squares but rectangles. In NPP, zoom out to full extend and it actually looks like the screen =)

 Ready? Copy your text into [encoder](../diy/encode_picture.py) into inputText, and run.

You will get a hex output at the bottom.

Open the ZDL you got, and find the start of original picture. Look for those start bytes you got, and replace starting from them with your hex. Do not forget to pad the remainder with zeros, if your result is smaller than the original. You can consult with foo.asm for byte values, just mind the endiness.

# Optional: knob positions, text labels
Look for ASCII OnOff either in binary, or (reversed) in foo.asm. Next to it, you will find other labels, including visible effect name and captions over rotors in the edit menu. After the label, there are stored maximum and default values, but so far I think they are replaced with constants in place, so I did not edit them.

Look for section effect type info in foo.asm. So far I know that structure is (by word):
* 0 - ?
* 1 - ?
* 0 - ?
* 128 - width?
* 64 - height?
* ?
* ?
* ?
* N - number of knobs
* 2 - id of 1st knob, I expect id 1 is for on off
* x of 1st knob
* y of 1st knob
* address of 1st knob (see disassembly for this section)
* 3 – id of 2nd knob

And so on.

Positions are targeted at left top corner, not center, at least where I saw it.

Knob info section has structure of (words) width – height – inner width ? - ? – innher high ? - ?. Never edited it, had no need to.

Modifying x and y of knobs actually worked for me. Do not forget to change corresponding hex in ZDL.

Now, with modified ZDL, _replace_ the original ZDL you have, and flash it. I leave flashing instructions to tool you chose, they are typically simple and consist of three steps:
* Boot effect in firmware mode, for Multistomp it is UP+DOWN pressed when powering the unit.
* Run modified flasher.
* Wait until flashing is complete, close the flasher and power cycle the unit.

You should have a modified visual by now!
