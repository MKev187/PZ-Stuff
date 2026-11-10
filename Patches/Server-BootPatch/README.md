# MKev's Server BootPatch

Small local mod that fixes script bugs other mods leave in the dedicated-server boot log.
Mod id `mkevserverbootpatch`, current version **1.1.0**.

It is separate from [MKev's Modpatcher](../ModPatcher/README.md). Load it at the very end of `Mods=`, after `mkev_modpatcher`. The server and every client need the same version, because script checksums have to match.

There is no standalone BootPatch zip. Version 1.1.0 is included in [MKev's Modpatch Installer](../../Modpatch-Installer/README.md). The installer builds fixes F1–F3 on the machine where it runs. This folder documents that mod. It does not ship third-party files.

Author: **MKev**.

Workshop originals are never edited. The installer only reads the Workshop copy. The built files are written into this mod's own folder under `Zomboid\mods`.

---

## What it fixes

| # | Mod (Workshop) | Fix | How 1.1.0 delivers it |
|---|---|---|---|
| F1 | Archery Nexus [Fixed] (3731579266) | Recipe skill `Carpentry:3` → `Woodwork:3` | Built at install time from your `recipes_fletching.txt` |
| F2 | Mad Crafter (3418701509, folder 42.15) | `Electrical:` → `Electricity:` (6× in 2 recipes) | Built from your `recipes_MCR_1Handed.txt` |
| F3 | Zombie Virus Vaccine (3615135168, folder 42.20) | A `//` comment becomes `/* */`, so sound `Injection_A` is registered | Built from your `LabSounds.txt` |
| F5/F6 | this mod | Empty `AnimSets` and `actiongroups` folders | Shipped (this mod's own files) |

F4 was a require-path shim for Sentry Turret Upgrade (Workshop 3633082678, id `SentryTurret042`). It was removed in 1.1.0 because that mod is not in the pack (list of 2026-11-06: 381 mods / 328 Workshop items).

### F1 — Archery Nexus [Fixed]

`recipes_fletching.txt`, recipe "Assemble A Primitive Hunting Bow", uses the perk id `Carpentry:3`. That id is not a Build 42 perk. The Build 42 id is `Woodwork:3`.

The installer reads:

`3731579266\mods\ArcheryNexusFixed\common\media\scripts\recipes\recipes_fletching.txt`

It replaces the one occurrence of `Carving:5;Carpentry:3` with `Carving:5;Woodwork:3`, and writes the result to `42\media\scripts\recipes\recipes_fletching.txt` inside this mod.

### F2 — Mad Crafter

`recipes_MCR_1Handed.txt` (folders 42.12 and 42.15) uses `Electrical:` in `SkillRequired`, `AutoLearnAny`, and `xpAward`. The perk id is `Electricity:`. The category name `Electrical` stays.

The installer reads the 42.15 file:

`3418701509\mods\MadCrafter\42.15\media\scripts\recipes\recipes_MCR_1Handed.txt`

It replaces `Electrical:` with `Electricity:` in exactly 6 places, and writes `42\media\scripts\recipes\recipes_MCR_1Handed.txt` inside this mod. Requirement, autolearn, and XP work again.

### F3 — Zombie Virus Vaccine

`LabSounds.txt` (folders 42.14 and 42.20) line 106 is a `//` comment. The Build 42 script parser only strips `/* */` comments, so sound `Injection_A` was never registered.

The installer reads:

`3615135168\mods\ZVirusVaccine42BETA\42.20\media\scripts\sounds\LabSounds.txt`

It replaces `//Royalty-free injection sound from pixabay` with `/* Royalty-free injection sound from pixabay */` (one occurrence) and writes `42\media\scripts\sounds\LabSounds.txt` inside this mod.

### F5 / F6 — empty animation folders

Build 42's `AdvancedAnimator` scans `media/AnimSets` and `media/actiongroups` in both the `common` folder and the version folder of every mod. A missing folder becomes a `NoSuchFileException` in the boot log. The game still boots.

| Fix | Folder | Since |
|---|---|---|
| F5 | `42/media/actiongroups/` | 1.0.1 |
| F6 | `42/media/AnimSets/`, `common/media/AnimSets/`, `common/media/actiongroups/` | 1.0.2 |

Each folder contains only `readme_placeholder.txt`. The scanner checksums files whose names end in `.xml`, so the text file is ignored. `anims_X` is not scanned and has no placeholder. These folders are this mod's own files. They are shipped in the installer zip.

`common/readme.txt` is a one-line placeholder because Build 42 expects a `common` folder. It is not one of the script fixes.

---

## How 1.1.0 builds F1–F3

From 1.1.0 onward the package does not contain copies of the three upstream files. Those files belong to their authors. [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) builds them when it installs this mod (the same bytes as the old 1.0.2 overrides):

1. It finds your Steam Workshop folder for Project Zomboid (`steamapps\workshop\content\108600`) through `libraryfolders.vdf`. `PZ_WORKSHOP` overrides that search (a `;` list is accepted).
2. It reads your installed file. The Workshop folder is only read.
3. It checks the file's SHA256 against the exact version the fix was written for.
4. For F2 and F3 it also looks for a newer numbered version folder next to the pinned folder (`42.15` for Mad Crafter, `42.20` for Zombie Virus Vaccine). Build 42 loads the highest folder that is still at or below the game version, so a newer folder would hide the patched file. F1 has no version-folder pin; it uses the `common` file and the hash check only.
5. It changes only the text listed above, and only if that text occurs the expected number of times.
6. It checks the SHA256 of the result. The bytes are then written into a staging copy of `mkevserverbootpatch`, and that copy is what gets installed under `Zomboid\mods`.

If the file is missing, the hash does not match, a newer version folder is present (F2/F3), the text is not where it should be, or the result hash does not match, that one fix is reported as `NOT built` with the reason. The other fixes still install.

| Fix | Expected SHA256 of your Workshop file | Expected SHA256 of the built file |
|---|---|---|
| F1 | `68B87D921EAEB41D2799919BDB75446FB9EBCFAD98376174A7D89FAEF0096678` | `05A17570A07265A578E893CB6E0CF70A5DF61EF9ECC0304C791B0F24A7FFB251` |
| F2 | `7B4591967E8FC50B337E6C210D2BC0C28B9CC5ECBC565CE41DE2567FD437CFEF` | `2D8F91B399309286738C33745A4960B5F0A851DF134C1704FFC5875E667E1209` |
| F3 | `85F28B209C94105F597900691C92E8E52D277871175E9B36241C974309F18FCD` | `5B674938425FB04DFC6FA85419D2678C57778B32F4ED4FE6EC63F1B02DDBF1FE` |

`tools\check_upstream.ps1` inside the mod folder does the same original-file check and the same newer-folder check, and it writes nothing. It prints `DRIFT` when an original changed or a newer version folder appeared, and `RESULT OK` when the pinned files still match. Set `PZ_WORKSHOP` if the Workshop library is not the default Steam path. Run it before install and after a Workshop update. A `DRIFT` line means this 1.1.0 fix no longer fits that mod until the override is rebuilt from the new file.

The three upstream problems, and a short list of other boot-log notes that this mod does not patch, are in `UPSTREAM.md` inside the mod folder (S1–S3 are F1–F3; S4 is the removed Sentry shim).

---

## Install

Use [MKev's Modpatch Installer](../../Modpatch-Installer/README.md). Option 1 or option 2 copies `mkevserverbootpatch` into `Zomboid\mods` and builds F1–F3 as part of that copy. Option 5 shows what would change and writes nothing.

After a mod update, run the installer again. A fix that no longer matches is skipped and named in the installer log. Your Workshop files stay as they were.

History of this mod: [`CHANGELOG.md`](CHANGELOG.md).
