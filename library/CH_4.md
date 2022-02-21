# Chapter 4 - ZDL header format
Remember that all integer values longer than one byte are stored with Little Endianness ([Wikipedia](https://en.wikipedia.org/wiki/Endianness)).

Next up, to my understanding ZDL header consists of `Sections`. Each `Section` starts with four bytes name, ASCII, and four bytes section size, not including 8 bytes already used for definition.

And at last, ZDL "magic", if that can be said about these values, is `0x00 0x00 0x00 0x00`. Not sure why four zeros are needed at the start. My only idea is to call this "NULL" section... Anyway, file opens with four zero bytes, keep that in mind.

So far I have seen only four types of section (of what files I cared to manually check) and started to decode only two of them that relate to matters at hand to me (to put mods with originals, not instead).

## SIZE
Very simple section that tells size of headers and size of ELF.

| Size, bytes | My name for it | Notable values I saw | Commentary                                                                                     |
|-------------|----------------|----------------------|------------------------------------------------------------------------------------------------|
| 4 ASCII     | Section name   | SIZE                 |                                                                                                |
| 4 LE        | Section size   | 8                    | on top of 8 used by name and size                                                              |
| 4 LE        | Header size    | 56, 232, 312         | 56 is most typical, 232 is when [BCAB](#bcab) is present, 312 is when [CABI](#cabi) is present |
| 4 LE        | ELF size       |                      | matches size of ELF portion of the file                                                        |

Note that `Header size` tells size of _remaining_ headers. So, in most effects, total size used up by headers is 4 + 16 + 56 = 76 : 4 bytes used by leading zeros, 16 bytes by SIZE section, and 56 used by INFO section.

## INFO
This is where interesting and exploratory is stored.

| Size, bytes | My name for it | Notable values I saw | Commentary                                                                                                          |
|-------------|----------------|----------------------|---------------------------------------------------------------------------------------------------------------------|
| 4 ASCII     | Section name   | INFO                 |                                                                                                                     |
| 4 LE        | Section size   | 48                   |                                                                                                                     |
| 32 ASCII    | Version string | Z.... \0             | null-terminated string in my opinion. Otherwise, this is 31 ASCII and 0x00 byte always                              |
| 1           | Real FX type   | 15, 20 and 22; other | type of file from unit side; IMO this value is how unit decides what to do with FX                                  |
| 1           | Unknown 1      | 0, 1 and 20          | haven't figured this one out. 20 is especially strange                                                              |
| 1           | Knob type ?    | 0, 1 and 2           | majority of FX have this as 0; GEQ "family" have 1; LineSel has 2                                                   |
| 1           | Unknown 2      | 0 and 1              | not much system I see here                                                                                          |
| 1           | Sort index     | 12, 53               | most are powers of 8, but some are not; highest one I saw from original is 240                                      |
| 1           | Sort sub-index | 0, 1 and 2           | if two effects share same sort index, they get different sort sub-index; at least IMO                               |
| 1           | Flags for bass | 0 vs 16 / 64 / 96    | FX types 5, 20 and 22 have 16, 64 and 96 correspondingly; this looks like some bits set to me                       |
| 1           | Sort FX type   | 15                   | type of file from UI side; IMO this value is how unit shows FX during sorting; 20 and 22 are mapped to 1, 15 is not |
| 8 ASCII     | FX version     | 1.00\0 or 1.01\0     | null-terminated string in my opinion. Otherwise, this is 4 ASCII and 4 0x00 bytes always                            |

It does not appear to be that each FX has some unique identifier. It is more likely that combination of "Sort FX type", "Sort index" and "Sort sub-index" is used to present FX during UI choice. One item in favor of this is when I added two FX with same parameters unit worked OK, it was just not possible to scroll past duplicates: skip occurred in one direction and infinite loop in other. Thus, to add to FX range I see fit to "extend" "Sort index" field above 240, leaving 15 positions to claim for each group, with more sub-positions to come.

For "Knob type ?" I presume 0 means "old boring rotary knob", 1 means "slider" and 2 means black frame unique to LineSel. To be tested, but I have another focus right now.

"Unknown 1" or "Unknown 2" do not present any discernable pattern for me right now. They seem not to correlate with mono/stereo, or unit they appear in. Value 20 seems to throw me completely off as well, as any other "outlier" in unknown dataset.

"Flags for bass" is heavily correlated to "Real FX type" as noted. To me it seems to be some "reserved field" that got usage when 5, 20 and 22 got used. Maybe when not null, these are flags that restrict FX to certain unit; or notify firmware that some additional action had to be taken, like loading additional .ZDL.

FX type information is mostly taken from unpublished branch of [Zoom Firmware Editor](https://github.com/Barsik-Barbosik/Zoom-Firmware-Editor/blob/58001a6068d1a656564a59c6110b4f77d3429e33/src/main/java/zoomeditor/enums/EffectType.java) with minor commentary from me:

| Real FX type | Human-readable name | Commentary                |
|--------------|---------------------|---------------------------|
| 1            | Dynamics            |                           |
| 2            | Filter              |                           |
| 3            | Guitar drive        |                           |
| 4            | Guitar AMP          |                           |
| 5            | Bass AMP            |                           |
| 6            | Modulation          |                           |
| 7            | SFX                 | As if other are _not_ SFX |
| 8            | Delay               |                           |
| 9            | Reverb              |                           |
| 11           | Pedal operated      | Come from ..xon platform  |
| 15           | Extra DLL           | Used for ...CMN...ZDL     |
| 20           | Bass drive          | Maps to 1 for sorting     |
| 22           | Bass drive          | Maps to 1 for sorting     |

In my experiments, Pedal operated 11 ran OK on my MS-60B, but of course lacked pedal sweeping.

## BCAB
Not the section I have a lot of interest for right now. Has declared information size of 168 bytes, and follows usual layout of name-size-content. I see ASCII cab name here, and rather sparse area.

## CABI
Another section I don't have a lot of interest right now. Has declared information size of 248 bytes, and also follows usual layout of name-size-content. I again see ASCII cab name, but more dense concentration of values.
