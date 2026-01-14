You've found the "servers_example" folder.

This contains an example set of files for a multi-config server environment,
whereby you run multiple instances of SvenDS with a single set of game content.

If you have no intention of running multiple instances of SvenDS in parallel in
this way, leave now. (This is not for you.)

--------------------------------------------------------------------------------

To get started MAKE A COPY of this folder called "servers". Do not edit any
files within "servers_example" as any Steam updates or content verifications
will likely revert all your hard work.

Referencing the files in "servers_example" will not work directly as the files
within this all specify "servers" in any paths, as that is the expectation.

--------------------------------------------------------------------------------

Now that you've made a copy of "servers_example" as "servers" take a look at
the files and folders inside.

First let's go over the files immediately in this folder. Most of these files
will usually be shared between all of your SvenDS instances, saving you time
and future maintenance.

* admins.txt: List of administrators.

* banned.cfg: List of banned players, maintained outside of SvenDS.

* default_plugins.txt: List of AngelScript plug-ins.

* listip.cfg: List of banned IP addresses, maintained outside of SvenDS.

* mapcycle.txt: Standard rotation of maps.

* mapvote.cfg: List of maps players can vote to change to.

* motd.txt: An informative message shown to players upon joining. This is a
  good place to put in contact details, a list of helpful commands, etc.

* server.cfg: Shared server settings.

The maps in "mapvote.cfg" should usually reflect ALL maps you have installed.
Then let the "mapcycle.txt" keep a standard rotation you want players to play
through if nobody starts a vote, which will allow them to vote for anything
else you have installed. For example list the popular/relative maps in the cycle
file to help bring players in when the server is empty and/or set the theme, but
everything possible in the vote file.

--------------------------------------------------------------------------------

Second let's go over the folders we have.

Each profile folder (profile1, profile2, and profile3) are examples of server
configuration sets, thereby providing you with 3 unique SvenDS instance
possibilities. You can of course clone these to make more, and they don't even
need to have "profile" in their name.

For example if you want to run 3 servers with the 1st running an official maps
cycle, a 2nd running a custom maps cycle, and a 3rd running skill/training maps
cycle, you could name the profile folders as "official", "custom", and "skill".
Want to add in a private server for your testing too? That's cool, make another
clone called "private".

You will find the same set of files in the profile examples as you have in the
shared set from above. Not all will be used, and they are all specific to one
SvenDS instance.

Lastly for this section you will find files "start.cmd" and "start.sh" launcher
scripts for Windows and Linux respectively. There are a few variables in these
you should adjust per server if you're going to use these launchers.

* GAME: The game name to launch. This should be left as "svencoop" unless you're
  running a 3rd party game on our engine.

* IP: The IP address of your server. There is already a shell command in place
  to retrieve this from your system automatically, otherwise you can replace it
  for an exact string if you prefer.

* PORT: The TCP/UDP port to listen on. TCP is used for remote console traffic,
  and UDP is used for game and query traffic. Usually 27015 but this must be
  unique to each SvenDS instance you run.

* SPORT: The UDP port to listen on for commands from the VAC security system.
  This will automatically increment if used by another server, so you don't have
  to manually manage this.

* PLAYERS: The total amount of concurrent players that can join. Usually 12, but
  can be from 2 to 32.

* MAP: The map to start the server on.
  Using map "_server_start" is recommended as it gives the game and plug-ins a
  chance to initialise fully. That map also finishes within seconds so your
  cycle will begin right after.

--------------------------------------------------------------------------------

It's important to ensure you understand which files should/will be used by all
instances, and which will only be used by a specific profile. We've done most of
this for you out of the box, but some adaptation will likely be required to suit
what you want out of your SvenDS instances.

As standard we have the following expectations for each file:

* admins.txt: Shared, unless each profile will have different administrators.

* banned.cfg: Per-profile, so banning in-game doesn't conflict. If you want this
  to be shared you must NOT use command "writeid" in game or point CVAR
  "bannedcfgfile" to this, otherwise each running instance will overwrite
  changes from other instances. -- Instead it must be managed manually outside
  of SvenDS.

* default_plugins.txt: Per-profile, though very acceptable to have this shared.
  Mostly your choice.

* listip.cfg: Per-profile, so banning in-game doesn't conflict. If you want this
  to be shared you must NOT use command "writeip" in game or point CVAR
  "listipcfgfile" to this, otherwise each running instance will overwrite
  changes from other instances. -- Instead it must be managed manually outside
  of SvenDS.

* mapcycle.txt: Per server, unless each profile is going to run the same cycle.
  Mostly useful in shared mode if you just want to point to the vanilla cycle.

* mapvote.cfg: Shared, unless each profile needs a different set of voteable
  maps.

* motd.txt: Per-profile, especially if you're going to copy the map cycle here.
  If each profile has a theme it's useful to describe it in the MOTD and include
  the map cycle.

* server.cfg: Per-profile, ALWAYS! Never point "servercfgfile" to the shared
  file. Each profile will include the shared file anyway unless you adjust them
  to not do that.

Remember that each profile has the choice as to whether each of the above will
be shared or per-profile. Make adjustments as you see fit. Use the file pointer
CVARs within each profile's "server.cfg" to make these choices.
