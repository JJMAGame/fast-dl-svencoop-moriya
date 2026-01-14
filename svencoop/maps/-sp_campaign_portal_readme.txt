Sven Co-op 5 Portal map for Single Player Campaigns (Currently: HLSP, Uplink, OpFor, Blue Shift).


YOU NEED AT LEAST TWO PEOPLE IN ORDER TO CHOOSE A CHAPTER.
EXPLOITING THE SYSTEM IS IMPOSSIBLE; IF YOU THINK YOU CAN, TRY ANYWAY.
Well, there IS a way, but it's too much effort for a single person while the server is running.
Also, you cannot play HLSP all alone anyway.

I sub-devised the chapters by game: upper level are Half-Life + Uplink chapters, lower level Opposing Force.
Further up is an outside area for Blue Shift.
Each table with two consoles represents a chapter.
You need to press both buttons on a table at once WHILE STAYING DIRECT IN FRONT OF THE CONSOLE.
When you failed opening a Portal, you will hear "Access Denied".


FOR SERVER ADMINS:
If you want to enable or disable an SP area on your own, use the following CVars in your (listen)server.cfg:

as_command spcp_hlsp 0/1
as_command spcp_uplink 0/1
as_command spcp_opfor 0/1
as_command spcp_bshift 0/1
as_command spcp_theyhunger 0/1


Attention: 
This will NOT perform the check if the Single Player Conversions are installed (properly)!
If you only use one SP Conversion, please disable the others. 
The other areas will be locked automaticly if at least one CVar is used.




-----

Map by Puchi
All Models in models\puchi\spportal\ginsengavenger are made by ginsengavenger.
All Models in models\puchi\spportal\The303 by The303 (https://forums.svencoop.com/showthread.php/44371-Pack-TheCorp-s-Assorted-Models)
All Models in models\puchi\spportal\DGF are made by DGC

Special thanks to (alphabetical order):
» AdamR
» AzShadow
» BMT, for the secret
» DGF
» Geckon (lots of probably also annoying AS support!)
» Hezus, for the fish model
» Hydeph
» JPolio
» Mad_Jonesy
» Nih
» Skacky
» Sniper
» Solokiller (god, i thank him so much for all the annoying AS support he gave me at every daytime!)
» The303
» WarNuker



-----

FAQ:


Q: HOW CAN I EXPLOIT THE SYSTEM, IT SUCKS, I WANT TO CHANGE THE CHAPTER BY MYSELF!
A1: The system was made so that it could not get exploited. Jonesy and I wanted a more fair system than in the old Portal map.
A2: By now possible. Open scripts/maps/sp_portal/sp_portal_main.as
    Look for the lines
		// If the player count from the game_zone_player is 2, do the following stuff
		if (flValue == 2)
		{
    and simply change the number. This is the value the game uses HOW MANY PLAYERS ARE *INSIDE* THE GAME ZONE.

Q: THAT PORTAL SYSTEM IS COOL! HOW DID YOU DO IT?
A: Utilising game_zone_player, an idea from Jusupov.

Q: THERE'S A CHAPTER OF OPPOSSING FORCE MISSING, IDIOT!
A: Yes, because three maps earlier another chapter begins.

Q: OMG! PLZ TELL ME TEH SECRET!!1111
A: REMOVED IT. We cannot use copyright protected material in official content anymore. This is why the Posters in the HL area were replaced aswell.
   Those are royalty free picture.

Q: CAN I HAVE SEX WITH YOU?
A: why not (: