# MKev's Modpatcher

Local compatibility mod for the MKev Project Zomboid Build 42 multiplayer setup.
Mod id `mkev_modpatcher`, current version **1.3.2** (2026-11-13). It loads **last** and fixes other mods while the game runs.

Workshop originals are never edited. Every fix is either runtime Lua in this mod, or an extra file in this mod's own folder. Nothing is written under `steamapps\workshop`.

It replaces MKevPackPatches 2.5.0. `mod.info` marks that mod incompatible, and the patcher logs a warning if both are active. Do not run them together.

Author: **MKev**.

The all-in-one server and client setup (this mod, the server kit, and the Server BootPatch) is [MKev's Modpatch Installer](../../Modpatch-Installer/README.md). Boot-log script fixes are a separate mod: [MKev's Server BootPatch](../Server-BootPatch/README.md).

---

## Download

| File | Version | SHA256 |
|---|---|---|
| **[`Modpatcher-v1.3.2.zip`](Modpatcher-v1.3.2.zip)** (current) | `mkev_modpatcher` 1.3.2 | `ea875c4fd39295f509805eb5b6a29c1f9041a77a23eebfa2d0da0049f218dc10` |

Hashes are also in [`SHA256SUMS.txt`](SHA256SUMS.txt). History: [`CHANGELOG.md`](CHANGELOG.md).

