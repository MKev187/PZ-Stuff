# Changelog: MKev's Modpatch Installer

Installer for the Workshop collection [MKev Zomboid Modlist B42.22 (v1.0)](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199) (ID 3827894199).
The package contains MKev's Modpatcher, the server kit, and MKev's Server BootPatch.
English and German installers (`ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`).

ModPatcher history, on its own: [MKev's Modpatcher](../ModPatcher/CHANGELOG.md).
BootPatch history, on its own: [MKev's Server BootPatch](../Server-BootPatch/CHANGELOG.md).

The current v1.1b package is in [`/Modpatch-Installer/`](../../Modpatch-Installer/README.md). This folder keeps a copy of that zip, plus the earlier packages named below.

## MKev's Modpatch Installer v1.1b — 2026-11-10

**Download:** [`Modpatch-Installer-v1.1b.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.1b.zip) in `/Modpatch-Installer/` (a copy with the same bytes is also in this folder)  
**SHA256:** `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f`  
Bundled ModPatcher: `mkev_modpatcher` 1.1b (also as `Modpatcher-v1.1b.zip` in [Patches/ModPatcher](../ModPatcher/), SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).

### Changed
- Bundled `mkev_modpatcher`: 1.1_vvr → **1.1b** (Hotfix Tweed jacket). The VVR change of 1.1_vvr is kept. Mod id stays `mkev_modpatcher`.
- Installer version 1.1 → **1.1b** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe files). No other code change.

### ModPatcher 1.1b: Tweed jacket fix
- The item: the "Tweedjacke" (EN "Suit Jacket - Tweed") is not vanilla. It comes from **Spongie's Clothing** (Workshop 2684285534, mod id `SpnCloth`): `Spongie.Jacket_Tweed` and `Spongie.Jacket_TweedOPEN`.
- The bug: both items have a BodyLocation that does not exist in B42.22 (`base:jacket_suit` instead of `base:jacketsuit`, and `base:JACKET_OPEN` instead of `SpnOpenCloth:JACKET_OPEN`). Every mouse hover over the jacket threw a `NullPointerException` at `Clothing.DoTooltip(Clothing.java:233)` (578× in one session on 2026-11-10, error counter bottom right). The tooltip mods in the stack (Starlit Library, KATTAJ1, Burd's Journals, Ente's Auto Sorter, I Know It!) only pass the call on.
- The fix: new file `mkevmp_spongie_tweedfix.lua` sets the correct BodyLocation on both items (`Jacket_TweedOPEN` only if Spongie's Open Jackets [BASE] is active). It only runs if Spongie's Clothing is active and only while the location is still missing. Jackets that already exist are fixed too. Log line: `[MKev-ModPatcher] Spongie tweed fix: <item> BodyLocation -> <id>.`

### Unchanged
- `mkevserverbootpatch` 1.1.0, `MKevServer_setup` (376 mods / 325 Workshop items / `Map=Muldraugh, KY` / SandboxVars / preset), both modes, both languages.

### Upgrade from v1.1 or v1.0
- Run the v1.1b installer again (option 1 or 2), or replace only the folder `Zomboid\mods\mkev_modpatcher` with the one from the zip.
- Server and all players need the same ModPatcher version (1.1b).
- Check: the log shows `[MKev-ModPatcher] version 1.1b loaded`. Hovering the Tweed jacket shows no more errors.

## MKev's Modpatch Installer v1.1 — 2026-11-10

**Download:** `Modpatch-Installer-v1.1.zip`  
**SHA256:** `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c`  
This zip is not stored in this repository. The hash is the one published with that version.  
Bundled ModPatcher: `mkev_modpatcher` 1.1_vvr (also published as `Modpatcher-v1.1_vvr.zip`, SHA256 `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a`; that standalone zip is not in this repository either).

### Changed
- Bundled `mkev_modpatcher`: 0.1.11 → **1.1_vvr** (Hotfix VVR). Mod id stays `mkev_modpatcher`, so `Mods=` does not change.
- Installer version 1.0 → **1.1** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe files). No other code change.

### ModPatcher 1.1_vvr: what changed
- The VVR guard now lets VVR (KI5 Vanilla Vehicles Replacer) replace vanilla vehicles again. Before (0.1.8 to 0.1.11), the guard skipped VVR on the dedicated server for every vehicle that already existed. Vanilla vehicles that VVR missed at their first spawn stayed vanilla, for example Step Vans and Vans.
- Behaviour now (dedicated server only, VVR handler only):
  - New vehicle: VVR replaces it as before. Without a square yet (VVR returns early), it is queued and checked again.
  - Existing vehicle without physics: VVR replaces it directly. Condition, rust, blood and parts are kept.
  - Existing vanilla vehicle with physics: it is removed and spawned again with the same vanilla script on the same square. VVR then replaces the new vehicle itself.
  - Occupied, towing or towed vehicles are kept. Items stored in a respawned vanilla vehicle are lost.
  - One server log line per vehicle: `VVR guard: replaced <script> -> <target> at x,y`, `FAILED ...` or `kept ...`, max 20 per minute.
- Background: the guard came in with 0.1.8 because VVR's swap on chunk load caused `UnsatisfiedLinkError: Bullet.removeVehicle` Lua errors on the dedicated server (15× from 2026-10-27 to 2026-10-30). The server did not crash, but the swap stopped half way and clients got seat-sync error spam. 1.1_vvr replaces the vehicles without that error path.

### Unchanged
- `mkevserverbootpatch` 1.1.0.
- `MKevServer_setup`: `Mods=` (376), `WorkshopItems=` (325, including I Know It! 3836594593), `Map=Muldraugh, KY`, `MKevServer_SandboxVars.lua` (SHA256 `86ce6f4f…f833`), preset `MKevServer`.
- Both modes (1 Install & set up, 2 Install only), restore, dry run, both languages (EN/DE).
- Mode 1 still replaces only `Mods=`, `WorkshopItems=` and `Map=`. Passwords, ports and logins are never changed.

### Upgrade from v1.0
- Run the v1.1 installer again (option 1 or 2), or replace only the folder `Zomboid\mods\mkev_modpatcher` with the one from the zip.
- Server and all players need the same ModPatcher version (1.1_vvr).
- Check: the server log shows `[MKev-ModPatcher] version 1.1_vvr loaded` and `VVR guard: replaced …` lines.

## MKev's Modpatch Installer v1.0 — 2026-11-09

**Download:** `Modpatch-Installer-v1.0.zip` (this folder)  
**SHA256:** `12b5647a6a1744a0a5ac6507948356dfc3f0d7c09741c7d1c458b7b3f06b03b2`

Installer for the collection release (base 0.3.0multi, EN/DE). Build 42.22.2, collection 3827894199, 376 mods / 325 Workshop items, `mkev_modpatcher` 0.1.11, `mkevserverbootpatch` 1.1.0.

`MKev-ModPatcher-v0.3.0.zip` (this folder, SHA256 `0b671a66e3aed9fd868eecb69533170b84268f098f9d8e27ec93b57fb517d50c`) is the older package that v1.0 was based on. Its `VERSION.txt` records ModPatcher 0.1.11, BootPatch 1.1.0, and a server kit of 381 mods / 329 Workshop items dated 2026-11-07. The published filename is unchanged.

---

## Deutsch

## MKev's Modpatch Installer v1.1b — 10.11.2026

**Download:** [`Modpatch-Installer-v1.1b.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.1b.zip) in `/Modpatch-Installer/` (eine Kopie mit denselben Bytes liegt auch in diesem Ordner)  
**SHA256:** `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f`  
Enthaltener ModPatcher: `mkev_modpatcher` 1.1b (auch einzeln als `Modpatcher-v1.1b.zip` in [Patches/ModPatcher](../ModPatcher/), SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).

### Geändert
- Enthaltener `mkev_modpatcher`: 1.1_vvr → **1.1b** (Hotfix Tweedjacke). Die VVR-Änderung aus 1.1_vvr bleibt drin. Die Mod-ID bleibt `mkev_modpatcher`.
- Installer-Version 1.1 → **1.1b** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe-Dateien). Sonst keine Codeänderung.

### ModPatcher 1.1b: Fix für die Tweedjacke
- Das Item: Die „Tweedjacke“ (EN „Suit Jacket - Tweed“) ist nicht Vanilla. Sie kommt aus **Spongie's Clothing** (Workshop 2684285534, Mod-ID `SpnCloth`): `Spongie.Jacket_Tweed` und `Spongie.Jacket_TweedOPEN`.
- Der Fehler: Beide Items haben eine BodyLocation, die es in B42.22 nicht gibt (`base:jacket_suit` statt `base:jacketsuit` und `base:JACKET_OPEN` statt `SpnOpenCloth:JACKET_OPEN`). Jedes Darüberfahren mit der Maus löste eine `NullPointerException` in `Clothing.DoTooltip(Clothing.java:233)` aus (578× in einer Sitzung am 10.11.2026, Fehlerzähler unten rechts). Die Tooltip-Mods im Stack (Starlit Library, KATTAJ1, Burd's Journals, Ente's Auto Sorter, I Know It!) reichen den Aufruf nur weiter.
- Der Fix: Die neue Datei `mkevmp_spongie_tweedfix.lua` setzt bei beiden Items die richtige BodyLocation (`Jacket_TweedOPEN` nur, wenn Spongie's Open Jackets [BASE] aktiv ist). Sie läuft nur, wenn Spongie's Clothing aktiv ist, und nur solange der Wert fehlt. Schon vorhandene Jacken werden mit korrigiert. Logzeile: `[MKev-ModPatcher] Spongie tweed fix: <item> BodyLocation -> <id>.`

### Unverändert
- `mkevserverbootpatch` 1.1.0, `MKevServer_setup` (376 Mods / 325 WorkshopItems / `Map=Muldraugh, KY` / SandboxVars / Preset), beide Modi, beide Sprachen.

### Update von v1.1 oder v1.0
- Den Installer v1.1b noch einmal ausführen (Option 1 oder 2), oder nur den Ordner `Zomboid\mods\mkev_modpatcher` durch den aus dem Zip ersetzen.
- Server und alle Spieler brauchen dieselbe ModPatcher-Version (1.1b).
- Prüfen: Im Log steht `[MKev-ModPatcher] version 1.1b loaded`. Beim Darüberfahren über die Tweedjacke kommen keine Fehler mehr.

## MKev's Modpatch Installer v1.1 — 10.11.2026

**Download:** `Modpatch-Installer-v1.1.zip`  
**SHA256:** `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c`  
Dieses Zip liegt nicht in diesem Repository. Der Hash ist der mit dieser Version veröffentlichte.  
Enthaltener ModPatcher: `mkev_modpatcher` 1.1_vvr (auch einzeln als `Modpatcher-v1.1_vvr.zip`, SHA256 `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a`; dieses Einzel-Zip liegt hier ebenfalls nicht).

### Geändert
- Enthaltener `mkev_modpatcher`: 0.1.11 → **1.1_vvr** (Hotfix VVR). Die Mod-ID bleibt `mkev_modpatcher`, `Mods=` ändert sich nicht.
- Installer-Version 1.0 → **1.1** (`ModPatchInstaller.bat`, `ModPatchInstaller_en.ps1`, `ModPatchInstaller_de.ps1`, `VERSION.txt`, ReadMe-Dateien). Sonst keine Codeänderung.

### ModPatcher 1.1_vvr: was sich geändert hat
- Der VVR-Guard lässt VVR (KI5 Vanilla Vehicles Replacer) Vanilla-Fahrzeuge wieder ersetzen. Bisher (0.1.8 bis 0.1.11) hat der Guard VVR auf dem Dedicated Server für jedes schon existierende Fahrzeug übersprungen. Vanilla-Fahrzeuge, die VVR beim ersten Spawn verpasst hat, blieben Vanilla, zum Beispiel Step Vans und Vans.
- Verhalten jetzt (nur Dedicated Server, nur der VVR-Handler):
  - Neues Fahrzeug: VVR ersetzt wie bisher. Hat es noch kein Feld (VVR bricht dann ab), wird es vorgemerkt und nachgeprüft.
  - Existierendes Fahrzeug ohne Physik: VVR ersetzt direkt. Zustand, Rost, Blut und Teile bleiben erhalten.
  - Existierendes Vanilla-Fahrzeug mit Physik: Es wird entfernt und mit demselben Vanilla-Script auf demselben Feld neu gespawnt. VVR ersetzt das neue Fahrzeug dann selbst.
  - Besetzte, ziehende oder gezogene Fahrzeuge bleiben stehen. Gegenstände in einem neu gespawnten Vanilla-Fahrzeug gehen verloren.
  - Pro Fahrzeug eine Zeile im Server-Log: `VVR guard: replaced <script> -> <ziel> at x,y`, `FAILED ...` oder `kept ...`, höchstens 20 pro Minute.
- Hintergrund: Der Guard kam mit 0.1.8, weil VVRs Austausch beim Chunk-Laden auf dem Dedicated Server `UnsatisfiedLinkError: Bullet.removeVehicle`-Lua-Fehler auslöste (15× vom 27.10. bis 30.10.2026). Der Server ist nicht abgestürzt, aber der Austausch blieb halb stehen und die Clients bekamen Fehler-Spam beim Sitzabgleich. 1.1_vvr ersetzt die Fahrzeuge ohne diesen Fehlerweg.

### Unverändert
- `mkevserverbootpatch` 1.1.0.
- `MKevServer_setup`: `Mods=` (376), `WorkshopItems=` (325, inkl. I Know It! 3836594593), `Map=Muldraugh, KY`, `MKevServer_SandboxVars.lua` (SHA256 `86ce6f4f…f833`), Preset `MKevServer`.
- Beide Modi (1 Installieren & einrichten, 2 Nur installieren), Wiederherstellen, Probelauf, beide Sprachen (EN/DE).
- Modus 1 ersetzt weiterhin nur `Mods=`, `WorkshopItems=` und `Map=`. Passwörter, Ports und Logins werden nie geändert.

### Update von v1.0
- Den Installer v1.1 noch einmal ausführen (Option 1 oder 2), oder nur den Ordner `Zomboid\mods\mkev_modpatcher` durch den aus dem Zip ersetzen.
- Server und alle Spieler brauchen dieselbe ModPatcher-Version (1.1_vvr).
- Prüfen: Im Server-Log stehen `[MKev-ModPatcher] version 1.1_vvr loaded` und Zeilen `VVR guard: replaced …`.

## MKev's Modpatch Installer v1.0 — 09.11.2026

**Download:** `Modpatch-Installer-v1.0.zip` (dieser Ordner)  
**SHA256:** `12b5647a6a1744a0a5ac6507948356dfc3f0d7c09741c7d1c458b7b3f06b03b2`

Installer zum Collection-Release (Basis 0.3.0multi, EN/DE). Build 42.22.2, Collection 3827894199, 376 Mods / 325 WorkshopItems, `mkev_modpatcher` 0.1.11, `mkevserverbootpatch` 1.1.0.

`MKev-ModPatcher-v0.3.0.zip` (dieser Ordner, SHA256 `0b671a66e3aed9fd868eecb69533170b84268f098f9d8e27ec93b57fb517d50c`) ist das ältere Paket, auf dem v1.0 aufbaut. Seine `VERSION.txt` nennt ModPatcher 0.1.11, BootPatch 1.1.0 und ein Server-Kit mit 381 Mods / 329 WorkshopItems, Stand 07.11.2026. Der Dateiname ist der ursprünglich veröffentlichte.
