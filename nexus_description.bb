[size=5][b]Overview[/b][/size]
[b]Auto Use Soap allows your party members to be automatically [i]cleansed [/i]after combat or upon entering camp[/b] provided they have soaps/sponges. For convenience, the mod also adds these items to the camp chest by default. [b]Just move at least one soap item to the inventories of the party members you want to be cleaned automatically.[/b]

It supports configurable options via a JSON file, but works out of the box. See the settings breakdown in the Configuration section below for more details.

[line][b][size=5][b]
Installation[/b][/size][/b]
[list=1]
[*]Download the .zip file and install using BG3MM, or use Vortex.

[/list][b][size=4]Requirements
[/size][/b][size=2][b][url=https://www.nexusmods.com/baldursgate3/mods/7676]Volition Cabinet[/url][/b][/size][size=2]
[url=https://github.com/Norbyte/bg3se]BG3 Script Extender[/url] [size=2](you can easily install it with BG3MM through its [i]Tools[/i] tab or by pressing CTRL+SHIFT+ALT+T while its window is focused)
[line]
[/size][/size][size=5][b]Configuration[/b][/size][size=2][size=2]
When you load a save with the mod for the first time, it will automatically create an auto_use_soap_config.json file with default options.

You can easily navigate to it on Windows by pressing WIN+R and entering
[quote][code]explorer %LocalAppData%\Larian Studios\Baldur's Gate 3\Script Extender\AutoUseSoap
[/code][/quote]
Open the JSON file with any text editor, even regular Notepad will work. Here's what each option inside does (order doesn't matter):

[font=Courier New]"GENERAL"[/font]:
    [font=Courier New]    "enabled"    [/font]: Set to true to enable the mod, false to disable it without uninstalling. Enabled by default.

[font=Courier New]"FEATURES"[/font]:
    [font=Courier New]    "add_soap_items"[/font] : Set to [font=Courier New]true[/font] to ensure the party has enough soap items for each member by adding to the camp chest. Enabled by default.
    [font=Courier New]    "use_when_entering_camp"[/font] : Set to [font=Courier New]true[/font] to use soap when entering camp. Enabled by default.
    [font=Courier New]    "use_after_combat"[/font] : Set to [font=Courier New]true[/font] to use soap after combat ends. Enabled by default.

"DEBUG":
    [font=Courier New]    "level"[/font] : 0 = no debug, 1 = minimal, 2 = verbose logs. Set to 0 by default.
[size=2]
[size=2][size=2][size=2][size=2][size=2][size=2]After saving your changes while the game is running, load a save to reflect your changes [/size][/size][/size][/size][/size][/size][/size][/size][/size][size=2][size=2][size=2][size=2][size=2][size=2][size=2][size=2][size=2]or run [font=Courier New]!aus_reload[/font] in the SE console.[/size][/size][/size][/size][/size][/size][/size][/size][/size][size=2][line][size=4][b]
[/b][/size][/size][size=5][b]Compatibility[/b][/size]
- This mod should be compatible with most game versions and other mods, as it mostly just listens to game events and does not edit existing game data.
﻿- Mods that create or edit soap items or behavior should be compatible.

[line][size=4][b]
Special Thanks[/b][/size]
Thanks to [url=https://www.nexusmods.com/baldursgate3/users/21094599]FocusBG3[/url] for some inventory helper functions and to [url=https://github.com/Norbyte]Norbyte[/url] for the Script Extender.

[size=4][b]Source Code
[/b][/size]The source code is available by unpacking the .pak file. Endorse on Nexus if you liked it!
[line]
[center][b][size=4][/size][/b][/center][center][b][size=4][/size][/b][center][b][size=4]My mods[/size][/b][size=2]
[url=https://www.nexusmods.com/baldursgate3/mods/6995]Waypoint Inside Emerald Grove[/url] - 'adds' a waypoint inside Emerald Grove
[b][size=4][url=https://www.nexusmods.com/baldursgate3/mods/7035][size=4][size=2]Auto Send Read Books To Camp[/size][/size][/url]﻿[size=4][size=2] [/size][/size][/size][/b][size=4][size=4][size=2]- [/size][/size][/size][size=2]send read books to camp chest automatically[/size]
[url=https://www.nexusmods.com/baldursgate3/mods/6880]Auto Use Soap[/url]﻿ - automatically use soap after combat/entering camp
[url=https://www.nexusmods.com/baldursgate3/mods/6540]Send Wares To Trader[/url]﻿[b] [/b]- automatically send all party members' wares to a character that initiates a trade[b]
[/b][b][url=https://www.nexusmods.com/baldursgate3/mods/6313]Preemptively Label Containers[/url]﻿[/b] - automatically tag nearby containers with 'Empty' or their item count[b]
[/b][url=https://www.nexusmods.com/baldursgate3/mods/5899]Smart Autosaving[/url] - create conditional autosaves at set intervals
[url=https://www.nexusmods.com/baldursgate3/mods/6086]Auto Send Food To Camp[/url] - send food to camp chest automatically
[url=https://www.nexusmods.com/baldursgate3/mods/6188]Auto Lockpicking[/url] - initiate lockpicking automatically
[size=2]
[/size][url=https://ko-fi.com/volitio][img]https://raw.githubusercontent.com/doodlum/nexusmods-widgets/main/Ko-fi_40px_60fps.png[/img][/url]﻿﻿[/size][/center][/center][url=https://www.nexusmods.com/baldursgate3/mods/7294][center][/center][center][img]https://i.imgur.com/hOoJ9Yl.png[/img]﻿[/center][/url][center][/center]
