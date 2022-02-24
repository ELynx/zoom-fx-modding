# Section 0 - before the storm
You are about to create and flash a customized firmware to your trusty FX unit.

For this to succeed, first read instructions through, make sure you have all the materials and time to complete these steps.

I recommend using laptop or desktop with UPS, and have good and charged battery.

I recommend using USB cable in good condition, with reliable connection.

If you ever want to repeat this process with new release or mod, make sure you start with original FX file, not modified version.

Notice: I had never lost FX settings while doing this, but I don't actually change firmware version, just mess around within one. Make a backup of all FX settings you may miss. There is software for it, or just take some pictures.

# Section 1 - software
Download [Zoom Effect Manager](https://vk.com/zoomeffectmanager). This is the tool to manage FXes on unit, and it is handy because it has all stock FXes prepared. I used version 1.1.1 at the time of writing this instructions.

Unpack the archive to location where you can access and modify all the files. Remember this location, from here on I will refer to it as `Z:\FOO`.

Download [Lunar IPS](http://fusoya.eludevisibility.org/lips/index.html). This is the tool that brings my difference to your legally obtained FX file. I used version 1.02, but when I checked the web page version 1.03 released recently. I am sure that either will work.

Download .ips for effect you want from [Releases](https://github.com/ELynx/zoom-fx-modding/releases) page.

Have notepad software ready. Built-in notepad should work.

# Section 2 - make customized firmware
## Make copy / copies of LINESEL.ZDL for modification
Do this step for each .ips file you want to use.

Lunar IPS modifies files in-place, make a source file for it. Remember to always start from unmodified LINESEL.ZDL, not version that was already patched.

* Start from `Z:\FOO`
* Navigate to `Z:\FOO\files\effects`
* Find `LINESEL.ZDL`
* Make a copy of it, and name it appropriately:
  * RainSel - `RAINSEL.ZDL`
  * RTFM - `RTFM.ZDL`

## Modify copied ZDL
Do this step for each .ips file you want to use. For `FOO.ips` I assume prepared copy of `FOO.ZDL` from step above.

* Run Lunar IPS
* Choose `Apply IPS Patch`
* Choose the downloaded .ips file
* When prompted to choose file to patch
  * Change filter from `Most Common ROM Files` to `All Files (*.*)`
  * Choose `Z:\FOO\files\effects\FOO.ZDL`
* Tool will report with `Patching Complete!`. Click OK to close it.

## Modify known FX list
Version 1.1.1 of Zoom Effect Manager was not designed with custom FX in mind, and have prepared list of effects. This step will append that list to make new FX selectable.

* Navigate to `Z:\FOO\files`
* Open effects_settings.csv with Notepad
* Scroll to the bottom. Disable line wrap if that makes it easier to orient
* Add following lines at the bottom:

RainSel

`XXX;RailSel;RAINSEL.ZDL;;MS-50G;MS-60B;MS-70CDR;G1on;B1on;Rain Sel EN;Rain Sel RU;FLTR;0x02;1.01`

RTFM

`XXX;RTFM;RTFM.ZDL;;MS-50G;MS-60B;MS-70CDR;G1on;B1on;R.T.F.M. EN;R.T.F.M. RU;FLTR;0x02;1.00`

* Replace XXX with appropriate number(s) to continue indexing. For me these were 235 and 236 for both FX.

# Section 3 - prepare and flash custom firmware
Firmware is created with Zoom Firmware Manager. Launch it's executable from `Z:\FOO` folder, and follow the instructions for it.

In simple terms, select your FX unit type, select effects you would like.

Make sure modded FX you want are included.

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
[RailSel](RainSel.en.md)

[RTFM](RTFM.en.md)

# Section 5 - restoring original firmware
If you want to roll back the changes, download original firmware update from official Zoom Co web site, and do the flashing steps again.
