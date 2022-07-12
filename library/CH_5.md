# Chapter 5 – Shrinker
A small description of [shrinker](../diy/shrinker.py).

This is a side effect of looking at ELFs inside for a too long time. After running across them with all examination tools I could find, I thought that I can reduce the size of each file by removing debug symbols.

By far, this is not my original idea. I had seen it mentioned, and even potentially done _somewhere_ on guitar forums. But alas I do not remember where, and cursory search reveals nothing. I will gladly refer to any earlier mentions, given the link.

All the tool does is:

* Separate headers and ELF that make ZDL file
* Run `strip6x` on EFL
* Pack newly shrunk ELF and headers back into ZDL

It runs on current working directory, and expect `strip6x` to be available for call. I just copy-pasted executable to same folder as `.ZDL`s...

This is an engineering tool, so expect sharp edges. And this was meant to be ran once, so code quality is sub-par.

Remember that any IPS need proper file to be offset against. Differentiate between shrunk and original versions.

For me, on my test MS-70CDR, all built-in patches worked OK on cursory check. Do a couple practices before the gig, but this is not very radical mod.
