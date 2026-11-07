# MKev Mod Collection - Patch Installer

Patch package for the **MKev B42 Mod Collection** (Project Zomboid Build 42.21 multiplayer).

**Download:** `MKev-ModPatcher-v0.3.0.zip`

| Part | Version |
|---|---|
| ModPatchInstaller (`.bat` + `.ps1`) | 0.3.0 |
| MKev-ModPatcher (`mkev_modpatcher`) | 0.1.11 |
| MKevServerBootPatch (`mkevserverbootpatch`) | 1.1.0 |
| Server setup (`MKevServer_setup`) | 381 mods / 329 Workshop items, Map Muldraugh, KY, sandbox + preset `MKevServer` |

I Knew It! is not part of this package. It comes from the Steam Workshop like every other collection mod:
https://steamcommunity.com/sharedfiles/filedetails/?id=3834998997

## Install (Windows)
1. Subscribe to the Workshop collection.
2. Close the game and your own PZ server (the installer refuses to run while they are running).
3. Extract the zip completely and double-click `ModPatchInstaller.bat`.
4. Menu:
   - **1 Install & set up** - shows what will change and asks first. Backs up everything, installs the two patch mods to `%USERPROFILE%\Zomboid\mods\`, replaces only the `Mods=`, `WorkshopItems=` and `Map=` lines of `Zomboid\Server\servertest.ini` (passwords, ports and all other lines stay), sets the server sandbox and adds the mod preset `MKevServer`.
   - **2 Install only** - installs the two patch mods and puts ready-made `MKevServer_*` files into `Zomboid\MKevServer_setup\`. Nothing else is changed.
   - **3 Restore backup**, **4 Exit**, **5 Dry run** (shows changes, writes nothing).

The 3 script fixes of MKevServerBootPatch are built during install from your installed Workshop files (read only, SHA256 checked). If a mod was updated and a fix no longer fits, the installer reports it and only that fix is skipped. Workshop files are never modified.

Server and every player need the same patch version.

Author: MKev
