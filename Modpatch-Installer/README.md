# MKev's Modpatch Installer

Patch package for the **MKev B42 Mod Collection** ([Workshop collection 3827894199](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199), Project Zomboid Build 42.22.2 multiplayer).

**Current download (this folder):** [`Modpatch-Installer-v1.1b.zip`](Modpatch-Installer-v1.1b.zip)  
**SHA256:** `0ba6bc0049c38880b164d110a3918a5e699fe88e9e455a33341c533b60f5264f`  
Published release: [Modpatch-Installer-v1.1b](https://github.com/MKev187/PZ-Stuff/releases/tag/Modpatch-Installer-v1.1b).

The standalone current patcher is [`Modpatcher-v1.1b.zip`](../Patches/ModPatcher/Modpatcher-v1.1b.zip) in [MKev's Modpatcher](../Patches/ModPatcher/README.md) (SHA256 `2e49eff61d245d8fe78dee632e6c306e4794de3370929e124722638b721cfbcc`).

Older installer packages are in [Patches/Patch-Installer](../Patches/Patch-Installer/README.md): `Modpatch-Installer-v1.0.zip`, `MKev-ModPatcher-v0.3.0.zip` (Build 42.21), and a second copy of `Modpatch-Installer-v1.1b.zip` (same bytes as the file in this folder).

These two archives are not stored in this repository. The hashes are the ones published with those versions:

| File | SHA256 |
|---|---|
| `Modpatch-Installer-v1.1.zip` | `8ac543cb9be7548a1ac6da04eb478caa3165f7dc86227f915a3055612ecaec3c` |
| `Modpatcher-v1.1_vvr.zip` | `e1f7c4690fc15e0c11f793bfe08b5c35d4423c2a4a2c86fc991d5d81bc6cfe3a` |

| Part | Version |
|---|---|
| Modpatch Installer (`ModPatchInstaller.bat` + `ModPatchInstaller_en.ps1` / `ModPatchInstaller_de.ps1`) | 1.1b (English / Deutsch) |
| MKev's Modpatcher (`mkev_modpatcher`) | 1.1b |
| MKev's Server BootPatch (`mkevserverbootpatch`) | 1.1.0 |
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

The 3 script fixes of MKev's Server BootPatch are built during install from your installed Workshop files (read only, SHA256 checked). If a mod was updated and a fix no longer fits, the installer reports it and only that fix is skipped. Workshop files are never modified.

Server and every player need the same patch version. The changes are listed in [`CHANGELOG.md`](CHANGELOG.md) (in this folder and inside the zip).
Updating from v1.1 or v1.0: run the v1.1b installer again, or replace only `Zomboid\mods\mkev_modpatcher` with the folder from the zip (server and all players).

What the patcher and the boot fixes do, module by module: [MKev's Modpatcher](../Patches/ModPatcher/README.md), [MKev's Server BootPatch](../Patches/Server-BootPatch/README.md).

Verify the download with [`SHA256SUMS.txt`](SHA256SUMS.txt).

Author: MKev
