# Call Of Duty 2 - server documentation
Full credit goes to http://anarchyrules.co.uk/cod2/server%20commands.html

## Map Name
All maps are available in each gamemodes:
- `dm`: death match
- `tdm`: team death match
- `sd`: search & destroy
- `ctf`: capture the flag
- `hq`: headquarter

Map name list:
- `mp_breakout`
- `mp_brecourt`
- `mp_burgundy`
- `mp_carentan`
- `mp_dawnville`
- `mp_decoy`
- `mp_downtown`
- `mp_farmhouse`
- `mp_leningrad`
- `mp_matmata`
- `mp_railyard`
- `mp_toujane`
- `mp_trainstation`

## Console Commands
Here are the available commands you can use to control your server.

Usage :
* from the server console: just type the command directly.
* from the in-game console:
  * Enable in-game console in server configuration (`sv_disableClientConsole=0`);
  * Log in using [`rcon login`](#rcon);
  * add the `/rcon` prefix to the command.

### rcon
* `/rcon login [rconpassword]`:
Login to remote rcon. **Be VERY carreful not leaking your password when using rcon login !**

### Common
* `status`:
Displays info of all the players on the server.
* `serverinfo`:
Shows the current server's settings.
* `systeminfo`:
Shows the current system information.
* `tell [id]`:
Sends private message to specified client id
* `say`:
Broadcast a message to all players
* `exec [FILENAME]`:
Executes a Server Config File (located in your server's main directory)
* `writeconfig [FILENAME]`:
Saves a Server Config File

### Gameplay
* `matchtimeout`:
Calls a match timeout (see server cvars for timeout settings)
* `matchtimein`:
Cancels timeout
* `setkillcam`:
Set the killcam cvar (now that it is read only during play)
* `setfriendlyfire`:
Set the friendly fire cvar (now that it is read only during play)
* `setdrawfriend`:
Set the draw friend cvar (now that it is read only during play)


### Map commands
* `map mapname`:
Loads the map specified by mapname.
* `map_rotate`:
Loads next map in rotation set in sv_maprotation.
* `map_restart`:
Restarts the map.

### Kick/ban Commands
* `kick [name]`:
Kicks a player by name from the server. (Must include Color Codes)
* `rcon onlykick [name]`:
Kicks a player by name from the server. (Does not need Color Codes)
* `clientkick [id]`:
Kicks a player by client id from the server.
* `kick all`:
Kicks all players from server
* `banUser [name]`:
Bans a user by their ingame name. Writes their GUID to ban.txt
* `banClient [id]`:
Bans a user by their client number. Writes their GUID to ban.txt
* `tempBanUser [name]`:
Kicks and temporarily bans player by name from server.
* `tempBanClient [id]`:
Kicks and temporarily bans player by client id from server
* `unban [name]`:
Unban every player banned with [name]. If you want to unban a single player whose name appears more than once, you should edit "ban.txt" manually.

## Server config
Server config files can be found in the [/cod2server/main](https://github.com/bgauduch/call-of-duty-2-docker-server/tree/master/cod2server/main) directory.

A note on server path:
* `set fs_basepath`: set the game folder, where the `config` and `.iwd` files are.
* `set fs_homepath`: set the multiplayer log file and live config folder.

Server config generator: https://www.opferlamm-clan.de/config-generator-cod2.html

## Server logs
There is two types of logs:
* The **server** logs:
  * It's the output of the server binary when executed.
  * It contains server informations, map rotation, etc.
* The **game** logs:
  * It's written by the server binary to a file, created under `$fs_homepath/main/games_mp.log` by default.
  * It contains all game information (kills, dammages, players join / quit, chat message, etc)
