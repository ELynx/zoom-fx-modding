# RTFM
## About this document
This is a page with instructions for RTFM v1.0.0

Be sure that you are reading correct version.

If you followed the QR code, you should be set, since each release comes with relevant URL embedded.

If you opened this page manually, and version is different, look for tag that matches your version. Corresponding picker is usually to the top left of document view. It usually says something like `main` by default. When clicked, it will provide options `Branches` and `Tags`. Choose `Tags` and choose tag that starts with RTFM and the gives your version.

## Inputs and outputs
This mod is intended to be used most with MS-70CDR to allow parallel processing of two signals on same unit. As such, it makes use of both L and R on inputs and outputs.

This _can_ run on MS-50G (I expect it to) and MS-60B (I tested it to), but will lack versatility. On my MS-60B it works in "Off" position, and routes single input signal to two sets of effects, then to different outputs.

Knobs allow for adjusting gain of Left and Right channel volumes, plus you can use volume knobs inside individual effects as well.

## Capabilities and how to make FX chains
TL;DR: most effects will work before, _only stereo_ effects will work after well. Only stereo _with independent channels_ will work superb.

This effect does not do any _magic_ to signal processing, so results are not _magical_.

All effects before RTFM process signal as usual. This means that most of stock effects I [tested on MS-60B](#before-rtfm) worked without problem, even if results are not superb.

Result of "before" effects is then processed by RTFM.

For one channel, effects are "silenced", and routed directly to same side Output. This achieves "chain one" logic.

For another channel, processed signal is replaced with original signal that was preserved. So, any FX is "forgotten" and "chain two" logic starts.

So, all effects after RTFM _have to support stereo_ for correct processing. Most of stock effects I [tested on MS-60B](#after-rtfm) make various degrees of mess. Pick ones that support independent stereo processing, and turn that processing on.

## Tested effects
### Before RTFM
Effects I tested __on MS-60B__:

* ZNR - Works but does not do much because noise returns for chain two.
* BaFzSmile - Works, staple of my test sound.

### After RTFM
Effects I tested __on MS-60B__:

* ZNR - Works, with some tweaks is good with mono in. On stereo effects I don't think it gates channels independently, so YMMW.
* VinFLNGR - Works, but leaks signal across channels. Meh.
* StereoDly - Works, and I think respects two chain processing with mono in.
* DriveEcho - Works when "Stereo" is on. Nice sound.

## Closing words
This mod works with all the limitations original effects have regarding to stereo processing, and then some. I think Zoom Co already did great work with stereo effects, and this is mostly pushing to the limits.

That said, experiment. This has a limited working effect combination, but for OD on one channel and some echo on other, it should get the job done.

## Tips
If you found this useful, you can leave me some tips, instructions are [here](../README.md#i-want-to-tip-you-some-).
