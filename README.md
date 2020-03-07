This plugin aims to port commands from [Bukkit's Essentials](http://dev.bukkit.org/bukkit-plugins/essentials/) to Cuberite, but also to implement new commands. It provides non-vanilla commands that do not exist in Core.

# Warp Sign Template
[Warp]  
warpname

# Command Sign Template
[Command]  
/tell player  
hello <-- Notice the space before "hello" (alternatively at end of "/tell player")

# Enchant Sign Template
[Enchant]  
EnchantmentID  
EnchantmentLevel  
RequiredXPLevelToEnchant

# Portals
To create a portal, place a sign underneath a block with the following template:  

[Portal]  
Warpname  

When walking on top of the block, you will get teleported to the specified warp.

# Commands

### General
| Command | Permission | Description |
| ------- | ---------- | ----------- |
|/antioch | es.antioch | Spawns a TNT at the position you're looking at|
|/back | es.back | Returns you to your previous position|
|/biome | es.biome | Tells you the biome in which you are|
|/broadcast | es.broadcast | Broadcasts a message to all players|
|/burn | es.burn | Sets a player on fire|
|/delhome | es.delhome | Removes your home|
|/deljail | es.deljail | Removes a jail|
|/delwarp | es.dropwarp | Removes a warp|
|/depth | es.depth | Displays your height relative to sea level|
|/ext | es.ext | Extinguishes a player|
|/feed | es.feed | Satisfies the hunger|
|/fireball | es.fireball | Shoots a fireball|
|/fly | es.fly | Enables or disables flying|
|/god | es.god | Makes you immortal|
|/hat | es.hat | Use your equipped item as a helmet|
|/heal | es.heal | Heals a player|
|/home | es.home | Teleports you home|
|/itemdb | es.itemdb | Displays the item information of an item you are holding|
|/jail | es.jail | Jails a player|
|/jails | es.listjail | Lists all available jails|
|/lightning | es.lightning | Spawns lightning near a player|
|/locate | es.locate | Displays your current coordinates|
|/more | es.more | Increases the item amount in the held stack to 64 items|
|/mute | es.mute | Mutes a player|
|/near | es.near | Displays a list of nearby players|
|/nuke | es.nuke | Spawns a nuke above players|
|/ping | es.ping | Displays a message if the server is alive|
|/place | es.place | Teleports a player where you are looking|
|/powertool | es.powertool | Binds a command to the item you are holding|
|/repair | es.repair | Repairs the item you are holding|
|/sethome | es.sethome | Sets your home|
|/setjail | es.setjail | Creates a jail at your location|
|/setwarp | es.setwarp | Creates a warp at your location|
|/shout | es.shout | Displays a chat message in a range of 128 blocks|
|/skull | es.skull | Allows you to change the skin of a skull|
|/socialspy | es.socialspy | Displays other players' private messages|
|/spawnmob | es.spawnmob | Spawns a mob|
|/speed | es.speed | Changes a player's moving speed|
|/speed fly | es.flyspeed | Changes a player's flying speed|
|/speed walk | es.walkspeed | Changes a player's walk speed|
|/speed run | es.runspeed | Changes a player's running speed|
|/top | es.top | Teleports you to the highest block|
|/tpa | es.tpa | Requests teleportation to a player|
|/tpaccept | es.tpa | Accepts teleportation request|
|/tpahere | es.tpa | Requests teleportation of another player to you|
|/tpdeny | es.tpa | Denies teleportation request|
|/tphere | es.tp | Teleports a player to you|
|/unjail | es.unjail | Unjails a player|
|/unmute | es.unmute | Unmutes a player|
|/vanish | es.vanish | Enables or disables player visibility|
|/warp | es.warp | Moves player to location of a warp|
|/warps | es.listwarp | Lists all warps|
|/whisper | es.whisper | Displays a chat message in a range of 16 blocks|
|/whois | es.whois | Displays information about the specified player|
|/xp | es.xp | Manage XP for a player|
|/xp give | es.xp.give | Gives XP to a player|
|/xp set | es.xp.set | Sets current XP of a player|
|/xp show | es.xp.show | Shows XP of a player|



# Permissions
| Permissions | Description | Commands | Recommended groups |
| ----------- | ----------- | -------- | ------------------ |
| es.antioch |  | `/antioch` |  |
| es.back |  | `/back` |  |
| es.biome |  | `/biome` |  |
| es.biome.other | Shows you in which biome another player is |  | admins, mods |
| es.broadcast |  | `/broadcast` |  |
| es.burn |  | `/burn` |  |
| es.commandsign | Allows a player to create signs which execute commands |  | admins, mods |
| es.createportal | Allows a player to create a portal |  | admins, mods |
| es.delhome |  | `/delhome` |  |
| es.deljail |  | `/deljail` |  |
| es.depth |  | `/depth` |  |
| es.dropwarp |  | `/delwarp` |  |
| es.enchantsign | Allows a player to create Enchant Signs |  | admins, mods |
| es.ext |  | `/ext` |  |
| es.feed |  | `/feed` |  |
| es.feed.other | Satisfies the hunger of another player |  | admins, mods |
| es.fireball |  | `/fireball` |  |
| es.fly |  | `/fly` |  |
| es.fly.other | Enables or disables flying for another player |  | admins, mods |
| es.god |  | `/god` |  |
| es.hat |  | `/hat` |  |
| es.heal |  | `/heal` |  |
| es.heal.other | Heals another player |  | admins, mods |
| es.home |  | `/home` |  |
| es.home.unlimited | Allows a player to have an unlimited amount of homes |  | mods, players |
| es.itemdb |  | `/itemdb` |  |
| es.jail |  | `/jail` |  |
| es.lightning |  | `/lightning` |  |
| es.listjail |  | `/jails` |  |
| es.listwarp |  | `/warps` |  |
| es.locate |  | `/locate` |  |
| es.locate.other | Displays the position of another player |  | admins, mods |
| es.more |  | `/more` |  |
| es.more.other | Increases the item amount in another player's held stack to 64 items |  | admins, mods |
| es.mute |  | `/mute` |  |
| es.near |  | `/near` |  |
| es.nuke |  | `/nuke` |  |
| es.ping |  | `/ping` |  |
| es.place |  | `/place` |  |
| es.powertool |  | `/powertool` |  |
| es.repair |  | `/repair` |  |
| es.sethome |  | `/sethome` |  |
| es.setjail |  | `/setjail` |  |
| es.setwarp |  | `/setwarp` |  |
| es.shout |  | `/shout` |  |
| es.skull |  | `/skull` |  |
| es.socialspy |  | `/socialspy` |  |
| es.spawnmob |  | `/spawnmob` |  |
| es.spawnmob.other | Spawns a mob near another player |  | admins, mods |
| es.speed |  | `/speed` |  |
| es.top |  | `/top` |  |
| es.tp |  | `/tphere` |  |
| es.tpa |  | `/tpdeny`, `/tpa`, `/tpaccept`, `/tpahere` |  |
| es.unjail |  | `/unjail` |  |
| es.unmute |  | `/unmute` |  |
| es.vanish |  | `/vanish` |  |
| es.vanish.other | Enables or disables visibility for another player |  | admins, mods |
| es.warp |  | `/warp` |  |
| es.warpsign | Allows a player to create Warp Signs. |  | admins, mods |
| es.whisper |  | `/whisper` |  |
| es.whois |  | `/whois` |  |
| es.xp |  | `/xp` |  |
| es.xp.give |  | `/xp give` |  |
| es.xp.set |  | `/xp set` |  |
| es.xp.show |  | `/xp show` |  |
