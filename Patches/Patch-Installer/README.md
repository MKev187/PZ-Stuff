# MKev's Modpatch Installer

This folder is the archive of previous installer packages, not the current release.
Download the current build from [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) ([`/Modpatch-Installer/Modpatch-Installer-v1.1b.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.1b.zip)).

One download that sets up a dedicated server and the clients for a 376-mod Project Zomboid Build 42 multiplayer list.
Every fix is matched to a specific error from a real server log, and every one is a runtime patch or a file built into the patch mods' own folders.
Workshop originals are never edited.

The current installer is the all-in-one package. It includes:

- **MKev's Modpatcher** (`mkev_modpatcher` 1.1b), the core runtime compatibility patch
- the **server kit** (`MKevServer_setup`: mod list, load order, map, sandbox settings, and the in-game preset)
- **MKev's Server BootPatch** (`mkevserverbootpatch` 1.1.0)

The installer is in English and German. `ModPatchInstaller.bat` asks which language to use.

- **Game:** Project Zomboid Build **42.22.2**, multiplayer (dedicated server and clients)
- **Collection:** [MKev Zomboid Modlist B42.22 (v1.0), Workshop 3827894199](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199)
- **Current release:** [`Modpatch-Installer-v1.1b.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.1b.zip) in [`/Modpatch-Installer/`](../../Modpatch-Installer/README.md). This folder still has a copy of that zip, plus the older packages below.

Deeper docs, kept next to this folder:

- [MKev's Modpatcher](../ModPatcher/README.md) — what the core patch does, including the VVR spawn guard and the Tweed jacket fix
- [MKev's Server BootPatch](../Server-BootPatch/README.md) — the boot-log fixes and how F1–F3 are built from your Workshop files

Author: **MKev**.

---

## Downloads

Current release, in [`/Modpatch-Installer/`](../../Modpatch-Installer/README.md):

| File | Version | SHA256 |
|---|---|---|
| **[`Modpatch-Installer-v1.1b.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.1b.zip)** | Installer 1.1b + ModPatcher 1.1b + BootPatch 1.1.0 | `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f` |

Files still in this folder:

| File | Version | SHA256 |
|---|---|---|
| `Modpatch-Installer-v1.1b.zip` | Same bytes as `/Modpatch-Installer/Modpatch-Installer-v1.1b.zip` | `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f` |
| `Modpatch-Installer-v1.0.zip` | Installer 1.0 (ModPatcher 0.1.11 + BootPatch 1.1.0) | `12b5647a6a1744a0a5ac6507948356dfc3f0d7c09741c7d1c458b7b3f06b03b2` |
| `MKev-ModPatcher-v0.3.0.zip` | Older package for Build 42.21 (reference only). The filename is the one that package was published under. | `0b671a66e3aed9fd868eecb69533170b84268f098f9d8e27ec93b57fb517d50c` |

All hashes for the zips in this folder are also in [`SHA256SUMS.txt`](SHA256SUMS.txt). What changed in each installer version: [`CHANGELOG.md`](CHANGELOG.md).

Standalone ModPatcher, current build only: [`Modpatcher-v1.1b.zip`](../ModPatcher/Modpatcher-v1.1b.zip) in [Patches/ModPatcher](../ModPatcher/README.md) (SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).

These two archives are described in the changelog and are not stored in this repository:

| File | Version | SHA256 |
|---|---|---|
| `Modpatch-Installer-v1.1.zip` | Installer 1.1 (ModPatcher 1.1_vvr + BootPatch 1.1.0) | `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c` |
| `Modpatcher-v1.1_vvr.zip` | ModPatcher 1.1_vvr only | `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a` |

There is no standalone Server BootPatch zip, and no standalone ModPatcher zip for 1.0 or 0.1.11.

---

## Quick start (Windows)

1. Subscribe to the [Workshop collection](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199).
2. Close Project Zomboid **and** your PZ server. The installer refuses to run while either one is running.
3. Extract the whole zip and double-click **`ModPatchInstaller.bat`**.
4. Pick a language: `1` English or `2` Deutsch.
5. Pick a mode:

| Option | What it does |
|---|---|
| **1** Install & set up | Installs both patch mods **and** adapts your existing server files. It shows every change first and asks `Y/N`. |
| **2** Install only | Installs both patch mods and puts ready-made templates into `Zomboid\MKevServer_setup\`. No settings are changed. |
| **3** Restore backup | Puts back the state from before a run. |
| **4** Quit | |
| **5** Dry run | Shows what option 1 would change. Writes nothing. |

The server and every player need the **same ModPatcher version**. They also need the same Server BootPatch version, because script checksums have to match.

---

## The installer

Two scripts with the same logic: `ModPatchInstaller_en.ps1` and `ModPatchInstaller_de.ps1`. The `.bat` asks for the language. You can skip the question with `PZ_LANG=en` or `PZ_LANG=de`, or start either script directly. `Y` and `N` answer the questions. `J` is also accepted as yes.

**What option 1 changes**

- Copies `mkev_modpatcher` and `mkevserverbootpatch` to `Zomboid\mods`. After copying, it checks that the copy is identical to the package. The BootPatch copy is the staging copy, with F1–F3 built in. See [MKev's Server BootPatch](../Server-BootPatch/README.md).
- `Zomboid\Server\servertest.ini`: replaces **only** the lines `Mods=`, `WorkshopItems=` and `Map=`. Before replacing, it shows how many entries are added and removed.
- Replaces `servertest_SandboxVars.lua` with the MKev server sandbox. The old file goes into the backup.
- Adds the mod preset `MKevServer` to `Zomboid\Lua\pz_modlist_settings.cfg`. Your own presets stay.
- Adds `mkev_modpatcher` to `Zomboid\mods\default.txt`.

**What it never touches**

- Passwords, ports, the server name, and every other line of `servertest.ini`. The encoding and line endings (BOM, CRLF/LF) are kept too.
- Workshop folders. A hard safety stop blocks any write under `steamapps\workshop`, and any write outside the `Zomboid` folder.

**Safety features**

- **Process check:** aborts if `ProjectZomboid64` / `ProjectZomboid32`, `ProjectZomboidServer`, or a PZ Java server is running.
- **Backups:** everything it changes is copied to `Zomboid\mkev_patch_backups\<date_time>\` first. Option 3 restores it. Files the installer created are removed again on restore.
- **Idempotent:** a second run changes nothing; each step reports that it is already up to date.
- **Log:** each run is written to `installer_log.txt` in the backup folder.
- **No secrets shipped:** the package contains no `servertest.ini`, only the three list values (`Mods=`, `WorkshopItems=`, `Map=`) as separate text files.
- **Steam libraries:** finds Workshop folders through `libraryfolders.vdf`. `PZ_WORKSHOP` overrides this, pointing at `...\steamapps\workshop\content\108600`.

`VERSION.txt` in the current zip records installer 1.1b, ModPatcher 1.1b, BootPatch 1.1.0, and the server kit below.

---

## The core: MKev's Modpatcher (`mkev_modpatcher` 1.1b)

A local mod that loads **last** and fixes other mods while the game runs, without editing their files.

Each module follows the same rules:

- It only runs if its target mod is active. On the wrong side (client, server, or single player) it does nothing.
- It only fills gaps or skips one broken call. It does not replace another mod's working code.
- Errors are caught (`pcall`). Logging is rate-limited, with clear `[MKev-ModPatcher]` lines.

Check in the log: `[MKev-ModPatcher] version 1.1b loaded`.

The full write-up of the VVR spawn guard and the Tweed jacket fix is in [MKev's Modpatcher](../ModPatcher/README.md). Short form: the VVR guard (since 1.1_vvr, kept in 1.1b) lets Vanilla Vehicles Replacer replace vanilla vehicles on a dedicated server without calling `Bullet.removeVehicle`. The 1.1b hotfix gives Spongie's two Tweed jackets a BodyLocation that exists in B42.22.

### Lua modules (16)

| File | Side | Target | What it does |
|---|---|---|---|
| `mkevmp_vvrspawnguard.lua` | dedicated server | Vanilla Vehicles Replacer (KI5) | **The VVR guard.** See [What is the guard?](#faq) and the [ModPatcher page](../ModPatcher/README.md#the-vvr-spawn-guard). |
| `mkevmp_spongie_tweedfix.lua` | server + client | Spongie's Clothing (+ Open Jackets BASE) | Gives the two Tweed jackets a valid BodyLocation (`base:jacketsuit`, `SpnOpenCloth:JACKET_OPEN`). Hovering them threw a NullPointerException in `Clothing.DoTooltip:233`, **578×** in one session. |
| `mkevmp_fillcontainerguard.lua` | server + client | vanilla 42.21 bug (seen with Computer Mod New Music, Low Condition Guns) | The game sometimes passes a loot table instead of the bag to `OnFillContainer`. That one bad call is skipped for handlers registered after it; real containers pass through. |
| `mkevmp_oncreatealias.lua` | server + client | Realistic Army Zombies, Extra Bombs 2 | Points the old pre-42.20 `SpecialLootSpawns.OnCreate*` names to the vanilla functions. Gas masks get their filter again, the magazine its title. |
| `mkevmp_purserverguard.lua` | dedicated server | Plysken Underground Revolution | Provides the `PUR` table that only PUR's client files create, so its server file loads without an error on every start. |
| `mkevmp_jp82guard.lua` | server + client | '82 Jeep J10 | Fills missing `JP82.*SpareTire` functions with vanilla defaults. It never overwrites existing ones. |
| `mkevmp_sodacanalias.lua` | server + client | FunctionalAppliances2 / Authentic Z | Old soda `OnCreate` name. Does nothing unless one of them is active. |
| `mkevmp_zedmonitor.lua` | server + MP client | debug tool | **Zombie spawn monitor:** logs where new zombies come from (Lua spawn calls, room spawns, cell loads, reanimation) and counts zombies within 30/80 tiles of each player. Writes to `Zomboid/Lua/mkev_zedmonitor_*.log` (2 MB cap), times in German local time. Sandbox option `MKevMP.ZedMonitor`. |
| `mkevmp_00_config.lua` | both | — | Settings, log helper, `isModActive`, warning if the old `MKevPackPatches` is active too. |
| `mkevmp_version.lua` | both | — | The version line in the log. |
| `mkevmp_alifewindowhands.lua` | MP client | Project A-Life NPCs | Empties an armed A-Life NPC's hands (through A-Life's own `TraversalHands`) just before the engine makes it climb a window. Stops the `ClassCastException IsoZombie -> IsoPlayer` error popups. Logs `prevented / refused / missed / errors`. |
| `mkevmp_insertmagguard.lua` | MP client | vanilla `ISInsertMagazine` | Keeps the magazine reference when the client lookup fails during sync. Before: `setJobDelta` on nil, once per frame (10 errors in one reload). |
| `mkevmp_neatlockshovequiet.lua` | client | NeatLockpicking | Drops a no-op `setVariable("bDoShove")` call that flooded the log (**2711 lines in 21 s**). Behaviour is unchanged. |
| `mkevmp_primitivebow_anm.lua` | client | Archery Nexus [Fixed] + [RadBows] | The Primitive Bow shows its drawn model again while an arrow is nocked. |
| `mkevmp_postdeathguard.lua` | MP client | vanilla death screen | Keeps the death screen on top and logs what blocks its buttons (`[MKev-PDG]`). After 10 s it shows a fallback window with *New character* / *Quit*, which calls the vanilla handlers. |
| `mkevmp_connectnotice.lua` | MP client | — | Shows a short DE/EN loading notice with OK, once before connecting or once in game ("wait, don't click while it loads"). Never shown in single player or to a coop host. |

### Data patches

| File(s) | Target | Fix |
|---|---|---|
| `scripts/vehicles/mkevmp_template_*.txt` (4) | KI5 vehicles (93mustangSSP, 87chevySuburban, 82jeepJ10, 86oshkoshP19A, 67commando, …) | Restores KI5 gunrack templates and the JP82 spare-tire template, plus empty stubs for stale template names. No more `template not found`. |
| `scripts/mkevmp_brita_nv_legacy.txt` | Brita's Armor Pack | 6 legacy night-vision names as full items. Stops 6× "client has no script for dictionary info" on every join. |
| `clothing/clothingItems/*.xml` (3) | Realistic Army Zombies | Stand-ins for 3 clothing files its outfits use but the mod doesn't ship. |
| `Translate/EN/Sandbox.json` | TrueSmoking | Fixed `%` signs in sandbox tooltips. |

Every module lists its root cause in its file header and in `UPSTREAM.md` inside the mod folder (also `CHANGELOG.md`, `AUDIT.md`). Each workaround is meant to be removed once the original mod is fixed.

---

## MKev's Server BootPatch (`mkevserverbootpatch` 1.1.0)

A small second mod that loads at the very end, after ModPatcher. It fixes script bugs that show up in the boot log. Full notes: [MKev's Server BootPatch](../Server-BootPatch/README.md).

| # | Mod (Workshop) | Fix |
|---|---|---|
| F1 | Archery Nexus [Fixed] (3731579266) | Recipe skill `Carpentry:3` → `Woodwork:3` |
| F2 | Mad Crafter (3418701509) | `Electrical:` → `Electricity:` (6× in 2 recipes), so requirement, autolearn and XP work again |
| F3 | Zombie Virus Vaccine (3615135168) | A `//` comment had disabled the `Injection_A` sound. It becomes a `/* */` comment. |
| F5/F6 | itself | Empty `AnimSets` / `actiongroups` folders, so the boot log loses its `NoSuchFileException` lines |

F1–F3 are not shipped as copies of the original files. Those files belong to their authors. At install time the installer:

1. reads your own installed Workshop file (read-only);
2. checks its SHA256 is exactly the version the fix was made for;
3. changes only the listed text and checks the result's SHA256.

If a mod was updated, or a newer version folder appears next to it, that one fix is skipped and reported as `NOT built`. Everything else still installs. `tools\check_upstream.ps1` inside the BootPatch folder reports drift when an original file changed.

---

## Server setup (`MKevServer_setup`)

| | |
|---|---|
| Build | 42.22.2 |
| Mods | **376** (`Mods=`, MKev server state of 2026-11-09, both patch mods last) |
| Workshop items | **325**, collection 3827894199 (I Know It! 3836594593 comes from the Workshop like every other mod) |
| Map | `Muldraugh, KY` |
| Sandbox | full `servertest_SandboxVars.lua` of the MKev server (water shutoff modifier 3, power shutoff modifier 22, plus the I Know It! and M-13 Reading Tweaks options) |
| Preset | `MKevServer` for the in-game mod manager |

Option 2 puts all of these as ready-made files into `Zomboid\MKevServer_setup\`, with a README, if you want to set things up by hand. I Know It! is part of the list and is not shipped in the zip.

The older `MKev-ModPatcher-v0.3.0.zip` in this folder is a different server snapshot: ModPatcher 0.1.11, BootPatch 1.1.0, 381 mods / 329 Workshop items, map `Muldraugh, KY`, dated 2026-11-07 in that package's `VERSION.txt`. It is kept for reference. The current list is the table above.

---

## FAQ

**What is the guard?**
The **VVR guard** (`mkevmp_vvrspawnguard.lua`) is a wrapper around the spawn handler of *Vanilla Vehicles Replacer (KI5)* on dedicated servers.

- **The problem:** VVR swaps a vanilla car that already has physics with `scriptReloaded`. On a dedicated server that ends in `Bullet.removeVehicle`, a native physics call the server doesn't have, so it throws `java.lang.UnsatisfiedLinkError` (**15×** in the server logs). The follow-up was vehicle packet errors on the clients: `BufferUnderflowException` in `VehiclePassengers` (**1239×** in one session on 30 Oct 2026).
- **What 1.1b does** (the 1.1_vvr behaviour, kept as-is):
  - New cars are replaced by VVR as usual.
  - Existing cars without physics are replaced by VVR directly.
  - Existing vanilla cars *with* physics are removed and respawned on the same square, so VVR swaps the fresh one.
  - Cars with someone inside, towing, or being towed are kept and retried on the next chunk load.
  - One log line per replaced, failed, or kept car (script, target, x, y), max 20 lines per 60 s.

  Result: vanilla vehicles do not slip through, and the crash path is not used.
- The other modules are guards in the same style: small, targeted, and only active when needed.

The step-by-step behaviour is on the [ModPatcher page](../ModPatcher/README.md#the-vvr-spawn-guard).

**Does it edit Workshop mods?**
No. Everything is a runtime patch or an extra file in its own mod folder. The installer has a hard stop against writing into `steamapps\workshop`. BootPatch fixes are built from your copy into the BootPatch folder; your originals stay untouched.

**Do clients need it?**
Yes. The server and every player need the same `mkev_modpatcher` and `mkevserverbootpatch` version, because script checksums must match. Players can use option 2, or copy the two folders into `Zomboid\mods`.

**Is it safe for my server password?**
Yes. Option 1 replaces only `Mods=`, `WorkshopItems=` and `Map=` in `servertest.ini`. Passwords, ports, server name, and all other lines stay byte-for-byte. Everything is backed up first, and option 5 shows the changes without writing anything. The package itself contains no credentials.

**How do I verify my download?**
Compare the SHA256 of the current zip with [`SHA256SUMS.txt`](../../Modpatch-Installer/SHA256SUMS.txt) in `/Modpatch-Installer/`. In PowerShell: `Get-FileHash .\Modpatch-Installer-v1.1b.zip`. Hashes for the copies kept in this folder are in [`SHA256SUMS.txt`](SHA256SUMS.txt).

**I updated from v1.1 or v1.0. What do I do?**
Run the v1.1b installer again, or replace `Zomboid\mods\mkev_modpatcher` with the folder from the zip. Do it on the server and on every client.

**Where do I report bugs?**
Open an issue in this repository (MKev187/PZ-Stuff). Please include your `console.txt` or the `Zomboid\Logs\*DebugLog*.txt` lines around the error, plus the installer's `installer_log.txt`.

---

## Credits

Made by **MKev**.

All mods in the [collection](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199) belong to their authors and keep full credit. Please support them on the Workshop. This package ships none of their files. It only patches at runtime, or builds fixes from your own installed copy. Root causes are documented so they can be reported to the authors.