`Modpatcher-v1.3.zip` (SHA256 `08189195765db5d0c513992dfa079587f097f3f865d61e7ab7c08866218b34b1`), `Modpatcher-v1.2.zip` (SHA256 `72e78c65d3e62ad6e14d9bdf3aa920344062ebf73a18d8876722d787ef941b17`), `Modpatcher-v1.1b.zip` (SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`) and `Modpatcher-v1.1_vvr.zip` (SHA256 `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a`) are the previous standalone builds. 1.3, 1.2 and 1.1b are not stored as standalone zips in this folder (1.3 is still inside the archived installer v1.32; 1.2 is still inside the archived installers v1.31 / v1.3 / v1.3b; 1.1b is inside the archived installers v1.2 and v1.1b). There is no standalone zip for 1.0 or for 0.1.11. Installer v1.0 still bundled patcher 0.1.11; see [MKev's Modpatch Installer](../Patch-Installer/README.md).

Check the log for `[MKev-ModPatcher] version 1.3 loaded`.

### Install the standalone zip

1. Close Project Zomboid and the dedicated server.
2. Extract the zip and copy the folder `mkev_modpatcher` (the whole folder: `common/` and `42/`) to `Zomboid\mods\` on the server and on every client.
3. Put `mkev_modpatcher` **last** in `Mods=`. It is a local mod: it has no `WorkshopItems=` entry.
4. Use the same version on the server and on every player. Script checksums have to match.

For a new dedicated server, use the installer instead of copying this folder by hand. Option 1 there also sets the mod list, map, sandbox, and preset, and installs the Server BootPatch.

Because the mod is on the player's local default list, it also loads in the main menu and in new single-player games. There it only shows the main-menu connect notice. The spawn monitor and the post-death guard are multiplayer-only. Every other module checks for its target mod first, or runs only on the client, the server, or both. A player can switch it off in the mod list. On the next multiplayer join it adds only its own id again, and it does not change any other entry.

---

## How a module behaves

- It runs only if its target mod is active. On the wrong side (client, server, or single player) it does nothing.
- It only fills a gap or skips one broken call. It does not replace another mod's working code.
- Errors are caught (`pcall`). Logging is rate-limited, with clear `[MKev-ModPatcher]` lines.

Each module names its root cause in its file header. The same notes are in `UPSTREAM.md` inside the mod folder, with `CHANGELOG.md` and `AUDIT.md`. A workaround is meant to be removed once the original mod is fixed.

---

## Lua modules (16)

| File | Side | Target | What it does |
|---|---|---|---|
| `mkevmp_vvrspawnguard.lua` | dedicated server | Vanilla Vehicles Replacer (KI5) | **The VVR guard.** See [below](#the-vvr-spawn-guard). |
| `mkevmp_spongie_tweedfix.lua` | server + client | Spongie's Clothing (+ Open Jackets BASE) | Gives the two Tweed jackets a valid BodyLocation. See [below](#spongies-clothing-tweed-jacket-bodylocation). |
| `mkevmp_fillcontainerguard.lua` | server + client | vanilla 42.21 bug (seen with Computer Mod New Music, Low Condition Guns) | The game sometimes passes a loot table instead of the bag to `OnFillContainer`. That one bad call is skipped for handlers registered after it; real containers pass through. |
| `mkevmp_oncreatealias.lua` | server + client | Realistic Army Zombies, Extra Bombs 2 | Points the old pre-42.20 `SpecialLootSpawns.OnCreate*` names to the vanilla functions. Gas masks get their filter again, the magazine its title. |
| `mkevmp_purserverguard.lua` | dedicated server | Plysken Underground Revolution | Provides the `PUR` table that only PUR's client files create, so its server file loads without an error on every start. |
| `mkevmp_jp82guard.lua` | server + client | '82 Jeep J10 | Fills missing `JP82.*SpareTire` functions with vanilla defaults. It never overwrites existing ones. |
| `mkevmp_sodacanalias.lua` | server + client | FunctionalAppliances2 / Authentic Z | Old soda `OnCreate` name. Does nothing unless one of them is active. |
| `mkevmp_zedmonitor.lua` | server + MP client | debug tool | **Zombie spawn monitor:** logs where new zombies come from (Lua spawn calls, room spawns, cell loads, reanimation) and counts zombies within 30/80 tiles of each player. Writes `Zomboid/Lua/mkev_zedmonitor_server.log` and `mkev_zedmonitor_client.log` (2 MB cap, one older file). Times in German local time (CET/CEST). Sandbox option `MKevMP.ZedMonitor`. A-Life NPC bodies and Starving Zombies skeleton templates are not counted. Off in single player since 0.1.11. |
| `mkevmp_00_config.lua` | both | — | Settings, log helper, `isModActive`, warning if the old `MKevPackPatches` is active too. |
| `mkevmp_version.lua` | both | — | The version line in the log. |
| `mkevmp_alifewindowhands.lua` | MP client | Project A-Life NPCs | Empties an armed A-Life NPC's hands (through A-Life's own `TraversalHands`) just before the engine makes it climb a window. Stops the `ClassCastException IsoZombie -> IsoPlayer` error popups. Logs `prevented / refused / missed / errors`. |
| `mkevmp_insertmagguard.lua` | MP client | vanilla `ISInsertMagazine` | Keeps the magazine reference when the client lookup fails during sync. Before: `setJobDelta` on nil, once per frame (10 errors in one reload). |
| `mkevmp_neatlockshovequiet.lua` | client | NeatLockpicking | Drops a no-op `setVariable("bDoShove")` call that flooded the log (**2711 lines in 21 s**). Behaviour is unchanged. |
| `mkevmp_primitivebow_anm.lua` | client | Archery Nexus [Fixed] + [RadBows] | The Primitive Bow shows its drawn model again while an arrow is nocked. |
| `mkevmp_postdeathguard.lua` | MP client | vanilla death screen | Keeps the death screen on top and logs what blocks its buttons (`[MKev-PDG]`). After 10 s it shows a fallback window with *New character* / *Quit*, which calls the vanilla handlers. |
| `mkevmp_connectnotice.lua` | MP client | — | Shows a short DE/EN loading notice with OK, once before connecting or once in game. Never shown in single player or to a coop host. Texts are in `Translate/EN/UI.json`. On an MP client it adds only `mkev_modpatcher` to the local default mod list, using the vanilla mod-list API. |

---

## Data patches

These are extra files in this mod. They do not overwrite files inside a Workshop folder.

| File(s) | Target | Fix |
|---|---|---|
| `scripts/vehicles/mkevmp_template_*.txt` (4) | KI5 vehicles (93mustangSSP, 87chevySuburban, 82jeepJ10, 86oshkoshP19A, 67commando, and others) | Restores KI5 gunrack templates and the JP82 spare-tire template, plus empty stubs for stale template names. Stops `template not found`. |
| `scripts/mkevmp_brita_nv_legacy.txt` | Brita's Armor Pack | 6 legacy night-vision names as full items. Stops 6× "client has no script for dictionary info" on every join. |
| `clothing/clothingItems/*.xml` (3) | Realistic Army Zombies | Stand-ins for 3 clothing files its outfits use but the mod does not ship (`Jacket_M65_Green`, `Jacket_ArmyCamoGreenHot`, `Hat_PatrolCapGreen`). |
| `Translate/EN/Sandbox.json` | TrueSmoking | Fixed `%` signs in sandbox tooltips. |
| `sandbox-options.txt` | — | Sandbox option `MKevMP.ZedMonitor`. |

The mod also ships empty `AnimSets` and `actiongroups` placeholders under `common/` and `42/` (added in 0.1.9), for the same boot-log reason as [MKev's Server BootPatch](../Server-BootPatch/README.md).

---

## The VVR spawn guard

`mkevmp_vvrspawnguard.lua` wraps the spawn handler of **Vanilla Vehicles Replacer (KI5)** (Workshop 3423424077). It runs only on a dedicated server (`isServer()` and not `isClient()`), and only for the handler defined in VVR's `lua/server/VVR/Replace.lua`. Clients, a coop host, and single player are untouched. No VVR file is copied or modified.

### Why it existed

VVR swaps a vanilla car in `OnSpawnVehicleStart`. For a vehicle that already exists it sets the new script and calls `scriptReloaded(true)`. On a dedicated server that path reaches `Bullet.removeVehicle`, a native physics call the server does not have, so it throws `java.lang.UnsatisfiedLinkError` (**15×** in the server logs from 2026-10-27 to 2026-10-30; VVR `Replace.lua:188`). The server did not crash, but the swap stopped half way. Clients then failed to parse that vehicle's seats: `BufferUnderflowException` in `VehiclePassengers` (**1239×** in one session on 30 Oct 2026).

The guard was added in 0.1.8 (internal label 1.8) on 2026-10-30. From 0.1.8 through 0.1.11 it skipped VVR on the dedicated server for every vehicle that already existed. New cars were still replaced. Vanilla vehicles that VVR missed at their first spawn stayed vanilla, for example Step Vans and Vans (`Base.StepVan_MobileLibrary` in a client log on 2026-11-10).

### What 1.1_vvr changed

1.1_vvr (2026-11-10) is 0.1.11 plus this hotfix only. The guard lets VVR replace vanilla vehicles again. Dedicated server, VVR handler only:

- **New vehicle:** VVR replaces it as before. If it has no square yet (VVR returns early), it is queued and checked again once it is in the world.
- **Existing vehicle without physics** (`getController() == nil`): VVR's `replaceSpawned` runs directly. Condition, rust, blood, and parts are kept. `scriptReloaded` does not touch Bullet in this case.
- **Existing vanilla vehicle with physics** that VVR has a replacement for: VVR is not called. The vehicle is removed with `permanentlyRemove()` (the server skips Bullet) and spawned again with the same vanilla script on the same square (`addVehicleDebug`). VVR's own `replaceNew` then swaps the new vehicle. Each square and script at most once per server run. Items stored in that vanilla vehicle are lost; the new one gets fresh vanilla loot.
- **Occupied, towing, or towed** vehicles are kept and retried on the next chunk load.
- Non-vanilla vehicles are left to VVR, which returns on its own.

One server log line per vehicle: `VVR guard: replaced <script> -> <target> at x,y`, `FAILED ...`, or `kept ...`. At most 20 lines per 60 seconds; further lines are counted. Startup line: `VVR spawn guard active (dedicated server, 1.1_vvr: vanilla vehicles are replaced).`

### What 1.3 changed

1.3 adds a warning to the connect/loading notice: a rare connection timeout on the first join can show the game's error message, quoted in red (DE `Leider ist ein unerwarteter Fehler aufgetreten.` / EN `Sorry, an unexpected error occurred.`, verbatim from the game translation key `UI_GameLoad_UnexpectedError1`). The notice then tells the player to restart the client and connect again. The previous loading-notice texts are unchanged. Server and every player need 1.3 (the Lua checksum changes). It ships with MKev's Modpatch Installer v1.32.

### What 1.2 changed

1.2 is 1.1b without a functional change. `mod.info` now has `versionMin=42.21` (was `42.20.0`) and still no `versionMax`, so later game updates do not lock the mod. The version file says `1.2`, so the server and every player need 1.2 (the Lua checksum changes). It ships with MKev's Modpatch Installer v1.3.

### What 1.1b changed

1.1b keeps the 1.1_vvr guard unchanged. The only addition in 1.1b is the Tweed jacket fix below. The mod id stays `mkev_modpatcher`.

Result of the current guard: vanilla vehicles do not slip through, and the `Bullet.removeVehicle` crash path is not used.

---

## Spongie's Clothing: Tweed jacket BodyLocation

Added in **1.1b** (`mkevmp_spongie_tweedfix.lua`). No Spongie file is copied or modified.

The "Tweedjacke" (EN "Suit Jacket - Tweed") is not a vanilla item. It comes from **Spongie's Clothing** (Workshop 2684285534, mod id `SpnCloth`):

- `Spongie.Jacket_Tweed` — BodyLocation `base:jacket_suit`
- `Spongie.Jacket_TweedOPEN` — BodyLocation `base:JACKET_OPEN`

Neither id exists in B42.22. Vanilla uses `base:jacketsuit`. Spongie's Open Jackets [BASE] (mod id `SpnOpenClothBase`) registers `SpnOpenCloth:JACKET_OPEN`. An unknown id makes `getBodyLocation()` null, and every mouse hover threw a `NullPointerException` at `Clothing.DoTooltip(Clothing.java:233)` (**578×** in one session on 2026-11-10). Tooltip mods in the stack (Starlit Library, KATTAJ1, Burd's Journals, Ente's Auto Sorter, I Know It!) only pass the call on.

The fix sets the correct BodyLocation on both script items with `DoParam`:

- `Jacket_Tweed` → `base:jacketsuit`
- `Jacket_TweedOPEN` → `SpnOpenCloth:JACKET_OPEN`, and only if Open Jackets [BASE] is active

It runs only if Spongie's Clothing is active, and only while the location is still missing. If the location is already valid, the item is left alone. It runs on `OnGameBoot`, `OnInitGlobalModData`, `OnGameStart`, and `OnServerStarted`. `InventoryItem.getBodyLocation()` reads the script item, so jackets that already exist are fixed too. One log line per fixed item: `[MKev-ModPatcher] Spongie tweed fix: <item> BodyLocation -> <id>.`

---

## Credits

Made by **MKev**.

The mods this patcher works around belong to their authors and keep full credit. This zip ships none of their files.
