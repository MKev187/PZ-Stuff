# Changelog: MKev's Modpatch Installer

Current package in this folder: `Modpatch-Installer-v1.2.zip`.
Older packages (`Modpatch-Installer-v1.1b.zip`, `Modpatch-Installer-v1.0.zip`, `MKev-ModPatcher-v0.3.0.zip`) are in [Patches/Patch-Installer](../Patches/Patch-Installer/README.md).
`Modpatch-Installer-v1.1.zip` and `Modpatcher-v1.1_vvr.zip` are not stored in this repository. The hashes in the v1.1 section below are the ones published with those versions. The standalone current patcher is [`Modpatcher-v1.1b.zip`](../Patches/ModPatcher/Modpatcher-v1.1b.zip), the standalone BootPatch is [`Server-BootPatch-v1.1.1.zip`](../Patches/Server-BootPatch/Server-BootPatch-v1.1.1.zip).

## v1.2 - 2026-11-10

**Download:** [`Modpatch-Installer-v1.2.zip`](Modpatch-Installer-v1.2.zip)  
**SHA256:** `c9c6b3d48882b2136dfce0d750f1b1cb2d390e71969e79d374967dde6613a727`  
Bundled ModPatcher: `mkev_modpatcher` 1.1b (unchanged, also as [`Modpatcher-v1.1b.zip`](../Patches/ModPatcher/Modpatcher-v1.1b.zip), SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).  
Bundled BootPatch: `mkevserverbootpatch` **1.1.1** (also as [`Server-BootPatch-v1.1.1.zip`](../Patches/Server-BootPatch/Server-BootPatch-v1.1.1.zip), SHA256 `f218f38753b77cc7c0eaa2fb6aba116f403f2a21c85f8011a4167a663eb23466`).

### Changed
- Bundled `mkevserverbootpatch`: 1.1.0 → **1.1.1**. The 3 script fixes are fixed parts of the mod again:
  `42/media/scripts/recipes/recipes_fletching.txt` (Archery Nexus [Fixed]: `Carpentry:3` → `Woodwork:3`),
  `42/media/scripts/recipes/recipes_MCR_1Handed.txt` (Mad Crafter: 6× `Electrical:` → `Electricity:`),
  `42/media/scripts/sounds/LabSounds.txt` (Zombie Virus Vaccine: `//` comment → `/* */`, sound `Injection_A`).
  Same bytes as the files the installer built before (SHA256 `05A17570…`, `2D8F91B3…`, `5B674938…`).
- Reason: on a Linux dedicated server the Windows installer never runs. BootPatch 1.1.0 then had only placeholders and all
  F1–F3 boot messages stayed. 1.1.1 works on any server by copying the mod folder.
- Self-healing instead of a fixed build step: the bundled files are the defaults. At every install the installer finds the
  original file the game loads (highest `42.x` version folder, else `common`, names case-insensitive, `PZ_GAMEBUILD` caps the
  folder) and decides per fix: original unchanged → bundled file stays (`KEEP`); changed and the error is still in it → the fix is
  rewritten from the new original with the same token edit, BOM/CRLF kept, checked (error tokens gone, only the intended lines,
  braces balanced) and written into `mkevserverbootpatch` (`REBUILT`); error gone → our override is removed and logged
  (`FIXED_UPSTREAM`); mod no longer loads the file → override removed (`NOT_LOADED`); mod not found → bundled file stays with a
  note (`MISSING`); check failed → WARNING, the file installed before stays, nothing broken is written, the install never aborts
  (`FAIL`). Backup before every overwrite (restore with mode 3), `MANIFEST.sha256` is rewritten. No new BootPatch version is
  needed when one of these mods updates.
- `mkevserverbootpatch` 1.1.1: `versionMin=42.21`, no `versionMax`; new `README_DE.md`, `tools/bootfix.ps1` (shared core),
  and the optional admin tools `tools/check_upstream.ps1 -Fix` / `tools/check_upstream.sh --fix` (Linux: sh, awk, sha256sum) with the
  same logic (no setup needed; without the switch both are a dry run).
