# Sven Co-op: Hide and Seek

Instructions for using the hide and seek game mode script for Sven Co-op.

*(This game mode requires Sven Co-op version 5.24 or later.)*

## Overview

Hide and seek game mode consists of one team of players hiding from another team of seekers (or one seeker) within a set time. Flow is as follows:

* Short warm up, acting as a short time buffer for connecting players, and a short gap/break between rounds.
  Both hiders and seekers are locked up in their starting location during this period.
* Hiding time: Hiders are released to hide around the map. (Usually given 2 minutes.)
* Seeking time: Seekers are released to hunt the hiders. (Usually given 5 minutes.)
  Seekers capture/tag hiders by killing them with the provided weapon. (Usually a knife.)
* Caught hiders are sent to a captured zone, or "jail", but can be released by a hider using a release button/lever/strawberry.
* End of round: Any remaining hiders are awarded (usually 1 point) by being uncaught at the end.
  Seekers will be moved back to the hider team so other people if desired can choose to be a seeker in the next round.

Hiders are on the blue team, seekers are on the red team. Both teams can use team text chat via the `messagemode2` command to communicate privately amongst their team. However voice chat, even if server CVAR "sv_alltalk" is `0`, will be heard by everyone.

## Getting started

You will need to create a map configuration file, "maps/`<mapname>`.cfg" for the hide and seek game mode to run. Ensure these lines are present:

```
nomedkit

mp_allowmonsterinfo 2
mp_allowplayerinfo 2
mp_dropweapons 0

map_script hideandseek
```

Otherwise you must have a `trigger_script` entity in your map as follows:

* Target name: *Empty.*
* Script to load: "`hideandseek`"
* Function to execute on trigger: *Empty.*
* Mode: "Trigger"
* Spawn flag "Start on" **must** be enabled.

## Map setup

### Commands

Players can use command `hns` at any time to see information about the game play settings and game current state.

### Configuration

The following options can be defined in the map configuration file "maps/`<mapname>`.cfg". Put these on one line each, perhaps just below the `map_script "hideandseek`" directive.

**Important**: Begin each line with `as_command` or it won't be recognised. For example to have a 10 minute seek time, add line `as_command hns_seek_time 600`.

