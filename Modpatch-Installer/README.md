# MKev's Modpatch Installer

Patch package for the **MKev B42 Mod Collection** ([Workshop collection 3827894199](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199), Project Zomboid Build 42.22.2 multiplayer).

**Current download (this folder):** [`Modpatch-Installer-v1.3.zip`](Modpatch-Installer-v1.3.zip)  
**SHA256:** `1c41d1d5f30f972bf5235f7ee3ff41e64fafec03d9adc68e2c83a20d1aa1eff0`  
Release: [Modpatch-Installer-v1.3](https://github.com/MKev187/PZ-Stuff/releases/tag/Modpatch-Installer-v1.3).

The standalone current patcher is [`Modpatcher-v1.2.zip`](../Patches/ModPatcher/Modpatcher-v1.2.zip) in [MKev's Modpatcher](../Patches/ModPatcher/README.md) (SHA256 `72e78c65d3e62ad6e14d9bdf3aa920344062ebf73a18d8876722d787ef941b17`).
The standalone BootPatch is [`Server-BootPatch-v1.1.2.zip`](../Patches/Server-BootPatch/Server-BootPatch-v1.1.2.zip) in [MKev's Server BootPatch](../Patches/Server-BootPatch/README.md) (SHA256 `6bf15134a416a64edcfb068316ba5fdf1dc7717ad4fa4ca1b6a22f3524c38ab8`).
Linux-Guard (optional, Linux dedicated servers) is in the zip (folder `Linux-Guard/`) and in [MKev's Linux-Guard](../Patches/Linux-Guard/README.md).

Older installer packages are in [Patches/Patch-Installer](../Patches/Patch-Installer/README.md): `Modpatch-Installer-v1.2.zip`, `Modpatch-Installer-v1.1b.zip`, `Modpatch-Installer-v1.0.zip` and `MKev-ModPatcher-v0.3.0.zip` (Build 42.21).

These archives are not stored in this repository. The hashes are the ones published with those versions:

| File | SHA256 |
|---|---|
| `Modpatch-Installer-v1.1.zip` | `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c` |
| `Modpatcher-v1.1_vvr.zip` | `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a` |
| `Modpatcher-v1.1b.zip` (standalone, also inside installer v1.2 and v1.1b) | `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc` |
| `Server-BootPatch-v1.1.1.zip` (standalone, also inside installer v1.2) | `f218f38753b77cc7c0eaa2fb6aba116f403f2a21c85f8011a4167a663eb23466` |

| Part | Version |
|---|---|
| Modpatch Installer (`ModPatchInstaller.bat` + `ModPatchInstaller_en.ps1` / `ModPatchInstaller_de.ps1`) | 1.3 (English / Deutsch) |
| MKev's Modpatcher (`mkev_modpatcher`) | 1.2 |
| MKev's Server BootPatch (`mkevserverbootpatch`) | 1.1.2 |
| MKev's Linux-Guard (`Linux-Guard/start-server.sh`, optional, Linux servers) | 1.0.0 |
| Server setup (`MKevServer_setup`) | 376 mods / 325 Workshop items, Map Muldraugh, KY, sandbox + preset `MKevServer` |

[I Know It!](../Mods/IKnowIt/README.md) (Workshop 3836594593) is part of the mod list but is not shipped in the zip. It comes from the Workshop collection.

## Install (Windows)
1. Subscribe to the Workshop collection.
2. Close the game and your own PZ server. The installer refuses to run while they are running.
3. Extract the zip completely and double-click `ModPatchInstaller.bat`.
4. Choose the language: `1` English or `2` Deutsch.
5. Menu:
   - **1 Install & set up** adapts your existing server files. It shows what will change and asks first. It then backs up everything, installs the two patch mods to `%USERPROFILE%\Zomboid\mods\`, and replaces only the `Mods=`, `WorkshopItems=` and `Map=` lines of `Zomboid\Server\servertest.ini`. Passwords, ports and all other lines stay. Finally it sets the server sandbox and adds the mod preset `MKevServer`.
   - **2 Install only** writes to a separate folder. It installs the two patch mods and puts ready-made `MKevServer_*` files into `Zomboid\MKevServer_setup\`. Nothing else is changed.
   - **3 Restore backup**, **4 Exit**, **5 Dry run** (shows changes, writes nothing).

Since v1.2 the 3 script fixes of MKev's Server BootPatch (1.1.1 and later, now 1.1.2) are fixed parts of the mod, and they heal themselves. At every install the installer finds the original file the game loads (highest `42.x` version folder of the mod, else `common`; names compared case-insensitively) and decides per fix:

| Case | What the installer does |
|---|---|
| Original unchanged | keeps the bundled fix |
| Mod updated, bug still in it | rewrites the fix from the new original (same one-token edit, BOM and line endings kept), checks it (bug gone, only the intended lines changed, braces balanced) and writes it into `mkevserverbootpatch` |
| Mod updated, author fixed the bug | removes our fix and says so |
| Mod no longer loads that file | removes our fix |
| Mod not subscribed / no Workshop folder | keeps the bundled fix, prints a note |
| Rewritten fix fails a check | prints a WARNING, keeps the file installed before, writes nothing broken, still installs |

Everything it overwrites is backed up first (restore with menu 3). Workshop files are only read, never modified. Other Steam library: set `PZ_WORKSHOP`.

## Linux / other dedicated servers
The installer is for Windows. On a Linux server copy the two folders `mkev_modpatcher` and `mkevserverbootpatch` from the zip into the server's `Zomboid/mods/` folder (the folder that contains `Server/` and `Saves/`) and use the `MKevServer_*` files for `servertest.ini`. BootPatch 1.1.2 needs no build step, so all three fixes are active there too. Add both to `Mods=` - that's it, no start script or other server file has to be changed.

**Optional, Linux only: Linux-Guard.** Linux cares about upper and lower case in file names, Windows does not, so on Linux some mod files are not found. The zip folder `Linux-Guard/` holds a `start-server.sh` that adds lowercase links (nothing is renamed or overwritten) before the server starts, then starts PZ exactly like the original file, and restarts the server once if mods downloaded during the boot needed new links. `Linux-Guard/Guide.txt` explains the 3 setups (start command changeable, start command fixed, Docker/panel). Nothing has to be edited. Details: [MKev's Linux-Guard](../Patches/Linux-Guard/README.md).
 Optional, only for admins who want it: `mkevserverbootpatch/tools/check_upstream.sh` checks the fixes against the installed Workshop mods by hand (same logic as the installer; dry run by default, `--fix` applies). Nothing has to be set up for it.

Server and every player need the same patch versions. The changes are listed in [`CHANGELOG.md`](CHANGELOG.md) (in this folder and inside the zip).
Updating from v1.2 or older: run the v1.3 installer again, or replace `Zomboid\mods\mkev_modpatcher` and `Zomboid\mods\mkevserverbootpatch` with the folders from the zip (server and all players; ModPatcher 1.2 changes the Lua checksum).

What the patcher and the boot fixes do, module by module: [MKev's Modpatcher](../Patches/ModPatcher/README.md), [MKev's Server BootPatch](../Patches/Server-BootPatch/README.md), [MKev's Linux-Guard](../Patches/Linux-Guard/README.md).

Verify the download with [`SHA256SUMS.txt`](SHA256SUMS.txt).

Author: MKev