- Docs: collection title is now "MKev Zomboid Modlist B42.22" everywhere (the old `(v1.0)` suffix is gone); display titles "MKev's Modpatch Installer" / "MKev's Modpatcher".
- Installer version 1.1b → **1.2** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe files).

### Unchanged
- `mkev_modpatcher` 1.1b (`versionMin=42.20.0`), `MKevServer_setup` (376 mods / 325 WorkshopItems incl. I Know It! 3836594593 /
  `Map=Muldraugh, KY` / SandboxVars / preset), both modes, restore, dry run, both languages.

### Upgrade from v1.1b, v1.1 or v1.0
- Run the v1.2 installer again (option 1 or 2), or replace only the folder `Zomboid\mods\mkevserverbootpatch` with the one from the zip.
- Server and all players need the same BootPatch files (1.1.1). On a Linux server copy the folder to `Zomboid/mods/` of the server and
  add it to `Mods=` - done. No start script has to be changed. `tools/check_upstream.sh` is only an optional tool for admins who want it.
- Check: the server log shows `mod "mkevserverbootpatch" overrides media/scripts/recipes/recipes_fletching.txt` (and the two other files),
  and no more `Unknown skill "Carpentry"`, `Unknown skill "Electrical"` or `"//Royalty-free"` lines.

## v1.1b - 2026-11-10

**Download:** [`Modpatch-Installer-v1.1b.zip`](../Patches/Patch-Installer/Modpatch-Installer-v1.1b.zip) (archive)  
**SHA256:** `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f`  
Bundled ModPatcher: `mkev_modpatcher` 1.1b (also as `Modpatcher-v1.1b.zip`, SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).

### Changed
- Bundled `mkev_modpatcher`: 1.1_vvr → **1.1b** (Hotfix Tweed jacket). The VVR change of 1.1_vvr is kept. Mod id stays `mkev_modpatcher`.
- Installer version 1.1 → **1.1b** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe files). No other code change.

### ModPatcher 1.1b: Tweed jacket fix
- The item: the "Tweedjacke" (EN "Suit Jacket - Tweed") is not vanilla. It comes from **Spongie's Clothing** (WS 2684285534, mod id `SpnCloth`):
  `Spongie.Jacket_Tweed` and `Spongie.Jacket_TweedOPEN`.
- The bug: both items have a BodyLocation that does not exist in B42.22 (`base:jacket_suit` instead of `base:jacketsuit`, and
  `base:JACKET_OPEN` instead of `SpnOpenCloth:JACKET_OPEN`). Every mouse hover over the jacket threw a
  `NullPointerException` at `Clothing.DoTooltip(Clothing.java:233)` (578× in one session on 2026-11-10, error counter bottom right).
  The tooltip mods in the stack (Starlit Library, KATTAJ1, Burd's Journals, Ente's Auto Sorter, I Know It!) only pass the call on.
- The fix: new file `mkevmp_spongie_tweedfix.lua` sets the correct BodyLocation on both items (`Jacket_TweedOPEN` only if
  Spongie's Open Jackets [BASE] is active). It only runs if Spongie's Clothing is active and only while the location is still missing.
  Jackets that already exist are fixed too. Log line: `[MKev-ModPatcher] Spongie tweed fix: <item> BodyLocation -> <id>.`

### Unchanged
- `mkevserverbootpatch` 1.1.0, `MKevServer_setup` (376 mods / 325 WorkshopItems / `Map=Muldraugh, KY` / SandboxVars / preset), both modes, both languages.

### Upgrade from v1.1 or v1.0
- Run the v1.1b installer again (option 1 or 2), or replace only the folder `Zomboid\mods\mkev_modpatcher` with the one from the zip.
- Server and all players need the same ModPatcher version (1.1b).
- Check: the log shows `[MKev-ModPatcher] version 1.1b loaded`. Hovering the Tweed jacket shows no more errors.

## v1.1 - 2026-11-10

**Download:** `Modpatch-Installer-v1.1.zip`  
**SHA256:** `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c`  
Bundled ModPatcher: `mkev_modpatcher` 1.1_vvr (also as `Modpatcher-v1.1_vvr.zip`, SHA256 `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a`).

### Changed
- Bundled `mkev_modpatcher`: 0.1.11 → **1.1_vvr** (Hotfix VVR). Mod id stays `mkev_modpatcher`, so `Mods=` does not change.
- Installer version 1.0 → **1.1** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe files). No other code change.

