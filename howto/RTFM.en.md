# RTFM
## About this document
This is a page with instructions for RTFM v1.1.0

Be sure that you are reading correct version.

If you followed the QR code, you should be set, since each release comes with relevant URL embedded.

If you opened this page manually, and version is different, look for tag that matches your version. Corresponding picker is usually to the top left of document view. It usually says something like `main` by default. When clicked, it will provide options `Branches` and `Tags`. Choose `Tags` and choose tag that starts with RTFM and the gives your version.

## What it does
This mod is intended to be used most with MS-70CDR to allow parallel processing of two signals on same unit.

Requires [Div0](Div0.en.md) to work, otherwise mixes Left and Right together, and overall has shitty behavior.

I recommend starting Div0 with LEFT 0, RIGHT 100, ON. Later turn off Div0 only if some effect mixes Left to the mix, because it may turn off more than needed.

## Capabilities and how to make FX chains
TL;DR: most effects will work before, _only stereo_ effects will work after well. Only stereo _with independent channels_ will work superb.

Div0 goes first. Then 1 group of effects. Then RTFM. Then 2 group of effects. If stars align, one channel will be processed by group 1, another by group 2. Button toggles which channel-group affinity.

This effect does not do any _magic_ to signal processing, so results are not _magical_.

All effects before RTFM process signal as usual. This means that most of stock effects I [tested on MS-60B](#before-rtfm) worked without problem, even if results are not superb.

Result of "before" effects is then processed by RTFM.

For one channel, effects are "silenced", and routed directly to same side Output. This achieves "chain one" logic.

For another channel, processed signal is replaced with original signal that was preserved. So, any FX is "forgotten" and "chain two" logic starts.

For best performance, effects in 2 group should not mix channels together. Thus, only effects with independent stereo work 100% well. As examples I can list `DriveEcho`, `CoronaTri` etc.

1 group can have almost everything, if effect is not implemented in super-strange way. I tried mono effects, such as pitchers, they work quite well.

For tech-minded, here is the diagram:

<img src="rtfm.png">

State is shown for RTFM ON, when 1 group processes Left channel. When effect is OFF, channels swap their logic.

## Closing words
This mod works with all the limitations original effects have regarding to stereo processing, and then some. I think Zoom Co already did great work with stereo effects, and this mod is mostly pushing multistomp to the limits. That said, experiment.

## Tips
If you found this useful, you can leave me some tips, instructions are [here](../README.md#i-want-to-support-you-with-money).
