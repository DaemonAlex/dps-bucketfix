# dps-bucketfix

Tiny watchdog that returns players to routing bucket 0 after `wasabi_spawn`
occasionally strands them in bucket 1 (invisible to everyone else, "ghost
town" symptom on join).

## Status

Not running on DelPerroSands since 12 November 2026. This fix is now part of `dps-fixes`, which
carries the same code along with the server's other small fixes. Run this script or `dps-fixes`,
not both: running both does the same job twice.

## What it is for

A player joins, picks a character, and the city is empty. No other players, no trains, nobody
answers. The player is in the wrong routing bucket, a separate copy of the world. This script
puts them back in the shared world within seconds.

## What it does

- **Checks on spawn.** Five seconds after a player spawns or a character loads, a player found in
  bucket 1 goes back to bucket 0.
- **Sweeps every 15 seconds.** Anyone still in bucket 1 goes back to bucket 0.
- **Logs each fix** to the server console.
- **Leaves other buckets alone.** Only bucket 1 is touched. Housing interiors and other
  deliberate instances use other buckets and keep working.
- **`bucketcheck`.** A server console command that prints every player's bucket.

## How it works
A server-side sweep checks player routing buckets and moves anyone found in
bucket 1 back to 0, logging the correction:

```
[bucketfix] Schtoop (1) moved from bucket 1 -> 0 (sweep)
```

## Why it exists
wasabi_multichar/wasabi_spawn use routing buckets during character selection.
On some join paths the restore to bucket 0 is missed. Rather than patch
escrowed code, this resource guarantees the invariant from outside.

Standalone; no configuration, no dependencies beyond the base server.

## On its own, and with other scripts

**On its own.** It runs on any FiveM server with nothing else installed. If nothing ever leaves a
player in bucket 1, it does nothing and costs almost nothing.

**With a paid character/spawn script (wasabi_spawn, wasabi_multichar).** These put the player in
bucket 1 while they choose a character and a spawn point. Sometimes the player is left there.
This script moves them back to bucket 0, so they see the same city as everyone else. It does not
call or change the wasabi scripts. It only reads each player's bucket from the server, so a
wasabi update does not break it.

**With Qbox (qbx_core).** The script listens for `QBCore:Server:OnPlayerLoaded` to check a player
soon after their character loads. Qbox applies its entity lockdown to bucket 0 only, so a player
back in bucket 0 is protected by it again.

**With [dps-trains](https://github.com/DaemonAlex/dps-trains).** Trains run in bucket 0 and skip
players in any other bucket. With every player stuck in bucket 1, no train ever spawned. With
this script running, trains spawn for players again.

**With a paid housing script (qs-housing).** qs-housing puts each interior in its own random
bucket. This script leaves those alone. The one case to avoid is a house set up with id 1, which
would use bucket 1.

## Requirements

- A FiveM server with OneSync, which routing buckets need.
- Nothing else.

## Install

1. Put the folder in your resources.
2. Add `ensure dps-bucketfix` to your server config.
3. Restart the server, or run `refresh` then `ensure dps-bucketfix`.

## Configuration

There is no config file. Two numbers sit at the top of `server/main.lua`:

| Setting | Meaning |
|---|---|
| `STUCK_BUCKET` | The bucket players get stranded in. Default 1. |
| `TARGET_BUCKET` | The bucket they are moved to. Default 0. |

## Recent changes

- **12 November 2026.** Taken off the DelPerroSands server. `dps-fixes` does this job now.
- **12 November 2026.** README: what it is for, how it works alone and with paid scripts, other
  DPS scripts.

## Author

Made by [DaemonAlex](https://github.com/DaemonAlex) for DelPerroSands.

## Other DPS scripts

All of these are made for DelPerroSands and run together on one Qbox server. Each one works on
its own. The ones marked "pairs with" do more when both are running.

| Script | What it does |
|---|---|
| [dps-inventory](https://github.com/DaemonAlex/dps-inventory) | The inventory: ox_inventory with equipment slots, backpacks, armour plates and a self status panel, in the DelPerroSands colours. |
| [dps-medical](https://github.com/DaemonAlex/dps-medical) | Patient records, illness and diagnostic tests. A companion to wasabi_ambulance. Pairs with dps-inventory: symptoms and diagnoses show on the status panel. |
| [dps-insurance](https://github.com/DaemonAlex/dps-insurance) | Ties m-Insurance into the MDT, impound, hospital and medical chart. Pairs with dps-medical. |
| [dps-studio](https://github.com/DaemonAlex/dps-studio) | Build rooms, doors and portals in game from one panel (`/studio`), with owners and managers so staff do not have to support them. |
| [dps-shops](https://github.com/DaemonAlex/dps-shops) | Shop clerks who greet and react to a robbery, then player-owned shops. |
| [dps-fleet](https://github.com/DaemonAlex/dps-fleet) | Vehicle browser and workshop on one panel: extras, liveries and mods for emergency vehicles. |
| [dps-parking](https://github.com/DaemonAlex/dps-parking) | Parking with valet, impound, violations and reserved spots. |
| [dps-vehiclepersistence](https://github.com/DaemonAlex/dps-vehiclepersistence) | Vehicles stay where they were parked. Pairs with dps-parking. |
| [dps-towjob](https://github.com/DaemonAlex/dps-towjob) | Queue-based tow job with jg-mechanic integration. |
| [dps-services](https://github.com/DaemonAlex/dps-services) | Request a tow and follow it live on the lb-phone and lb-tablet. Pairs with dps-towjob. |
| [dps-autoshops](https://github.com/DaemonAlex/dps-autoshops) | Self-service repair shops when no mechanic is on duty. |
| [dps-cityworker](https://github.com/DaemonAlex/dps-cityworker) | City infrastructure job and career. |
| [dps-ainpcs](https://github.com/DaemonAlex/dps-ainpcs) | NPCs you can talk to, with trust, quests and intel. |
| [dps-badpeds](https://github.com/DaemonAlex/dps-badpeds) | Police interaction with NPCs: stops, arrests, intel and jail records. |
| [dps-gangwars](https://github.com/DaemonAlex/dps-gangwars) | Ambient gang NPCs, territory population and war reinforcements. |
| [dps-rotations](https://github.com/DaemonAlex/dps-rotations) | Moves dealers, harvests and other spots on a fixed schedule. |
| [dps-trains](https://github.com/DaemonAlex/dps-trains) | The train system. Pairs with dps-trains-stock, dps-traintools and dps-transitapp. |
| [dps-transitapp](https://github.com/DaemonAlex/dps-transitapp) | Live train arrival boards on the lb-phone. |
| [dps-faceplant](https://github.com/DaemonAlex/dps-faceplant) | City help, reports and staff tools on the lb-phone and lb-tablet. |
| [dps-chat](https://github.com/DaemonAlex/dps-chat) | A command box for voice-only servers. No chat feed. |
| [dps-filmmode](https://github.com/DaemonAlex/dps-filmmode) | One key hides every HUD layer and gives a smooth free camera for recording. |
