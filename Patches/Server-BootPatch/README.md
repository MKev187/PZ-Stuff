# MKev's Server BootPatch

Small local mod that fixes script bugs other mods leave in the dedicated-server boot log.
Mod id `mkevserverbootpatch`, current version **1.1.2**.

It is separate from [MKev's Modpatcher](../ModPatcher/README.md). Load it at the very end of `Mods=`, after `mkev_modpatcher`. The server and every client need the same version, because script checksums have to match.

**Download:** [`Server-BootPatch-v1.1.2.zip`](Server-BootPatch-v1.1.2.zip) (SHA256 `6bf15134a416a64edcfb068316ba5fdf1dc7717ad4fa4ca1b6a22f3524c38ab8`, also in [`SHA256SUMS.txt`](SHA256SUMS.txt)).
The same mod is included in [MKev's Modpatch Installer v1.32](../../Modpatch-Installer/README.md) (unchanged since v1.3). 1.1.2 changes only version and docs; the fixes and the self-healing are the same as in 1.1.1.

Author: **MKev**.

Workshop originals are never edited. The fixes are this mod's own copies of the three files, loaded after the original mods. When one of those mods updates, the installer rewrites the fix from the new original, so no new BootPatch version is needed. Server admins need no extra step: folder into `mods`, add to `Mods=`, done.

---

## What it fixes

| # | Mod (Workshop) | Fix | File in this mod |
|---|---|---|---|
| F1 | Archery Nexus [Fixed] (3731579266) | Recipe skill `Carpentry:3` → `Woodwork:3` | `42/media/scripts/recipes/recipes_fletching.txt` |
| F2 | Mad Crafter (3418701509, folder 42.15) | `Electrical:` → `Electricity:` (6× in 2 recipes) | `42/media/scripts/recipes/recipes_MCR_1Handed.txt` |
| F3 | Zombie Virus Vaccine (3615135168, folder 42.20) | A `//` comment becomes `/* */`, so sound `Injection_A` is registered | `42/media/scripts/sounds/LabSounds.txt` |
| F5/F6 | this mod | Empty `AnimSets` and `actiongroups` folders | placeholders |

F4 was a require-path shim for Sentry Turret Upgrade (Workshop 3633082678, id `SentryTurret042`). It was removed in 1.1.0 because that mod is not in the pack.

Since **1.1.1** F1–F3 are fixed parts of the mod again. In 1.1.0 the Windows installer built them at install time; on a Linux dedicated server that installer never runs, so the mod only had its placeholders and all F1–F3 boot messages stayed (seen on 2026-11-10). 1.1.1 works on any server and client by copying the folder.

The files override the originals by their relative path (`media/scripts/...`). The game matches that path in lowercase, so the file names keep the spelling of the originals and still work on Linux.

### F1 — Archery Nexus [Fixed]

`recipes_fletching.txt`, recipe "Assemble A Primitive Hunting Bow", uses the perk id `Carpentry:3`. That id is not a Build 42 perk. The Build 42 id is `Woodwork:3`.
Source: `3731579266/mods/ArcheryNexusFixed/common/media/scripts/recipes/recipes_fletching.txt`, one occurrence of `Carving:5;Carpentry:3` → `Carving:5;Woodwork:3`.
Boot log without the fix: `Unknown skill "Carpentry" in recipe "Assemble A Primitive Hunting Bow"`.

### F2 — Mad Crafter

`recipes_MCR_1Handed.txt` (folders 42.12 and 42.15) uses `Electrical:` in `SkillRequired`, `AutoLearnAny`, and `xpAward`. The perk id is `Electricity:`. The category name `Electrical` stays.
Source: `3418701509/mods/MadCrafter/42.15/media/scripts/recipes/recipes_MCR_1Handed.txt`, exactly 6 places. Requirement, autolearn, and XP work again.
Boot log without the fix: 6× `Unknown skill "Electrical"` (MakeElectricMosquitoSwatter, MakeElectricMachete).

### F3 — Zombie Virus Vaccine

`LabSounds.txt` (folders 42.14 and 42.20) line 106 is a `//` comment. The Build 42 script parser only strips `/* */` comments, so sound `Injection_A` was never registered.
Source: `3615135168/mods/ZVirusVaccine42BETA/42.20/media/scripts/sounds/LabSounds.txt`, `//Royalty-free injection sound from pixabay` → `/* Royalty-free injection sound from pixabay */`.
Boot log without the fix: `unknown script object "//Royalty-free" in 'media/scripts/sounds/labsounds.txt'`.

### F5 / F6 — empty animation folders

Build 42's `AdvancedAnimator` scans `media/AnimSets` and `media/actiongroups` in both the `common` folder and the version folder of every mod. A missing folder becomes a `NoSuchFileException` in the boot log. The game still boots.

| Fix | Folder | Since |
|---|---|---|
| F5 | `42/media/actiongroups/` | 1.0.1 |
| F6 | `42/media/AnimSets/`, `common/media/AnimSets/`, `common/media/actiongroups/` | 1.0.2 |

Each folder contains only `readme_placeholder.txt`. The scanner checksums files whose names end in `.xml`, so the text file is ignored. `common/readme.txt` is a one-line placeholder because Build 42 expects a `common` folder.

---

## Checksums of the fixed files

Each bundled file is the original with only the listed text changed:

| Fix | SHA256 of the Workshop original it was made from | SHA256 of the bundled file |
|---|---|---|
| F1 | `68B87D921EAEB41D2799919BDB75446FB9EBCFAD98376174A7D89FAEF0096678` | `05A17570A07265A578E893CB6E0CF70A5DF61EF9ECC0304C791B0F24A7FFB251` |
| F2 | `7B4591967E8FC50B337E6C210D2BC0C28B9CC5ECBC565CE41DE2567FD437CFEF` | `2D8F91B399309286738C33745A4960B5F0A851DF134C1704FFC5875E667E1209` |
| F3 | `85F28B209C94105F597900691C92E8E52D277871175E9B36241C974309F18FCD` | `5B674938425FB04DFC6FA85419D2678C57778B32F4ED4FE6EC63F1B02DDBF1FE` |

The bundled files have the same bytes as the files installer 1.1b built for 1.1.0 and as the 1.0.2 overrides.

## When the original mods update (self-healing)

The bundled files are the defaults. [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) v1.2 and later (at every install), and the optional admin tools `tools/check_upstream.ps1 -Fix` (Windows) / `sh tools/check_upstream.sh --fix` (Linux, needs only `sh`, `awk`, `sha256sum`; nothing to set up) share one logic (core: `tools/bootfix.ps1`, mirrored in the shell script). Per fix they find the file the game really loads: the highest `42.x` version folder of the mod (capped by `PZ_GAMEBUILD`, for example `42.22`), else `common`, with folder and file names compared case-insensitively. Then:

| Case | Status | What happens |
|---|---|---|
| Original unchanged (SHA256 in the table above) | `KEEP` | bundled file stays |
| Original changed, the error is still in it | `REBUILT` | the fix is rewritten from the new original with the same token edit: F1 `Carpentry:` → `Woodwork:` and F2 `Electrical:` → `Electricity:` only in `SkillRequired` / `AutoLearnAll` / `AutoLearnAny` / `xpAward` lines, F3 top-level `//` lines → `/* */`. BOM and CRLF/LF are kept. It is written only if the checks pass: error tokens gone, only the intended lines changed, braces balanced. |
| Original changed, the error is gone | `FIXED_UPSTREAM` | the author fixed it: our override is removed and the original is used |
| Mod found, but it no longer loads this file | `NOT_LOADED` | our override is removed |
| Mod not in the Workshop folders | `MISSING` | bundled file stays, note only |
| Rewritten file fails a check | `FAIL` | warning; the file installed before stays, nothing broken is written, the install never aborts |

After a change `MANIFEST.sha256` is rewritten. The installer backs up every file before it overwrites it (restore with menu 3).
Without `-Fix` / `--fix` both tools are a dry run and write nothing. Workshop folders: `-Workshop` / arguments, else `PZ_WORKSHOP`, else the usual Steam paths. Exit code: `0` nothing to do or done, `2` dry run found changes, `3` at least one `FAIL`.
Server and clients need the same `mkevserverbootpatch` files (script checksums). With the same Workshop versions the installer on each client produces the same result; if an admin changed a fix with the optional tool, copy the folder to the clients.

The three upstream problems, and a short list of other boot-log notes this mod does not patch, are in `UPSTREAM.md` inside the mod folder (S1–S3 are F1–F3; S4 is the removed Sentry shim).

---

## Install

- **Windows (player or server):** use [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) v1.32 (option 1 or 2), or extract `Server-BootPatch-v1.1.2.zip` into `%USERPROFILE%\Zomboid\mods\`.
- **Linux dedicated server:** extract `Server-BootPatch-v1.1.2.zip` into the server's `Zomboid/mods/` folder (the folder that contains `Server/` and `Saves/`, giving `Zomboid/mods/mkevserverbootpatch/`) and keep `mkevserverbootpatch` last in `Mods=`. That's all - no start script or other server file has to be changed. `tools/check_upstream.sh` is only an optional tool for admins who want to check the fixes by hand. Case problems of *other* mods on Linux (files not found because of upper/lower case) are not part of this mod; for them the installer zip brings the optional [MKev's Linux-Guard](../Linux-Guard/README.md).
- Check after the next start: the log shows `mod "mkevserverbootpatch" overrides media/scripts/recipes/recipes_fletching.txt` (and the two other files), and the F1–F3 messages above are gone.

History of this mod: [`CHANGELOG.md`](CHANGELOG.md).
