# Section 0 - before the storm
You are about to create and flash a customized firmware to your trusty FX unit.

For this to succeed, first read instructions through, make sure you have all the materials and time to complete these steps.

N.B.: at this moment, I don't know how to add new FX to the unit. RainSel will replace LineSel on FX unit, until you flash firmware with original FX back.

I recommend using laptop or desktop with UPS, and have good and charged battery.

I recommend using USB cable in good condition, with reliable connection.

If you ever want to repeat this process with new release or mod, make sure you start with backed up original FX file, not modified version. I have backup step listed in instructions.

Notice: I had never lost FX settings while doing this, but I don't actually change firmware version, just mess around within one. Make a backup of all FX settings you may miss. There is software for it, or just take some pictures.

# Section 1 - software
Download [Zoom Effect Manager](https://vk.com/zoomeffectmanager). This is the tool to manage FXes on unit, and it is handy because it has all stock FXes prepared. I used version 1.1.1 at the time of writing this instructions.

Unpack the archive to location where you can access and modify all the files. Remember this location, from here on I will refer to it as `Z:\FOO`.

Download [Lunar IPS](http://fusoya.eludevisibility.org/lips/index.html). This is the tool that brings my difference to your legally obtained FX file. I used version 1.02, but when I checked the web page version 1.03 released recently. I am sure that either will work.

Download RAINSEL.ips from [Releases](https://github.com/ELynx/zoom-fx-modding/releases) page.

# Section 2 - make customized firmware
## Make a backup of LINESEL.ZDL
Lunar IPS modifies files in-place, make a backup first time you do this.

* Start from `Z:\FOO`
* Navigate to `Z:\FOO\files\effects`
* Find `LINESEL.ZDL`
* Make a copy of it, to folder outside of `effects`.

If you ever lose this backup, don't panic. You can restore LineSel on FX unit by just flashing official firmware. Backing it up is a convenience only.

## Modify LINESEL.ZDL
If you are doing this not for the first time, remember to replace file in `Z:\FOO\files\effects` with a backup.

* Run Lunar IPS
* Choose `Apply IPS Patch`
* Choose the downloaded RAINSEL.ips
* When prompted to choose file to patch
  * Change filter from `Most Common ROM Files` to `All Files (*.*)`
  * Choose `Z:\FOO\files\effects\LINESEL.ZDL`
* Tool will report with `Patching Complete!`. Click OK to close it.

If you want, you can also backup patched file, in case you need to swap between original and modded and don't want to apply IPS again.

# Section 3 - prepare and flash custom firmware
Firmware is created with Zoom Firmware Manager. Launch it's executable from `Z:\FOO` folder, and follow the instructions for it.

In simple terms, select your FX unit type, select effects you would like.

Make sure LINESEL.ZDL is included, this is the modded FX now.

Warning: steps below are steps to actually flash a firmware to your unit. Observe all manufacturer's recommendations for firmware update, all instructions from Zoom Effect Manager. Make sure to not to break USB connection, lose power, etc. Process takes about 5 minutes to complete. Have some patience and refrain from (un)plugging MIDI and USB devices. In my experience, these are the only steps you have to be actively careful about.

Boot your FX unit in firmware update mode. Overall, look into the manual, but for MS-60B I have at hand this is done by pressing UP and DOWN, and then powering the unit with USB cable. Unit will skip usual animation and have special screen. Windows may discover new USB and MIDI devices, if process is done for the first time.

Go back to Zoom Effect Manager.

In the lower left corner, click `Write Effects`.

Modified firmware update software will launch. This is the same software as for official firmware update, just loaded with customized list of effects.

Within firmware update software, follow on-screen instructions. This is the actual flashing part.

Software on desktop will notify you that flashing is done, exit it.

On FX unit, you will see a prompt to restart. Power cycle the unit.

Congratulations, you are done! (Or my condolences, if this somehow failed.)

# Section 4 - use the effect

RainSel had replaced all of instances of LineSel, if you had any. It may be a good time to visit saved patches and see if they still do what you expect.

RailSel was not meant to be used as on/off effect (however who am I to tell you what to do), rather as support brick at the end of your chain.

In "BOTH MIX" position, processed and original input signals are both sent to next FX (or output).

In "L/R" position, left channel outputs processed signal, and right channel is replaced with original signal (for me this is same input, I have no FX unit with stereo input).

Knobs control levels of processed (WET) and original (DRY) signals.

In "L/R" position, right channel of previously stereo FX output is in general lost. Overall, built-in effects have strange relations to stereo / mono processing, but that is how whole FX was made, this particular mod just makes this little bit more noticeable.

One hint I discovered within 5 minutes of messing with modded FX: original single means original noise. My test source had high background hum which I cancelled with `ZNR` at the start of the chain. After modding, I moved it right after the RainSel, and it seems to handle modded output just fine.

# Section 5 - restoring original effects

If you want to roll back the changes, download original firmware update from official Zoom Co web site, and do the flashing steps again.
