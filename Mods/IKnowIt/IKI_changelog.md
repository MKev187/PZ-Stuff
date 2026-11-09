# I Knew It! – Changelog

Project Zomboid, Build 42 (singleplayer and multiplayer). Author: MKev.

## 1.0.1

### Changed
- Sandbox options reduced to the feature switches only. The page "I Knew It!" now has exactly five options:
  - Overlay size (percent)
  - Easy Picking on / off
  - Skill book feature on / off
  - Skill books: Look up on / off
  - Skill books: Look up time factor (default 0.5 = half the time of a full read)
- All other former options are now fixed and no longer read from the sandbox settings, so values left over in old saves have no effect. Fixed values: all icons shown (light bulb, XP symbols, traffic light, ? / !), tooltip legend on, title prefixes on, look-up XP 50 %, boredom reduction 10 points per hour, Easy Picking arrow and right-click menu on.
- Easy Picking now always works two levels deep (e.g. key ring in a handbag in a closet). Before, this was an optional setting that was off by default.
- New "Skill book feature" switch. Off: no XP symbol and no [Skillbook] prefix on skill books, no boredom reduction from skill books, and Look up is disabled as well. Traffic light, light bulb and all symbols on other media stay.
- Look up now depends on the skill book feature. If Look up is off, the ? / ! mark and the XP-Drop symbol are hidden as well.
- mod.info (both files) uses the new description text, `modversion=1.0.1`, `versionMin=42.21`.

### Added
- Translations: German, English, Traditional Chinese (all four text files each: Sandbox, ContextMenu, Tooltip, IG_UI).

## 1.0.0

### Removed
- All reading bonuses: faster reading depending on where you sit (floor, chair, armchair, bed, toilet), the reading glasses bonus, and reading while walking.
- The related files (`iki_readspeed.lua`, `iki_walkread.lua`), the eight sandbox options and their translations, the reading comfort example image, and the "reading features" part of the Workshop description.
- M-13's Reading Tweaks is no longer listed as incompatible. The mod does not touch the reading duration or the walking behavior of the game any more.

### Changed
- Look up still takes the configured share of the game's normal reading duration for the book (default half). Texts that still mentioned seat bonuses, reading glasses or reading while walking were cleaned up.
- Version number updated in the code (log line and header of the data file) and in mod.info.
- `workshop.txt` keeps its original line endings. `verification_manifest.json` regenerated.

## 0.4.0 and earlier (summary)
- Documents of other mods that grant one-time flat XP (e.g. Working Knowledge) get an XP symbol, display only.
- Easy Picking: server-safe take action for bags the server cannot address as a transfer source.
- Fixes for Look up in multiplayer, title prefixes for teaching media, boredom reduction while reading skill books, symbol legend in the tooltip.
