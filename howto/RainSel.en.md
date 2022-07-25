# RainSel
N.B. RailSel is my first effect, and now it, and text below, are outdated. Like [this Issue](https://github.com/ELynx/zoom-fx-modding/issues/7) to let me know if you need an update. Otherwise, text below is old.

RailSel was not meant to be used as on/off effect (however who am I to tell you what to do), rather as support brick at the end of your chain.

In "BOTH MIX" position, processed and original input signals are both sent to next FX (or output).

In "L/R" position, left channel outputs processed signal, and right channel is replaced with original signal (for me this is same input, I have no FX unit with stereo input).

Knobs control levels of processed (WET) and original (DRY) signals.

In "L/R" position, right channel of previously stereo FX output is in general lost. Overall, built-in effects have strange relations to stereo / mono processing, but that is how whole FX was made, this particular mod just makes this little bit more noticeable.

One hint I discovered within 5 minutes of messing with modded FX: original signal means original noise. My test source had high background hum which I cancelled with `ZNR` at the start of the chain. After modding, I moved it right after the RainSel, and it seems to handle modded output just fine. Try different positions of "Effect In / Guitar In" toggle on `ZNR` to see that works better for your chain.
