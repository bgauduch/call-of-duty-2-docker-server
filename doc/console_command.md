# Call Of Duty 2 server console commands

Here are the available commands you can use in the server terminal:

* **map mapname**
Loads the map specified by mapname.

* **map_rotate**
Loads next map in rotation set in sv_maprotation.

* **serverinfo**
Shows the current server's settings.

* **map_restart**
Restarts the map.

* **kick [name]**
Kicks a player by name from the server. 

* **clientkick [id]**
Kicks a player by client id from the server.

* **status**
Displays info of all the players on the server.

* **banUser [name]**
Bans a user by their ingame name. Writes their GUID to ban.txt

* **banClient [id]**
Bans a user by their client number. Writes their GUID to ban.txt

* **tempBanUser [name]**
Kicks and temporarily bans player by name from server.

* **tempBanClient [id]**
Kicks and temporarily bans player by client id from server

* **unban [name]**
Unban every player banned with [name]. If you want to unban a single player whose name appears more than once, you should edit "ban.txt" manually.

* **tell [id]**
Sends private message to specified client id

* **matchtimeout**
Calls a match timeout (see server cvars for timeout settings)

* **matchtimein**
Cancels timeout

* **setkillcam**
Set the killcam cvar (now that it is read only during play)

* **setfriendlyfire**
Set the friendly fire cvar (now that it is read only during play)

* **setdrawfriend**
Set the draw friend cvar (now that it is read only during play)
