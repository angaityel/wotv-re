# War of the Vikings Launch Fix
Launch War of the Vikings game without backend.
- Everything's unlocked.
- Training works.
- Multiplayer works. Select Join or Host(You can change map and game mode).
## Using
> [!WARNING]
> Use at your own risk.
- Download [latest release](https://github.com/angaityel/wotv-re/releases)
- Unpack files from bundle.zip to bundle folder (e.g. C:\Program Files (x86)\Steam\steamapps\common\War of the Vikings\bundle\\)
- In game folder: Shift + Right-click on wotv.exe - select Copy as path
- Go to Steam - Library - right click War of the Vikings - Properties - LAUNCH OPTIONS
- Paste your copied path and add %command% at the end after space
- "your path to wotv.exe" %command%

Examples of how it should look like:
```
"C:\Program Files (x86)\Steam\steamapps\common\War of the Vikings\wotv.exe" %command%
"D:\Games\SteamLibrary\steamapps\common\War of the Vikings\wotv.exe" %command%
```
- Launch game
## Additional launch options
Lobby name and player limit:
- -lobbyname "server name": custom names for servers.
- -lobbymaxmembers 256: server player limit, default value without command is 256.
- -timelimit 123456: round time in seconds.
- -winscore 123: round win score (up to 1000).

And lobby visibility:
- -lobbyprivate: private server (probably useless, invites don't seem to work).
- -lobbyfriends: friends only server (only friends can see or join? Not tested).

You can add these commands to game launch options after %command%.

Should look something like this:
```
"your path to wotv.exe" %command% -lobbyname "my super-duper server" -lobbymaxmembers 8
```
## Hosting games
Create a .bat file in game folder with:
```
wotv.exe -bundle-dir bundle -autohost -network-hash "" -no-rendering -level Forest -game-mode tdm
```
It's the same as hosting in-game, only without rendering.

This should prevent game from crashing with 5+ players, but host won't be able to play.

For map rotation change map_rotation.ini and add command to launch option:
```
-ini launch_server_settings
```
If you want random map rotation add:
```
-ini launch_server_settings -random-map
```
Maps and available modes:
```
Cliff - tdm, con, battle, arena, ass
Forest - tdm, con, battle, ass
Docks - tdm, con, battle, arena, headhunter
Gauntlet - tdm, arena
Monastery - tdm, arena
Crag - tdm, arena
Sanctuary - tdm, arena
Icefloe - tdm, arena
Stronghold - tdm, con, battle
Village - tdm, domination
Ravine - tdm, con, battle
Tide - tdm, arena
Ruins - arena
Northbound - con, battle
Strand - tdm, battle
Outpost - tdm, domination
Mire - tdm, battle
```
## Build
Use this version of LuaJIT for compiling lua files:

https://github.com/LuaJIT/LuaJIT/releases/tag/v2.0.1-fixed

To create patch files, use:

https://github.com/angaityel/bundle-explorer

