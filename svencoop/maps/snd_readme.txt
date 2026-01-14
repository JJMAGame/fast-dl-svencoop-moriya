    
                * SnD *

         A Sven Co-op map by Hezus

This map started out when I wanted to revamp Sandstone in early 2020. I had already upgraded the map once before years ago. After making some new textures and reworking a few streets I found the layout quite limiting and it felt better to start something new from scratch and thus SnD was born.

SnD started as a working title (short for "sand" or "search 'n destroy") but it stuck and I never bothered to change it. I really wanted to push the engine this time and make something rather unique to Sven Co-op: an open world map where you could navigate the map at your own pace and insights. 

The most challenging part of the design is the fact that it's the goldsrc engine. Huge outdoor areas doesn't make it happy and large polycounts will grind the performance to a halt even on modern machines. I've taken great care to design the map in perfect 128x128 blocks with plenty of VIS blocks and HINT brushes pretty much everywhere.

It's been a lot of work to get the map done not only because of the size but also because I made nearly everything by myself from stratch. This gave me the freedom however, to create the map exactly as I wanted it to be and that was pretty cool.  

===============================================================================

* Map info *
------------

Title			: Search 'N Destroy
Filename		: 
Author			: Michael "Hezus" Jansen
E-mail			: hezussupastar@hotmail.com
Web Site		: http://www.moddb.com/members/hezus
Description		: A map for Sven Co-op 5.24

===============================================================================

* Play Information *
--------------------

Game                    : Sven Co-op 5.24
Single Player           : Yes
Deathmatch              : No
Difficulty Settings     : Yes
New Sounds              : Yes
New Graphics            : Yes
Known bugs		: Not known

===============================================================================

* Construction *
----------------

Base                    : New map from scratch
Build Time              : Almost a year
Editor used          	: JACK Editor
Other Utilities         : SC SDK Compile Tools
			  Wally
			  Adobe Photoshop CS6
			  HL Texture Tools
			  Blender
			  Goldwave

===============================================================================

* Credits *
-----------


Thanks to the Sven Co-op Development Team for helping me resolve and overcome mapping problems and helping me test the map.

====================================
          Hezus Mapping
====================================
WebSite : http://www.moddb.com/members/hezus
Contact : hezussupastar@hotmail.com

====================================
            Sven Co-op
====================================
WebSite : www.svencoop.com
Contact : sven@svencoop.com

=================================================================================
Important Legal Information :
-----------------------------