### ModPatcher 1.1_vvr: what changed
- The VVR guard now lets VVR (KI5 Vanilla Vehicles Replacer) replace vanilla vehicles again.
  Before (0.1.8 to 0.1.11), the guard skipped VVR on the dedicated server for every vehicle that already existed.
  Vanilla vehicles that VVR missed at their first spawn stayed vanilla, for example Step Vans and Vans.
- Behaviour now (dedicated server only, VVR handler only):
  - New vehicle: VVR replaces it as before. Without a square yet (VVR returns early), it is queued and checked again.
  - Existing vehicle without physics: VVR replaces it directly. Condition, rust, blood and parts are kept.
  - Existing vanilla vehicle with physics: it is removed and spawned again with the same vanilla script on the same square.
    VVR then replaces the new vehicle itself.
  - Occupied, towing or towed vehicles are kept. Items stored in a respawned vanilla vehicle are lost.
  - One server log line per vehicle: `VVR guard: replaced <script> -> <target> at x,y`, `FAILED ...` or `kept ...`, max 20 per minute.
- Background: the guard came in with 0.1.8 because VVR's swap on chunk load caused `UnsatisfiedLinkError: Bullet.removeVehicle`
  Lua errors on the dedicated server (15× from 2026-10-27 to 2026-10-30). The server did not crash, but the swap stopped half
  way and clients got seat-sync error spam. 1.1_vvr replaces the vehicles without that error path.

### Unchanged
- `mkevserverbootpatch` 1.1.0.
- `MKevServer_setup`: `Mods=` (376), `WorkshopItems=` (325, incl. I Know It! 3836594593), `Map=Muldraugh, KY`,
  `MKevServer_SandboxVars.lua` (SHA256 86ce6f4f…f833), preset `MKevServer`.
- Both modes (1 Install & set up, 2 Install only), restore, dry run, both languages (EN/DE).
- Mode 1 still replaces only `Mods=`, `WorkshopItems=` and `Map=`. Passwords, ports and logins are never changed.

### Upgrade from v1.0
- Run the v1.1 installer again (option 1 or 2), or replace only the folder `Zomboid\mods\mkev_modpatcher` with the one from the zip.
- Server and all players need the same ModPatcher version (1.1_vvr).
- Check: the server log shows `[MKev-ModPatcher] version 1.1_vvr loaded` and `VVR guard: replaced …` lines.

## v1.0 - 2026-11-09
Installer for the collection release (base 0.3.0multi, EN/DE). Build 42.22.2, collection 3827894199, 376 mods / 325 WorkshopItems,
`mkev_modpatcher` 0.1.11, `mkevserverbootpatch` 1.1.0. SHA256 of `Modpatch-Installer-v1.0.zip`:
`12b5647a6a1744a0a5ac6507948356dfc3f0d7c09741c7d1c458b7b3f06b03b2`.

---

## Deutsch

## v1.2 - 10.11.2026

**Download:** [`Modpatch-Installer-v1.2.zip`](Modpatch-Installer-v1.2.zip)  
**SHA256:** `c9c6b3d48882b2136dfce0d750f1b1cb2d390e71969e79d374967dde6613a727`  
Enthaltener ModPatcher: `mkev_modpatcher` 1.1b (unverändert, auch einzeln als [`Modpatcher-v1.1b.zip`](../Patches/ModPatcher/Modpatcher-v1.1b.zip), SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).  
Enthaltener BootPatch: `mkevserverbootpatch` **1.1.1** (auch einzeln als [`Server-BootPatch-v1.1.1.zip`](../Patches/Server-BootPatch/Server-BootPatch-v1.1.1.zip), SHA256 `f218f38753b77cc7c0eaa2fb6aba116f403f2a21c85f8011a4167a663eb23466`).

### Geändert
- Enthaltener `mkevserverbootpatch`: 1.1.0 → **1.1.1**. Die 3 Skript-Fixes sind wieder fester Bestandteil des Mods:
  `42/media/scripts/recipes/recipes_fletching.txt` (Archery Nexus [Fixed]: `Carpentry:3` → `Woodwork:3`),
  `42/media/scripts/recipes/recipes_MCR_1Handed.txt` (Mad Crafter: 6× `Electrical:` → `Electricity:`),
  `42/media/scripts/sounds/LabSounds.txt` (Zombie Virus Vaccine: `//`-Kommentar → `/* */`, Sound `Injection_A`).
  Byte-gleich mit den Dateien, die der Installer bisher gebaut hat (SHA256 `05A17570…`, `2D8F91B3…`, `5B674938…`).
- Grund: Auf einem Linux-Dedicated-Server läuft der Windows-Installer nie. BootPatch 1.1.0 hatte dort nur Platzhalter, alle
  F1–F3-Meldungen blieben. 1.1.1 funktioniert auf jedem Server, indem man den Mod-Ordner kopiert.
- Selbstheilung statt festem Bau-Schritt: Die mitgelieferten Dateien sind der Standard. Bei jeder Installation sucht der Installer
  die Original-Datei, die das Spiel lädt (höchster `42.x`-Versionsordner, sonst `common`, Namen ohne Groß-/Kleinschreibung,
  `PZ_GAMEBUILD` begrenzt den Ordner) und entscheidet pro Fix: Original unverändert → mitgelieferte Datei bleibt (`KEEP`);
  geändert und der Fehler ist noch drin → der Fix wird mit derselben Token-Änderung aus dem neuen Original neu geschrieben,
  BOM/CRLF bleiben, geprüft (Fehler-Tokens weg, nur die gewollten Zeilen, Klammern ausgeglichen) und nach `mkevserverbootpatch`
  geschrieben (`REBUILT`); Fehler weg → unser Override wird entfernt und protokolliert (`FIXED_UPSTREAM`); Mod lädt die Datei
  nicht mehr → Override entfernt (`NOT_LOADED`); Mod nicht gefunden → mitgelieferte Datei bleibt, mit Hinweis (`MISSING`);
  Prüfung fehlgeschlagen → WARNUNG, die vorher installierte Datei bleibt, nichts Kaputtes wird geschrieben, die Installation bricht
  nie ab (`FAIL`). Sicherung vor jedem Überschreiben (Wiederherstellen mit Modus 3), `MANIFEST.sha256` wird neu geschrieben.
  Bei einem Update dieser Mods ist keine neue BootPatch-Version nötig.
- `mkevserverbootpatch` 1.1.1: `versionMin=42.21`, kein `versionMax`; neu `README_DE.md`, `tools/bootfix.ps1` (gemeinsamer Kern),
  und die optionalen Admin-Werkzeuge `tools/check_upstream.ps1 -Fix` / `tools/check_upstream.sh --fix` (Linux: sh, awk, sha256sum) mit
  derselben Logik (keine Einrichtung nötig; ohne Schalter sind beide ein Probelauf).
- Doku: Der Collection-Titel heißt überall „MKev Zomboid Modlist B42.22“ (der alte Zusatz `(v1.0)` ist weg); Anzeigetitel „MKev's Modpatch Installer“ / „MKev's Modpatcher“.
- Installer-Version 1.1b → **1.2** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe-Dateien).

### Unverändert
- `mkev_modpatcher` 1.1b (`versionMin=42.20.0`), `MKevServer_setup` (376 Mods / 325 WorkshopItems inkl. I Know It! 3836594593 /
  `Map=Muldraugh, KY` / SandboxVars / Preset), beide Modi, Wiederherstellen, Probelauf, beide Sprachen.

### Update von v1.1b, v1.1 oder v1.0
- Den Installer v1.2 noch einmal ausführen (Option 1 oder 2), oder nur den Ordner `Zomboid\mods\mkevserverbootpatch` durch den aus dem Zip ersetzen.
- Server und alle Spieler brauchen dieselben BootPatch-Dateien (1.1.1). Auf einem Linux-Server den Ordner nach `Zomboid/mods/` des Servers kopieren
  und in `Mods=` eintragen - fertig. Kein Startskript muss geändert werden. `tools/check_upstream.sh` ist nur ein optionales Werkzeug für Admins, die es wollen.
- Prüfen: Im Server-Log steht `mod "mkevserverbootpatch" overrides media/scripts/recipes/recipes_fletching.txt` (und die zwei anderen Dateien),
  und es kommen keine `Unknown skill "Carpentry"`-, `Unknown skill "Electrical"`- oder `"//Royalty-free"`-Zeilen mehr.

## v1.1b - 10.11.2026

**Download:** [`Modpatch-Installer-v1.1b.zip`](../Patches/Patch-Installer/Modpatch-Installer-v1.1b.zip) (Archiv)  
**SHA256:** `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f`  
Enthaltener ModPatcher: `mkev_modpatcher` 1.1b (auch einzeln als `Modpatcher-v1.1b.zip`, SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).

### Geändert
- Enthaltener `mkev_modpatcher`: 1.1_vvr → **1.1b** (Hotfix Tweedjacke). Die VVR-Änderung aus 1.1_vvr bleibt drin. Die Mod-ID bleibt `mkev_modpatcher`.
- Installer-Version 1.1 → **1.1b** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe-Dateien). Sonst keine Codeänderung.

### ModPatcher 1.1b: Fix für die Tweedjacke
- Das Item: Die „Tweedjacke“ (EN „Suit Jacket - Tweed“) ist nicht Vanilla. Sie kommt aus **Spongie's Clothing** (WS 2684285534, Mod-ID `SpnCloth`):
  `Spongie.Jacket_Tweed` und `Spongie.Jacket_TweedOPEN`.
- Der Fehler: Beide Items haben eine BodyLocation, die es in B42.22 nicht gibt (`base:jacket_suit` statt `base:jacketsuit` und
  `base:JACKET_OPEN` statt `SpnOpenCloth:JACKET_OPEN`). Jedes Darüberfahren mit der Maus löste eine `NullPointerException` in
  `Clothing.DoTooltip(Clothing.java:233)` aus (578× in einer Sitzung am 10.11.2026, Fehlerzähler unten rechts).
  Die Tooltip-Mods im Stack (Starlit Library, KATTAJ1, Burd's Journals, Ente's Auto Sorter, I Know It!) reichen den Aufruf nur weiter.
- Der Fix: Die neue Datei `mkevmp_spongie_tweedfix.lua` setzt bei beiden Items die richtige BodyLocation (`Jacket_TweedOPEN` nur, wenn
  Spongie's Open Jackets [BASE] aktiv ist). Sie läuft nur, wenn Spongie's Clothing aktiv ist, und nur solange der Wert fehlt.
  Schon vorhandene Jacken werden mit korrigiert. Logzeile: `[MKev-ModPatcher] Spongie tweed fix: <item> BodyLocation -> <id>.`

### Unverändert
- `mkevserverbootpatch` 1.1.0, `MKevServer_setup` (376 Mods / 325 WorkshopItems / `Map=Muldraugh, KY` / SandboxVars / Preset), beide Modi, beide Sprachen.

### Update von v1.1 oder v1.0
- Den Installer v1.1b noch einmal ausführen (Option 1 oder 2), oder nur den Ordner `Zomboid\mods\mkev_modpatcher` durch den aus dem Zip ersetzen.
- Server und alle Spieler brauchen dieselbe ModPatcher-Version (1.1b).
- Prüfen: Im Log steht `[MKev-ModPatcher] version 1.1b loaded`. Beim Darüberfahren über die Tweedjacke kommen keine Fehler mehr.

## v1.1 - 10.11.2026

**Download:** `Modpatch-Installer-v1.1.zip`  
**SHA256:** `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c`  
Enthaltener ModPatcher: `mkev_modpatcher` 1.1_vvr (auch einzeln als `Modpatcher-v1.1_vvr.zip`, SHA256 `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a`).

### Geändert
- Enthaltener `mkev_modpatcher`: 0.1.11 → **1.1_vvr** (Hotfix VVR). Die Mod-ID bleibt `mkev_modpatcher`, `Mods=` ändert sich nicht.
- Installer-Version 1.0 → **1.1** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe-Dateien). Sonst keine Codeänderung.

