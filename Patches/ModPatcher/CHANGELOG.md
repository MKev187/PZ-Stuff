# Changelog: MKev's Modpatcher

Mod id `mkev_modpatcher`. The folder name and the mod id do not change between versions, so the `Mods=` entry stays `mkev_modpatcher`.

Version scheme: internal builds through 2026-10-31 used `0.1.<n>`. Older labels `1.1` through `1.8` map to `0.1.1` through `0.1.8` (an installed 1.8 build stayed labeled 1.8). From 2026-11-10 the public builds are `1.1_vvr`, `1.1b`, `1.2` and `1.3`. There is no standalone zip for the `0.1.x` or `1.x` builds; those shipped only inside the installer package. The build-by-build notes below for 0.1.11 and earlier are the mod's own `CHANGELOG.md` from `Modpatcher-v1.1b.zip`, with the installer-package notes left out.

## MKev's Modpatcher v1.3.2 — 2026-11-13

**Download:** [`Modpatcher-v1.3.2.zip`](Modpatcher-v1.3.2.zip)  
**SHA256:** `5be06bec829b6b41a4724585d726425d792afb0213dc82982374fddf633161e9`

### Changed
- Connect notice (`mkevmp_connectnotice.lua`, `Translate/EN/UI.json`): rewritten warning text (DE/EN). The title is now
  all-caps `HINWEIS` / `CAUTION` and blinks once per second (500 ms visible, 500 ms hidden) by changing only the
  title alpha in `prerender` via `getTimestampMs` (gold colour unchanged). Paragraph 4 starts with an inline red
  `ACHTUNG!` / `ATTENTION!`, then the timeout hint in the normal body colour on the same wrapped paragraph. The red
  quoted game error (`UI_GameLoad_UnexpectedError1`) and the "restart the client" line are unchanged. The window
  still grows with the text and tightens padding/line gap on short screens (including 1280x720) so everything stays
  visible.
- Reload-speed guard (`mkevmp_reloadspeed.lua`, since 1.3.1): nil-safe wrap of vanilla `ISReloadWeaponAction.setReloadSpeed`.
  Existing shared wrappers (including VFE's override and BritasArmorReloadCompat) stay in the chain. The wrap only
  falls back on the nil-strap error; normal VFE reload-speed behavior is unchanged.
- `mkevmp_version.lua` / `mod.info`: `modversion` 1.3.2 (id `mkev_modpatcher` and display name
  `MKev's Modpatcher` unchanged). Server and all clients need the same version, because the Lua
  checksum changes.

## MKev's Modpatcher v1.3 — 2026-11-12

**Download:** `Modpatcher-v1.3.zip` (no longer stored standalone; still inside archived installer v1.32)  
**SHA256:** `08189195765db5d0c513992dfa079587f097f3f865d61e7ab7c08866218b34b1`

1.3 adds a timeout hint to the connect notice. It ships with MKev's Modpatch Installer v1.32.

### Changed
- Connect notice: the loading notice now also says that a rare connection timeout on the first join can show the game's error message, quoted in red. The wording is taken verbatim from the game translation files (key `UI_GameLoad_UnexpectedError1`, checked in the B42 client on 12.11.2026): DE `Leider ist ein unerwarteter Fehler aufgetreten.` / EN `Sorry, an unexpected error occurred.` The notice then tells the player to restart the client and connect again. The previous loading-notice paragraphs are unchanged. The 30-second client timeout itself is hard-coded in Java (`IsoWorld.init`) and cannot be changed from Lua.
- `mkevmp_version.lua` / `mod.info`: `modversion` 1.3 (id `mkev_modpatcher` and display name `MKev's Modpatcher` unchanged). Server and every player need 1.3, because the Lua checksum changes.

## MKev's Modpatcher v1.2 — 2026-11-11

**Download:** `Modpatcher-v1.2.zip` (no longer stored in this folder; inside the archived installers v1.31 / v1.3 / v1.3b)  
**SHA256:** `72e78c65d3e62ad6e14d9bdf3aa920344062ebf73a18d8876722d787ef941b17`

1.2 is 1.1b without a functional change. It ships with MKev's Modpatch Installer v1.3.

### Changed
- `mod.info`: `versionMin=42.21` (was `42.20.0`), still no `versionMax`, so later game updates do not lock the mod. modversion `1.2`.
- `mod.info` name: `MKev's Modpatcher` (was `MKev-ModPatcher v1.1b`). Only the name in the mod list changes; the id `mkev_modpatcher` stays, so server `Mods=` lines and saves need no change.
- `mkevmp_version.lua`: `1.2`. The log shows `[MKev-ModPatcher] version 1.2 loaded`. Server and every player need 1.2, because the Lua checksum changes.

## MKev's Modpatcher v1.1b — 2026-11-10

**Download:** `Modpatcher-v1.1b.zip` (no longer stored in this repository; inside the archived installer v1.2)  
**SHA256:** `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`

1.1b is 1.1_vvr plus the Tweed jacket fix. The VVR guard change from 1.1_vvr is unchanged.

### Added
- `42/media/lua/shared/mkevmp_spongie_tweedfix.lua`. Spongie's Clothing (Workshop 2684285534, mod id `SpnCloth`) gives `Spongie.Jacket_Tweed` the BodyLocation `base:jacket_suit` and `Spongie.Jacket_TweedOPEN` the BodyLocation `base:JACKET_OPEN`. Neither id exists in B42.22, so `getBodyLocation()` is null and every hover over a Tweed jacket threw a `NullPointerException` at `Clothing.DoTooltip(Clothing.java:233)` (578× on 2026-11-10, 04:31–04:33). Tooltip mods in the stack only pass the call on.
- The file sets `base:jacketsuit` and `SpnOpenCloth:JACKET_OPEN` (the OPEN jacket only if `SpnOpenClothBase` is active) with `DoParam`, only if `SpnCloth` is active and only while the location is still missing. It checks that the result is non-null and logs one line per fixed item: `[MKev-ModPatcher] Spongie tweed fix: <item> BodyLocation -> <id>.`
- Runs on `OnGameBoot`, `OnInitGlobalModData`, `OnGameStart`, and `OnServerStarted`. `InventoryItem.getBodyLocation()` reads the script item, so jackets that already exist are fixed too.
- `mkevmp_version.lua` and `mod.info`: version `1.1b`.

### Upgrade
Server and all players need 1.1b. The log shows `[MKev-ModPatcher] version 1.1b loaded`. Hovering the Tweed jacket no longer reports that error.

## MKev's Modpatcher v1.1_vvr — 2026-11-10

**Download:** `Modpatcher-v1.1_vvr.zip`  
**SHA256:** `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a`  
That standalone zip is not in this repository. Installer v1.1 bundled this build; that installer zip is not stored here either. 1.1_vvr is 0.1.11 plus the VVR hotfix only.

### Changed
- `mkevmp_vvrspawnguard.lua` no longer keeps vanilla vehicles. From 0.1.8 through 0.1.11 the guard skipped VVR on the dedicated server for every vehicle with `isCreated() == true`, so vanilla vehicles that VVR missed at first spawn stayed vanilla (for example `Base.StepVan_MobileLibrary`, client log 2026-11-10 02:21).
- Dedicated server only, VVR handler only:
  - New vehicle: VVR replaces it as before. Without a square yet (VVR returns early), it is queued and checked again.
  - Existing vehicle without physics: VVR replaces it directly. Condition, rust, blood, and parts are kept.
  - Existing vanilla vehicle with physics that VVR has a replacement for (the `Bullet.removeVehicle` path): VVR is not called. The vehicle is removed with `permanentlyRemove()` and spawned again with the same vanilla script on the same square, so VVR swaps the new vehicle. Occupied, towing, or towed vehicles are kept. Items stored in a respawned vanilla vehicle are lost. Each square and script at most once per server run.
  - One log line per vehicle: `VVR guard: replaced <script> -> <target> at x,y`, `FAILED ...`, or `kept ...`, at most 20 per 60 seconds, then `N more vehicle lines suppressed`. Startup line: `VVR spawn guard active (dedicated server, 1.1_vvr: vanilla vehicles are replaced).`
- `mkevmp_version.lua` and `mod.info`: version `1.1_vvr`. No other file changed.

### Background
The guard was added in 0.1.8 because VVR's swap on chunk load caused `UnsatisfiedLinkError: Bullet.removeVehicle` on the dedicated server (15× from 2026-10-27 to 2026-10-30). The server did not crash, but the swap stopped half way and clients got seat-sync error spam. 1.1_vvr replaces the vehicles without that error path.

### Upgrade
Server and all players needed the same build. The server log showed `[MKev-ModPatcher] version 1.1_vvr loaded` and `VVR guard: replaced …` lines.

## MKev's Modpatcher 0.1.11 — 2026-10-31

Installed until 1.1_vvr. This is the build inside [MKev's Modpatch Installer v1.0](../Patch-Installer/README.md) and inside `MKev-ModPatcher-v0.3.0.zip`. There is no standalone 0.1.11 zip. Installer v1.0 records it as byte-identical to the copy in the 0.3.0 package.

### Added
- `mkevmp_connectnotice.lua`: short loading notice with an OK button. German when `Translator.getLanguage()` is DE, English otherwise. The text warns that loading can take a while because of the amount of mod data, and not to press keys or click while Windows shows the hourglass or the spinning circle. This can happen before and after the game's own "Click to start" label.
  - Main menu, before the connect: `ConnectToServer.connect` is wrapped (the vanilla 11-parameter signature). The vanilla connect starts after OK. Coop (`connectCoop`) is not touched. A Lua window during the download or the loading screen is not possible: the server's mod Lua loads in `ConnectToServerState.Finish`, and `GameLoadingState` suspends the Lua UI.
  - Fallback in game: `OnGameStart`, MP client only (not single player, not a coop host), when there was no menu OK for this connect. The window covers the screen, and the character is held with `setBlockMovement` until OK. An MP game cannot be paused.
  - Once per connect. The confirm time is kept in `Zomboid/Lua/mkev_connectnotice.txt` because Lua state is reset during the connect. Menu: no second window within 10 minutes after OK. Game: a menu OK younger than 60 minutes counts for this connect and is then marked used. Fail-open: any error leaves the vanilla connect unchanged.
  - Log: `[MKev-ModPatcher] connectnotice: shown (...)` / `confirmed (...)`.
- Local mod list: players who only subscribed to the Workshop collection have the mod in the server list, not in their local default list, so the main-menu window could not run. On an MP client, once per session at `OnGameStart`, the file adds `mkev_modpatcher` with `ActiveMods.getById("default"):setModActive` and `saveModsFile()`. Add-only: nothing is removed, reordered, or otherwise changed. Already present (including the B42 leading backslash) means nothing is saved. If saving fails, the id is taken back out of memory. Skipped when mods are disabled in the game options. After the player returns to the main menu, the main-menu window works from the next connect, with no game restart. The first join of a new player still uses the in-game fallback.
- `Translate/EN/UI.json`: both languages as separate keys. Own `{click}` placeholder instead of `%1`, because the game formats every `getText` result.

### Changed
- With the mod on the local default list it also loads in the main menu and in new single-player games. `mkevmp_zedmonitor.lua` wraps spawn functions only on the server and starts only on the server or an MP client. `mkevmp_postdeathguard.lua` acts only on an MP client. The other files already checked their target mod, or were already limited to the MP client or the dedicated server.
- `mod.info` / `mkevmp_version.lua`: version 0.1.11. The Server BootPatch beside this build was still 1.0.2. The later packages `MKev-ModPatcher-v0.3.0.zip` and installer v1.0 ship BootPatch 1.1.0 with this same 0.1.11 ModPatcher.

## MKev's Modpatcher 0.1.10 — 2026-10-31

### Added
- `mkevmp_postdeathguard.lua`. On 2026-10-30 23:47 CET the death-screen buttons (New character / Quit) did not react, with no Lua error. Vanilla `ISPostDeathUI` ignores clicks while `MainScreen.instance:isReallyVisible()` is true, and an invisible always-on-top panel would swallow clicks too. The guard keeps the death screen always on top (once per second, including the quit confirm dialog), logs `[MKev-PDG]` (death, a snapshot 4 s after death, each left click, max 25), wraps `onRespawn` / `onExit` / `onQuitToDesktop`, and after 10 s without a successful click shows a small window that calls the vanilla handlers. It turns itself off on any error.

### Changed
- Zombie spawn monitor: timestamps in Europe/Berlin local time (CET/CEST) instead of UTC.
- A-Life NPC bodies and Starving Zombies skeleton templates are no longer counted. One `AUSGEFILTERT npc_shell=N skelett=N` line per minute.
- Version 0.1.10. Server BootPatch was unchanged at 1.0.2.

## MKev's Modpatcher 0.1.9 — 2026-10-30

### Added
- `mkevmp_zedmonitor.lua`: zombie spawn monitor. Wraps the global Lua spawn functions that exist, reads the caller from the Kahlua frames, and calls the original with the original arguments. `OnZombieCreate` classifies each new real zombie (mod spawn, vanilla room, late room, reanimation, or cell load). Census every 10 s: zombies within 30/80 tiles per player, written only on change. Client: own count, plus room-seen to zombies inside after 3 s. Logs under `Zomboid/Lua/`, 2 MB cap, then one older file. Max 120 lines per minute.
- Sandbox option `MKevMP.ZedMonitor` (boolean, default true during the test phase), EN translation in `Sandbox.json`.
- Empty `media/AnimSets` and `media/actiongroups` placeholders in `common/` and `42/`.

## MKev's Modpatcher 0.1.8 (labeled 1.8) — 2026-10-30

### Added
- `mkevmp_vvrspawnguard.lua`, first version. On the dedicated server, calls for vehicles that already existed were skipped, so they kept their current script. New vehicles were still replaced. Other handlers, clients, host, and single player were untouched. See MKev's Modpatcher v1.1_vvr above for the later behaviour. The dedicated-server `UnsatisfiedLinkError` was logged 15×, and one client session on 30 Oct 2026 logged `BufferUnderflowException` 1239×.

### Changed
- Version label 1.8. Description: game 42.20 became game 42.21.

## MKev's Modpatcher 1.7 — 2026-10-27

Installed 2026-10-30. In the internal mapping, 1.7 corresponds to 0.1.7.

### Added
- `mkevmp_oncreatealias.lua`: Realistic Army Zombies (`RAZ.Hat_GasMaskArmy`, `RAZ.Hat_GasMaskArmyHood`) and Extra Bombs 2 (`ExtraBombs.ExtraBombsMag`) still used `SpecialLootSpawns.OnCreateGasMask` and `SpecialLootSpawns.OnCreateRecipeMagazine`. In 42.21 those functions live on `ItemCodeOnCreate`, so every spawn logged `no such function` and skipped the vanilla setup (gas-mask filter, magazine title). The file aliases the old names only if the key is still empty and only when one of the two mods is active.
- `mkevmp_fillcontainerguard.lua` (added 2026-10-30): vanilla 42.21 sometimes passes a loot definition (`ItemPickerJava$ItemPickerContainer`) instead of the bag's `ItemContainer` to `OnFillContainer`. Handlers then failed on the server (Computer Mod - New Music Integration, Low Condition Guns, Spoiling Liquids; 48 server stack traces in 5 sessions, 27–29 Oct 2026). Handlers registered after this file skip only calls whose container is not an `ItemContainer`. Spoiling Liquids registers earlier, in `shared/`, and stays upstream.

## MKev's Modpatcher 1.6 — 2026-10-26

### Added
- `mkevmp_primitivebow_anm.lua`: Archery Nexus [Fixed] (3731579266) and Archery Nexus [RadBows] (3781962845) both ship `ArcheryNexus_ANM.lua`. The RadBows copy loads later and only handles the heavy compound bow, so the Primitive Bow never switched to `REX5_MD_BOW`. This file re-adds that switch for `Primitive_Bow` only, and only when both mods are active and the model exists.

### Changed
- `loadAfter`: WeightReduction dropped (removed from the pack). `ArcheryNexusFixed` and `ArcheryNexus_RB` added. The WeightReduction tooltip keys stay in `Sandbox.json`, unused.

## MKev's Modpatcher 1.5.2 — 2026-10-26

### Fixed
- `mkevmp_alifewindowhands.lua`. With 1.5.1 there were still 4× `ClassCastException IsoZombie -> IsoPlayer` in `PlayerDropHeldItemsPacket.setData` via `climbThroughWindow` (18:39–18:42), from `IsoZombie.tryThump` and `ThumpState.execute`. The check now covers the edges of the 3×3 squares around the shell (radius 1 tile), with no facing test. Moving, thump, or an action state containing climb/thump counts.

### Added
- Log once at game start: `A-Life window guard active (client, v1.5.2, radius 1 tile)`, and at most every 10 minutes `prevented / refused / missed / errors` when a counter changed.

## MKev's Modpatcher 1.5.1 — 2026-10-26

### Removed
- `42/media/scripts/MSC_Building.txt`, the Maskarad's Summer Car override added in 1.5. Moving the entity to `module Base` blocked client joins on an existing world: `WorldDictionaryException: [SpriteConfigs] Missing dictionary script on client: MaskaradsSummerCar.WorkshopCarLift`. Keeping both the original entity and a Base copy was rejected as well: `SpriteConfigManager` refuses the same sprite bound twice and world loading aborts. Summer Car is original again. The stale `Base.WorkshopCarLift` dictionary entry written by the 1.5 boot is not cleaned up by the game.

## MKev's Modpatcher 1.5 — 2026-10-26

### Added
- `MSC_Building.txt` override of Maskarad's Summer Car (Workshop 3790160840): `module MaskaradsSummerCar` changed to `module Base`, entity body unchanged. This answered 40× `EntityScript not found, script: WorkshopCarLift` when new chunks with vanilla car lifts were generated. Removed again in 1.5.1.
- `mkevmp_brita_nv_legacy.txt`: Brita's Armor Pack (Workshop 3780298456, `BritasArmorPackB42` 1.4.9) kept six pre-1.4 night-vision names only as `Obsolete = true` stubs. The server stored them in the world dictionary and the client dropped the obsolete scripts, so every join logged 6× "client has no script for dictionary info" (`Base.Hat_Sam_NV`, `NV_PVS5`, `NV_PNV_57`, `NV_PVS7`, `NV_PVS21`, `NV_GPNVG_18`). The file adds a full `Obsolete = false` body for each, matching Brita's `*_ON` item. Brita's own migration still swaps any old item.

## MKev's Modpatcher 1.4 — 2026-10-26

### Added
- Three clothing stand-ins for Realistic Army Zombies (Workshop 1902435140): `Jacket_M65_Green.xml`, `Jacket_ArmyCamoGreenHot.xml`, `Hat_PatrolCapGreen.xml`. The mod lists those paths and uses their GUIDs, but does not ship the files. Server log 2026-10-26 07:51: `FileNotFoundException` for `Jacket_M65_Green.xml` when such a zombie spawns. The stand-ins use the mod's GUIDs and the look of the matching vanilla items. Visual only: the mod has no item script for them either.

## MKev's Modpatcher 1.3 — 2026-10-25

### Added
- `mkevmp_insertmagguard.lua` (MP client). When `ISInsertMagazine:start()` cannot find the magazine in the main inventory yet, the original reference is kept. Stops `setJobDelta` of nil (10 errors in one reload on 2026-10-25 17:42).
- `mkevmp_neatlockshovequiet.lua` (client, only if NeatLockpicking, Workshop 3783535220, is loaded). Drops a no-op `setVariable("bDoShove", "false")` that flooded the log (about 130 lines/s; 2711 lines from 18:31:00 to 18:31:21 on 2026-10-25). Behaviour is unchanged. The hold branch while Space is held just after the crowbar panel closes stays upstream.

## MKev's Modpatcher 1.2 — 2026-10-25

### Added
- `mkevmp_alifewindowhands.lua` (MP client, only if Project A-Life NPCs is active). Before an engine window climb, a local A-Life NPC shell that is holding an item gets A-Life's own `ProjectALife.TraversalHands.prepare(shell, true)`, which empties the hands for about 1.2 s and re-equips after the climb. This stops vanilla `dropHeavyItems()` from sending `PlayerDropHeldItems` with an `IsoZombie`, which raised `ClassCastException` and the red error popup. Widened in 1.5.2.

## MKev's Modpatcher 1.1 — 2026-10-25

Draft, not installed. Successor of MKevPackPatches 2.5.0. Do not run it together with MKevPackPatches.

### Added
- `Translate/EN/Sandbox.json`: `%` escaped as `%%` in six sandbox texts that made the Translator log format warnings. Four TrueSmoking tooltips (Workshop 3423984426) and two WeightReduction keys (Workshop 3774841057). Wording unchanged. The WeightReduction keys are unused from 1.6, when that mod left the pack.
- `mkevmp_purserverguard.lua`: empty `PUR` table on dedicated servers so Plysken Underground Revolution's server file loads. Only if PUR is active.
- `mkevmp_00_config.lua`: `MKevModPatcher.isModActive`, plus a warning if MKevPackPatches is active too.
- `mod.info`: `incompatible=MKevPackPatches`.

### Changed
- New name "MKev-ModPatcher v1.1", new id `mkev_modpatcher`, log prefix `[MKev-ModPatcher]`.
- File names lowercase with an `mkevmp_` prefix.
- JP82 spare-tire guard runs only if `82jeepJ10` is active.
- Soda-can alias runs only if FunctionalAppliances2 or Authentic Z is active.
- Vehicle template bodies were byte-identical to MKevPackPatches 2.5.0; only the file names changed, plus a header comment. That set is the KI5 gunracks (`SSP93Gunrack`, `SUB87Gunrack`), the JP82 spare-tire restore, the P19A/DAMN67 stubs, and 12 stale-reference stubs.