- I`m NOT responsible for loss of data, limbs, houses, money or ANYTHING when you decide to use these files.
- Other mappers are free to use the custom textures, models, sounds and ideas of the map, but you have to add the authors credits to your readme file, check the Credits section for that.
- This map is 100 % FREEWARE, that means you cannot just sell it to anyone! If you did, then you owe that money to me. If you've paid someone to get this, then that certain someone has screwed you over.
- These files are copyright of Hezus Mapping. Publishing it under your name it is NOT allowed ! If you do this and I find out, I will personally come over to your house and kick you in the gonads. (Female thiefs will suffer
  in a different way.)
=================================================================================

* Version History *
v0.75 - 22 december 2020
- Reworked final base asssault logic
- MG's now use small cone of fire (was medium)
- Clear area message now plays a little later to stop conflict with cache destroyed messages
- Some small texture fixes

v0.74 - 20 december 2020
- Baracks doors now stay open to prevent blocking/unintended deaths
- Added path_waypoints to force grunts to approach the base perimiter
- Improved bunkbed model texture and UV
- Removed osprey grunt override to hopefully fix ghosting grunts
- Increased the delay for scripted_sequences used for capture zones to drasticly lower the amount of calls
- Fixed floating palm tree
- Fixed light fixture stuck in woorden beam
- Fixed some angles on trigger_push keeping players out of certain areas
- Moved some black props slightly off walls to fix lighting issues
- Moved osprey trajectory slightly to stop it from flying out of the skybox (and become black)

v0.73 - 18 december 2020
- Mortar control moved to avoid model clipping
- Baracks doors now open 2 ways and deal damage to blockers
- Fixed barbed wire bullet clips at prison
- Changed func_clip to func_pushable to remedy push-through bug
- Apaches now have proper scalable hp
- Raised base hp of Ospreys to make them a little tougher
- Grunts should now attack the base better
- Added func_hurts to kill stuck grunts
- Added gentle push fields to help grunts on their way
- Made func_breakable around tank bigger so it's easier to hit 
- Made commander triggers off sync with eachother so they don't display simultaneously
- Some other texture / brush / non-solid fixes

v0.72 - 17 december 2020
- Carried C4 now is tied to the player bones (Thanks DINO071!)
- A few grunts will now patrol the streets (always roam)
- Custom HUD should now refresh for connecting clients
- Added all relevant textures to custom material sound file
- Fixed idle mortar animation
- Fixed NULLed face behind broken container
- Added extra delay to base cap zone (5.2 sec)
- Increased search radius for base attackers
- Added greater spawn delay for base attackers
- Removed duplicate light_environment
- Adjusted sand colour of dune model to match brush sand better
- Fixed texture error on wooden railings

v0.71 - 16 december 2020
- New op4 mortar and shell model
- Added firing sound for mortar
- Better mortar control panel texture
- Added skill file for mortar damage
- Fixed camera exit issue
- Fixed grunts not capturing the base
- Fixed base capture pointer colour change

v0.7 - 15 december 2020
- New spawn area
- Added op4 mortar to the base
- Bigger HUD objectives sprites and are now aligned right
- C4s now respawn at base after being used
- Added radio tower in skybox for orientation
- Added pointers to the caches so they are easier to spot
- Players joining in later will now refresh the HUD script
- Added desert ambience sounds
- Added sprite pointer to the base defense zone
- Enemies need to hold the base sector for 5 seconds now to capture
- Base assault timer expanded from 1 to 2 minutes
- Changed the osprey/apache respawn time from 5 to 6-8 minutes
- Changed commander reminder message to clear the area from 30 to 60 seconds
- Clear area fail safe lowered from 5 minutes to 4 minutes
- Apache in the final battle will spawn after 1 minute, so players are aware of the grunts first
- Set osprey grunt override to 4 to stop it from adding too many grunts
- Osprey Pitch/Roll flight is now less dramatic
- Lowered the HP multiplier from 50-400% to 50-250% (from 1 to 16 players)
- Made enemy capture trigger field slightly smaller
- MGs now have better sound, greater yaw, more damage, lower rate of fire
- Right and left mouse click now exit objectives camera
- Added beter w_9mmar model to weapon rack
- Added CLIPs between barracks to avoid people getting stuck there
- Added zhlt_copylight to black model props
- Fixed typo on C4 descriptions
- Fixed transparancy on balcony railings
- Waiting for players text is repeated a few times now
- Fixed weapon cache stuck in wooden beam
- Fixed grunt additive visors
- Adjusted CLIP brushes on some market stalls
- Replaced palm tree model hull with CLIP brushes to prevent issues with lasers
- Palm trees now have varous sizes
- Fixed floating brown ammo box
- Fixed RPG item display name

v0.6 - 11 december 2020
- Clip progress: 100%
- First art pass progress: 100%
- Redesigned the base with a better defined defendable area
- MGs now have a higher rate of fire and do more damage
- Moved the MG from osprey somewhere else
- Disabled flashlight in CFG (to hide it being tiny because of 0.25 lightmap scale)
- Added extra clipnodes for better AI navigation
- Raised the origin of the dune models so they won't disappear anymore
- Increased texture density of dune models to fix the brush sands
- Added invisible wall behind osprey rock models to stop enemies firing through
- Adjusted palm model hull size
- Fixed blacked out light in tunnel
- Fixed ammo crate partially in wall

v0.52 - 6 december 2020
- First art pass progress: 60%
- M2 machine guns can be used by players now after enemy gunner is killed
- Added start button to spawn room
- Added additional skin to awnings and stalls
- Slightly rearranged barracks area

v0.51 - 2 december 2020
- Added kill relays for broken func_tank triggers
- Fixed angles on barracks m2 gun
- Sniper balconies no longer block bullets
- MG gunners are now part of global healh system
- Added more details to some streets

v0.5 - 2 december 2020
- Added M2 stationary machine guns
- Added desert sniper and RPG grunts
- Added a 5 min failsafe for the clean up objective
- Capture zone icons now start in red
- Fixed clipping issues in open double doors
- Fixed respawning grunt getting stuck near prison
- Fixed func_ladder at base
- A lot of minor texture and geometry fixes
- Added more details to some streets

v0.41 - 26 november 2020
- Added lots of details to first part of the maps
- Scattered sniper ammo around town
- Fixed darkness in broken crate at base
- Fixed non-clipped ammo box in tower at base
- Fixed grunt clipping into gaurd house floor at barracks
- Fixed shadowed shotgun at loadout

v0.4 - 9 november 2020
- Added end game: base defense
- Added fully functional T90 tank
- Players must now kill all remaining forces before getting to the end game
- Added more commander voice lines
- Added more details
- Base towers can now be accessed via ladders
- Lowered apache base hp to 1500
- Realigned objectives camera
- Added sound to announce voting time
- Fixed apaches/osprey not using global health
- Fixed medkits not spawning in base
- Fixed one more floating crate
- Fixed angle on RPG in base
- Fixed enemies falling off guard tower
- Added CLIPs to market stall models
- Minor texture fixes

v0.3 - 11 oct 2020
- Players must now mob up all remaining enemies before heading back to base
- Added recommended player amounts to play modes
- Replaced SAW with RPG
- Added RPG ammo around the town
- Added medkits to base arsenal
- Fixed floating crates
- Osprey's/Apache now start at random time intervals 
- Osprey's/Apache now have longer respawn times
- Military Op4 player models are now forced
- Player will now receive a random class model
- Added review objectives button to each barrack
- Base capture zone now starts invisible
- Added commander voices for losing the mission
- Enemies can no longer retake zones after all objectives have been reached
- Removed random base attacks from Advanced and Challenge modes
- Realigned the map around the world 0,0,0 coordinate to fix lighting issues in the far ends of the map

v0.21 - 6 oct 2020
- Fixed cache1 not triggering
- Removed AR-grenades from ammobox and less 556 ammo spawning

v0.2 - 5 oct 2020
- Added MOTD
- All zones start off red now
- Various optimisations and texture fixes
- Fixed some non-solid brush issues
- Rearranged osprey crash site for better visibility
- Crashed osprey prop now blocks bullets and is solid
- Added extra details (palm trees, crates, barrels)
- All props have proper collisions now
- Added ammo usable crates (restocks based on class)
- Added health/armor powerups (hidden around the map)
- Created new weapon cache model (more destinct)
- Removed accidental duplicate cache
- Fixed market stall and bunkbed models disappearing from view (has bbox and cbox now)

v0.1 - 11 sept 2020
- First playable beta version, no real ending yet
