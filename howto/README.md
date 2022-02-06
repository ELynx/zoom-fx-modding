# Section 0 - before the storm
You are about to create and flash a customized firmware to your trusty FX unit.

For this to succeed, first read instructions through, make sure you have all the materials and time to complete these steps.

N.B.: at this moment, I don't know how to add new FX to the unit. Using RainSel will replace LineSel on unit, until you flash original firmware back.

I recommend using laptop or desktop with UPS, and have good and charged battery.

I recommend using USB cable in good condition, with reliable connection.

If you ever want to repeat this process with new release or mod, make sure you start with backed up original FX file. I have backup step listed in instructions.

# Section 1 - software
Download [Zoom Effect Manager](https://vk.com/zoomeffectmanager). This is the tool to manage FXes on unit, and it is handy because it has all stock FXes prepared. I used version 1.1.1 at the time of writing this instructions.

Unpack the archive to location where you can access and modify all the files. Remember this location, from here on I will refer to it as `Z:\FOO`.

Download [Lunar IPS](http://fusoya.eludevisibility.org/lips/index.html). This is the tool that brings my difference to your legally obtained FX file. I used version 1.02, but when I checked the web page it had 1.03 released recently. I am sure that either will work.

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
If you are doing this not for the first time, remember to overwrite file in `effects` with a backup.

* Run Lunar IPS
* Choose `Apply IPS Patch`
* Choose the downloaded RAINSEL.ips
* When prompted to choose fle to path
  * Change filter from `Most Common ROM Files` to `All Files (*.*)`
  * Choose `Z:\FOO\files\effects\LINESEL.ZDL`
* Tool will report with `Patching Complete!`. Click OK to close it.
