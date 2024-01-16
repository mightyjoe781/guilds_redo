## Commands to manage guild

* `/list_guilds` : lists all guilds
* `/join_guild <guild_name>`   : join a guild if it exists
* `/leave_guild <guild_name>`  : leave a guild
* `/create_guild <guild_name> [color]` : create a guild (color is optional) and joins it
* `/remove_guild <guild_name>` : players with `guild_priv` can delete the guild
* `/guild_info <guild_name>`   : prints guild info
* `/guild_color <guild> [color]`: changes guild_color you are owner of (color is optional)
* `/gm <msg>` : sends a private message to all guild members

* guild by default modifies the chat so other mods that have similar behaviour might interfere

NOTE : This mod support following mods : censor (mightyjoe781), ranks (octacian) [NOTE: ranks.prefix_chat should be set as false], xp_redo (mtmods)

TODO :

* create a concept of guild leader around the mod to allow leader to have following features
  * leader can rename the guild
  * leader can appoint someone as their leader
  * leader can remove people from the guild
  * leader can add people from the requests
  * player can send request to be added into the guild
* add a gui to easily manage guild
* factions wars and shared_areas and items
-- very ambitious goal ;0
* if the leader of a faction is killed by another leader then guilds merge
* if the player of some faction kills another leader he becomes owner of guild