| Configuration | Default value | Description |
| - | - | - |
| nomedkit | *N/A* | **VITAL** to ensure no game default equipment is given to anyone. |
| hns_test | 0 | Set to `1` to enable test mode. (Map timers will be halted so you can roam the map freely.) |
| hns_warmup_time | 35 | Warm-up time in seconds. (Before hiders are released to hide.) |
| hns_hide_time | 120 | Hiding time in seconds. |
| hns_seek_time | 300 | Seeking time in seconds. |
| hns_seek_idle_time | 60 | Seeker idle time before being booted to hider.<br />(This only monitors a seeker's time within a `game_zone_player` named "`spawn_seeker_zone`" during seek time.) |
| hns_default_model | massn_normal | Un-teamed player model. (Used temporarily during connect.) |
| hns_hider_model | massn_blue | Hider player model. |
| hns_seeker_model | massn_red | Seeker player model. |
| hns_hider_speed | 270 | Hider maximum run speed. |
| hns_seeker_speed | 320 | Seeker maximum run speed. |
| hns_hider_to_seeker_ratio | 8 | The number of hiders required for each seeker.<br />For example if set to 8 that means 1 seeker can be present across 8 hiders, which would total 9 players. (When a 10th player joins a 2nd seeker would be permitted.)<br />**If you only intend on having one seeker set this to `0`.** |
| hns_hider_release_score | 1 | How many points to award a hider for releasing captured hiders. |
| hns_hider_release_reset_time | 10 | How many seconds hiders must wait to perform another release. |
| hns_hider_uncaught_score | 1 | How many points to award a hider for not being caught at the end of each round.<br />(Uncaught means not being inside the `game_zone_player` called "`hider_capture_zone`" when the seeking time runs out.) |

### Properties

The following properties should be set on the map's `worldspawn` entity. For Svencraft, Hammer, and J.A.C.K you can set these in the **Map** menu then choose **Map properties**.

| Property | Key | Value |
| - | - | - |
| Force Player Models | `forcepmodels` | "massn_normal;massn_blue;massn_red" |

### Required entities

The following entities are absolutely necessary for the functionality of this game mode.

| Class | Target name | Description |
| - | - | - |
| `info_player_deathmatch` | `spawn_init` | Used as spawn point for the first player joining so they don't die immediately.<br />It will be deleted instantly after that.
| `info_player_deathmatch` | `spawn_hider` | Used as spawn points for hiders prior to the round starting.<br />Ensure that property "Filter Player Targetname" `message` is set to "`hider`".
| `info_player_deathmatch` | `spawn_hider_caught` | Used as spawn points for hiders during the round, whether they've been caught, or joined the game during a round.<br />Ensure that property "Filter Player Targetname" `message` is set to "`hider`".
| `info_player_deathmatch` | `spawn_seeker` | Used as spawn points for seekers at any time.<br />Ensure that property "Filter Player Targetname" `message` is set to "`seeker`".
| `game_zone_player` | `hider_capture_zone` | Used as the captured zone for caught hiders.<br />Hiders inside this zone will NOT be awarded any points at the end of the round.<br />When all hiders are within this zone the round ends with a seeker win immediately.<br />Seekers will be killed instantly if they try to enter this zone. |

The spawn points are found dynamically, so if you intend on using the same spawn points for hiders both before and during the round, you can rename them with "`trigger_changetarget`" using the "on_round_end" and "on_seeker_start" events.

### Optional entities

The following entities are absolutely necessary for the functionality of this game mode.

| Class | Target name | Description |
| - | - | - |
| `info_target` | `hns_info` | Used to store runtime information (see section below) about the state of game play, should your map want to adapt accordingly. |
| `weapon_*`, `ammo_*` | `seeker_equip` | Equipment to give seekers when they spawn.<br />Ensure these have both "Use only" and "Touch only" spawn flags enabled.<br />(If no equipment exists the seeker will be given a crowbar with enough damage to inflict one-hit kills.) |
| `game_zone_player` | `spawn_seeker_zone` | Used as the spawn zone for seekers.<br />Used to detect idle seekers when seeking time has started so they can be booted back to a hider. |

## Script interaction

It is possible to trigger and listen for various events, which can help make your map flow a bit more dynamically. Please ensure all `trigger_script` entities for these are configured as follows:

* Target name: *Your choice for event triggers, or as specified below for event callbacks.*
* Script to load: "`hideandseek`"
* Function to execute on trigger: *As per function name mentioned.*
* Mode: "Trigger"
* Spawn flag "Start on" **must** be disabled.

### Event triggers

The following triggers can be passed from the map to the script via a `trigger_script`.

| Function name | Description |
| - | - |
| `ShowGameRules` | Show a brief message about the game rules. (If the activator is not a player show everyone.) |
| `DoHiderRelease` | A hider has successfully released all captured hiders. |

### Event callbacks

The following events can be passed from the script to your map. Entities with such target names will be fired with the `TOGGLE` use type when their respective event occurs. These could be `trigger_relay`, `multi_manager`, etc.

**Important**: For each of these that exist in the map you MUST also fire their respective "Handle function name" via a `trigger_script` so the script knows the map is ready to continue.
Exception is `HandleHiderCaught` due to the inability of `trigger_script` being able to pass both players to the script function.

| Target name | Handle function name | Description |
| - | - | - |
| `on_round_start` | `HandleRoundStart` | The round (warm up) begins.
| `on_hider_start` | `HandleHiderStart` | The hiders are released, for hiding.
| `on_seeker_start` | `HandleSeekerStart` | The seekers are released, for seeking. *(Obviously.)*
| `on_hider_caught` | `HandleHiderCaught` | A seeker has caught a hider.<br />The hider will be passed as activator, and seeker will be passed as caller.
| `on_hider_release` | `HandleHiderRelease` | A hider has released captured hiders.<br />The hider will be passed as activator.
| `on_hider_all_caught` | `HandleHiderAllCaught` | All hiders have been caught, so the round should end immediately.
| `on_round_end` | `HandleRoundEnd` | The round completes.

### Messages

Entities with these target names will be fired with the `TOGGLE` use type for various messages. These would usually be `game_text`, `ambient_generic`, or `multi_manager`. (You could chain a `game_text` to an `ambient_generic` if you want just a message with a sound.)

If these entities don't exist a standardised equivalent will be used. (None of these are necessary in your map to have these messages.)

| Target name | Description | Default string | Default sound |
| - | - | - | - |
| `msg_hider_spawn` | When a hider spawns. | `You are a HIDER\nDon't get caught!` | *N/A* |
| `msg_hider_spawn_caught` | When a caught hider spawns. (Also applies to players joining while seeking is in progress.) | `You are a HIDER\nYou've been caught :(\n\nWait for the next round, or until another hider sets you free.` | *N/A* |
| `msg_hider_release` | When a hider releases all captured hiders. | `CAPTURED HIDERS HAVE BEEN RELEASED!` | `vox/buzwarn.wav` |
| `msg_hider_winner` | When a hider is uncaught at the end of the seeking time. | `You escaped that round. Well done!` | `vox/bloop.wav` |
| `msg_seeker_spawn` | When a seeker spawns. | `You are a SEEKER\nCapture those hiders!` | *N/A* |
| `msg_seeker_in_hider_capture_zone` | When a seeker enters the hider's capture zone, and is killed for trying. | `Seekers are not allowed to enter the hider capture zone` | `vox/dadeda.wav` |
| `msg_seeker_winner` | When the seekers have caught all hiders. | `ALL HIDERS HAVE BEEN CAUGHT. -- SEEKERS WIN!` | `vox/buzwarn.wav` |
| `msg_round_reset` | When a round is reset. | `ROUND RESET` | `vox/buzwarn.wav` |

### Runtime information

An `info_target` entity named "`hns_info`" will be created and given the following properties.

You will be able to read these with `trigger_condition`, `trigger_copyvalue`, etc. if you want your map to be able to make use of them. Anything your map attempts to write in will be ignored and overwritten as the script keeps its own internal state.

| Key | Description |
| - | - |
| `stage` | The stage of game play.<br />`w` for warm-up, `h` for hiding, `s` for seeking, `sw` for seeking (but the seeker has won entirely), or `e` for end of round. |
| `stage_timeleft` | Time left for the current stage of game play.<br />`-255.0f` for when the stage is about to change. |
| `player_count` | A count of how many players are in game. |
| `hider_count` | A count of how many hiders are in game. |
| `hider_count_caught` | A count of how many hiders are caught. (Only during seeking time.) |
| `hider_release_reset_time` | Time left before hiders can be released (again).<br />`0.0f` for available now. |
| `seeker_count` | A count of how many seekers are in game. |
