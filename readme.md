## Commands to manage guild

* `/list_guilds` : lists all guilds
* `/join_guild <guild_name>`   : join a guild if it exists
* `/leave_guild <guild_name>`  : leave a guild
* `/create_guild <guild_name> [color]` : create a guild
* `/remove_guild <guild_name>` : players with `guild_priv` can delete the guild
* `/guild_info <guild_name>`   : prints guild info
* `/gm <msg>` : sends a private message to all guild members

* guild by default modifies the chat so other mods that have similar behaviour might interfere

NOTE : This mod support following mods : censor (mightyjoe781), ranks (octacian), xp_redo (mtmods)

TODO :

* extend api.lua to have gulid store more metadata
* add a random colorization to guild names while writing guild colors or maybe approach a fixed coloration for each guild
* create a concept of guild leader around the mod to allow leader to have following features
  * leader can rename the guild
  * leader can appoint someone as their leader
  * leader can remove people from the guild
  * leader can add people from the requests
  * player can send request to be added into the guild
* add a gui to easily manage guild