### ModPatcher 1.1_vvr: was sich geändert hat
- Der VVR-Guard lässt VVR (KI5 Vanilla Vehicles Replacer) Vanilla-Fahrzeuge wieder ersetzen.
  Bisher (0.1.8 bis 0.1.11) hat der Guard VVR auf dem Dedicated Server für jedes schon existierende Fahrzeug übersprungen.
  Vanilla-Fahrzeuge, die VVR beim ersten Spawn verpasst hat, blieben Vanilla, zum Beispiel Step Vans und Vans.
- Verhalten jetzt (nur Dedicated Server, nur der VVR-Handler):
  - Neues Fahrzeug: VVR ersetzt wie bisher. Hat es noch kein Feld (VVR bricht dann ab), wird es vorgemerkt und nachgeprüft.
  - Existierendes Fahrzeug ohne Physik: VVR ersetzt direkt. Zustand, Rost, Blut und Teile bleiben erhalten.
  - Existierendes Vanilla-Fahrzeug mit Physik: Es wird entfernt und mit demselben Vanilla-Script auf demselben Feld neu gespawnt.
    VVR ersetzt das neue Fahrzeug dann selbst.
  - Besetzte, ziehende oder gezogene Fahrzeuge bleiben stehen. Gegenstände in einem neu gespawnten Vanilla-Fahrzeug gehen verloren.
  - Pro Fahrzeug eine Zeile im Server-Log: `VVR guard: replaced <script> -> <ziel> at x,y`, `FAILED ...` oder `kept ...`, höchstens 20 pro Minute.
- Hintergrund: Der Guard kam mit 0.1.8, weil VVRs Austausch beim Chunk-Laden auf dem Dedicated Server
  `UnsatisfiedLinkError: Bullet.removeVehicle`-Lua-Fehler auslöste (15× vom 27.10. bis 30.10.2026). Der Server ist nicht
  abgestürzt, aber der Austausch blieb halb stehen und die Clients bekamen Fehler-Spam beim Sitzabgleich.
  1.1_vvr ersetzt die Fahrzeuge ohne diesen Fehlerweg.

### Unverändert
- `mkevserverbootpatch` 1.1.0.
- `MKevServer_setup`: `Mods=` (376), `WorkshopItems=` (325, inkl. I Know It! 3836594593), `Map=Muldraugh, KY`,
  `MKevServer_SandboxVars.lua` (SHA256 86ce6f4f…f833), Preset `MKevServer`.
- Beide Modi (1 Installieren & einrichten, 2 Nur installieren), Wiederherstellen, Probelauf, beide Sprachen (EN/DE).
- Modus 1 ersetzt weiterhin nur `Mods=`, `WorkshopItems=` und `Map=`. Passwörter, Ports und Logins werden nie geändert.

### Update von v1.0
- Den Installer v1.1 noch einmal ausführen (Option 1 oder 2), oder nur den Ordner `Zomboid\mods\mkev_modpatcher` durch den aus dem Zip ersetzen.
- Server und alle Spieler brauchen dieselbe ModPatcher-Version (1.1_vvr).
- Prüfen: Im Server-Log stehen `[MKev-ModPatcher] version 1.1_vvr loaded` und Zeilen `VVR guard: replaced …`.

## v1.0 - 09.11.2026
Installer zum Collection-Release (Basis 0.3.0multi, EN/DE). Build 42.22.2, Collection 3827894199, 376 Mods / 325 WorkshopItems,
`mkev_modpatcher` 0.1.11, `mkevserverbootpatch` 1.1.0. SHA256 von `Modpatch-Installer-v1.0.zip`:
`12b5647a6a1744a0a5ac6507948356dfc3f0d7c09741c7d1c458b7b3f06b03b2`.
