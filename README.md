Essentials
===========

This plugin aims to port commands from [Bukkit's Essentials](http://dev.bukkit.org/bukkit-plugins/essentials/) to Cuberite, but also to implement new commands. It provides non-vanilla commands that do not exist in Core.

### Features

- Over 30 commands.

- Warps

- Jails

- Homes

### Commands

| Command | Aliases | Permission | Permission (affects other players) | Description |
| ------- | ------- | ---------- | ---------------------------------- | ----------- |
|/antioch | /grenade, /tnt | es.antioch | | Spawn a TNT in the location you're looking at.|
|/back | /return | es.back | | Return to last known position.|
|/biome | | es.biome | es.biome.other | Tells you the biome in which you are.|
|/broadcast | /bcast, /bc, /say | es.broadcast | | Broadcast a message to all players.|
|/burn | | es.burn | | Set a player on fire.|
|/delhome | /remhome, /rmhome | es.delhome | | Delete a home.|
|/deljail | /remjail, /rmjail | es.deljail | | Delete a jail.|
|/delwarp | /remwarp, /rmwarp | es.dropwarp | | Delete a warp.|
|/depth | /height | es.depth | | Displays your height relative to sea level.|
|/ext | /extinguish | es.ext | | Extinguish a player.|
|/feed | /eat | es.feed | es.feed.other | Satisfy the hunger.|
|/fireball | | es.fireball | | Shoots a fireball.|
|/fly | | es.fly | es.fly.other | Toggle flying.|
|/flyspeed | /fspeed | es.flyspeed | | Change a player's flying speed.|
|/hat | /head | es.hat | | Use your equipped item as a helmet.|
|/heal | | es.heal | es.heal.other | Heal a player.|
|/home | | es.home | | Teleport to your home.|
|/itemdb | /iteminfo, /itemno, /durability, /dura | es.itemdb | | Displays the item information of an item you are holding.|
|/jail | | es.jail | | Jail a player.|
|/jails | | es.listjail | | Lists all jails.|
|/lightning | /shock, /smite, /strike, /thor | es.lightning | | Damage the specified player with lightning.|
|/locate | /getpos, /whereami, /getloc, /coords, /position | es.locate | es.locate.other | Get your current location in the world.|
|/more | | es.more | es.more.other | Increases the item amount in the held stack to 64 items.|
|/mute | /silence | es.mute | | Mute a player.|
|/nuke | | es.nuke | | Spawns a nuke above players.|
|/ping | /pong, /echo | es.ping | | Check if the server is alive.|
|/place | | es.place | | Teleport a player where you are looking.|
|/powertool | /pt | es.powertool | | Binds a command to the item you are holding.|
|/repair | /fix | es.repair | | Repair the item you are holding.|
|/runspeed | /rspeed | es.runspeed | | Change a player's sprinting speed.|
|/sethome | /createhome | es.sethome | | Set your home.|
|/setjail | /createjail | es.setjail | | Create a jail at your location.|
|/setwarp | /createwarp | es.setwarp | | Create a warp at your location.|
|/shout | | es.shout | | Chat in a range of 128 blocks.|
|/skull | | es.skull | | Allows you to change a skull's skin.|
|/socialspy | | es.socialspy | | Displays other players' private messages.|
|/spawnmob | /mob | es.spawnmob | es.spawnmob.other | Spawn a mob.|
|/top | | es.top | | Teleport to the highest block.|
|/tpa | /call, /tpask | es.tpa | | Request teleport to someone's position.|
|/tpaccept | /tpyes | es.tpa | | Accept teleport request.|
|/tpahere | | es.tpa | | Request teleport to your position.|
|/tpdeny | /tpno | es.tpa | | Deny teleport request.|
|/tphere | /bring, /s | es.tp | | Teleport a player to your position.|
|/tps | /lag | es.tps | | Measure server lag.|
|/unjail | | es.unjail | | Unjail a player.|
|/unmute | | es.unmute | | Unmute a player.|
|/vanish | /hide, /v | es.vanish | es.vanish.other | Toggle visibility.|
|/walkspeed | /wspeed | es.walkspeed | | Change a player's walking speed.|
|/warp | | es.warp | | Moves player to location of warp [Tag].|
|/warps | | es.listwarp | | Lists all warps.|
|/whisper | | es.whisper | | Chat in a range of 16 blocks.|
|/whois | | es.whois | | Get information about the specified player.|
|/xp | /exp | es.xp | | Manage xp for a player.|
|/xp show | | es.xp.show | | Show xp of specified player.|
|/xp set | | es.xp.set | | Set player's current xp.|
|/xp give | | es.xp.give | | Give xp to the specified player.|

###Use-permissions
| Permission | Description |
| ---------- | ----------- |
| es.warpsign | Allows a player to create Warp Signs |
| es.commandsign | Allows a player to create Command Signs |
| es.enchantsign | Allows a player to create Enchant Signs |
| es.createportal | Allows a player to create a portal |
| es.home.unlimited | Allows a player to have an unlimited amount of homes |

###Warp Sign Template
[Warp]  
Warpname

###Command Sign Template
[Command]
/tell player 
 hello <-- Notice the space before "hello" (alternatively at end of "/tell player")

###Enchant Sign Template
[Enchant]  
EnchantmentID  
EnchantmentLevel  
RequiredXPLevelToEnchant

###Portals
To create a portal, place a sign underneath a block with the following template:  
  
[Portal]  
Warpname  
  
When walking on top of the block, you will get teleported to the specified warp.
