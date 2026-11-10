# Patches

These are MKev's compatibility patches and the installer for his Project Zomboid Build 42 collection, [MKev Zomboid Modlist B42.22 (v1.0)](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199) (Workshop 3827894199).

If the collection's patch notes sent you here, this page is the short tour. The patches deal with problems that show up when this mod list runs together. They do that while the game is running, or by building a small local fix from Workshop files you already have installed. Workshop originals are never edited.

Author: **MKev**.

## Current versions

| Package | Version | What it is for |
|---|---|---|
| [MKev's Modpatch Installer](../Modpatch-Installer/README.md) | **1.1b** | The download most people should use. One package for the dedicated server and for every player. |
| [MKev's Modpatcher](ModPatcher/README.md) | **1.1b** | The core runtime patch. It is already inside the installer. A standalone zip is in `ModPatcher/` if you only need the patcher. |
| [MKev's Server BootPatch](Server-BootPatch/README.md) | **1.1.0** | Boot-log script fixes. There is no separate zip. The installer builds this mod when you install. |

The server and every player need the same ModPatcher version, and the same Server BootPatch version. Script checksums have to match.

## The download most people should use

MKev's Modpatch Installer is the all-in-one package. It contains MKev's Modpatcher 1.1b, the server kit (mod list, load order, map, sandbox, and the in-game preset `MKevServer`), and MKev's Server BootPatch 1.1.0.

The current zip is at the repository root, in [Modpatch-Installer](../Modpatch-Installer/README.md):

- [Modpatch-Installer-v1.1b.zip](../Modpatch-Installer/Modpatch-Installer-v1.1b.zip)
- Install notes: [MKev's Modpatch Installer](../Modpatch-Installer/README.md)
- Published release: [Modpatch-Installer-v1.1b](https://github.com/MKev187/PZ-Stuff/releases/tag/Modpatch-Installer-v1.1b)

On Windows, close the game and your own PZ server, extract the whole zip, and start `ModPatchInstaller.bat`. The installer refuses to run while either one is running. It then asks which language to use: English or German.

**Install & set up** is the mode for a server you already run. It installs both patch mods. In `servertest.ini` it replaces only the lines `Mods=`, `WorkshopItems=`, and `Map=`. It also replaces the server sandbox with the MKev sandbox and adds the preset `MKevServer`. Passwords, ports, the server name, and every other ini line stay. It shows what will change and asks before it writes, and it keeps a backup.

**Install only** leaves your current server settings alone. It installs the two patch mods and puts ready-made files into `Zomboid\MKevServer_setup\`, including the mod list, the map, the sandbox, and the preset, so you can apply them yourself.

A dry run shows what Install & set up would change and writes nothing.

The package contains no passwords and no `servertest.ini`. The server kit is the MKev server list of **376** mods and **325** Workshop items, map `Muldraugh, KY`, for Build 42.22.2. `WorkshopItems` includes I Know It! (Workshop [3836594593](https://steamcommunity.com/sharedfiles/filedetails/?id=3836594593)) in the load order this kit writes. I Know It! is part of that list and is not inside the zip. It comes from the Workshop collection, like every other Workshop mod. Both patch mods are last in `Mods=`.

Server BootPatch 1.1.0 is built during that install, from the Workshop files already on the machine. The installer checks each source file's SHA256, changes only the listed text, and checks the result. If a mod was updated and a fix no longer fits, that one fix is skipped and named. The rest still installs.

## What is in this folder

Three folders are here. The current installer zip is the one linked above, at the repository root.

### MKev's Modpatcher

[ModPatcher/](ModPatcher/README.md) is the core. Mod id `mkev_modpatcher`, version **1.1b**. It is a local mod: it loads last, and it fixes other mods while the game runs. It does not edit their files. Anything it adds lives in its own folder.

The standalone zip is [Modpatcher-v1.1b.zip](ModPatcher/Modpatcher-v1.1b.zip). For a new dedicated server, use the installer. That run builds Server BootPatch and can set the mod list, map, sandbox, and preset.

Two fixes are the ones people usually ask about. The full module list is on the [ModPatcher page](ModPatcher/README.md).

**The VVR spawn guard.** Vanilla Vehicles Replacer (KI5) swaps a vanilla vehicle for one of its replacements. On a dedicated server, swapping a vehicle that already has physics reaches `Bullet.removeVehicle`, a native call the server does not have. The swap throws `UnsatisfiedLinkError` and stops halfway. The guard exists so that path is not used. From 0.1.8 through 0.1.11 it did that by skipping VVR for every vehicle that already existed, so vanilla vehicles VVR had missed at first spawn stayed vanilla, for example Step Vans and Vans. ModPatcher **1.1_vvr** (the build shipped in installer 1.1) lets VVR replace vanilla vehicles again on a dedicated server, and it stays off the `Bullet.removeVehicle` path. Version **1.1b** keeps that guard unchanged. Clients, a coop host, and single player are left alone. No VVR file is copied or modified.

**The Tweed jacket tooltip fix, added in 1.1b.** The Tweed jacket ("Tweedjacke", EN "Suit Jacket - Tweed") is not a vanilla item. It comes from Spongie's Clothing. The closed jacket uses BodyLocation `base:jacket_suit`, and the open jacket uses `base:JACKET_OPEN`. Neither id exists in Build 42.22, so every mouse hover threw a `NullPointerException` in the item tooltip. The fix sets `base:jacketsuit` on the jacket, and `SpnOpenCloth:JACKET_OPEN` on the open jacket when Spongie's Open Jackets [BASE] is active. It runs only while Spongie's Clothing is active and the location is still missing. Spongie's files are not modified.

After you install, the log should show `[MKev-ModPatcher] version 1.1b loaded`.

### Earlier installer packages

[Patch-Installer/](Patch-Installer/README.md) keeps earlier installer packages. The current release is [MKev's Modpatch Installer](../Modpatch-Installer/README.md) at the repository root.

Still in that folder:

- `Modpatch-Installer-v1.0.zip` (installer 1.0, with ModPatcher 0.1.11 and Server BootPatch 1.1.0)
- `MKev-ModPatcher-v0.3.0.zip`, the older package for Build 42.21
- a leftover copy of `Modpatch-Installer-v1.1b.zip`, the same bytes as the current zip at the repo root

### MKev's Server BootPatch

[Server-BootPatch/](Server-BootPatch/README.md) is a small second mod, id `mkevserverbootpatch`, version **1.1.0**. Load it at the very end of `Mods=`, after `mkev_modpatcher`. It fixes script bugs that show up in the dedicated-server boot log.

There is no standalone BootPatch zip. Version 1.1.0 comes with the installer. The three script fixes are built on the machine where you install, from your own Workshop copies. The installer only reads those files, checks the SHA256 of the original and of the result, and writes the built file into this mod's own folder under `Zomboid\mods`. Your Workshop copy stays as it was.

- **Archery Nexus [Fixed].** The recipe "Assemble A Primitive Hunting Bow" asks for the perk `Carpentry:3`. That id is not a Build 42 perk. The built file uses `Woodwork:3`.
- **Mad Crafter.** Two recipes use `Electrical:` where the perk id is `Electricity:` (six places). Requirement, autolearn, and XP work again.
- **Zombie Virus Vaccine.** A `//` comment kept the sound `Injection_A` from being registered, because the Build 42 script parser only strips `/* */` comments. The built file turns that line into a block comment.

If a Workshop file is missing or its hash does not match, that one fix is reported as not built. The other fixes still install.

## Credits

Made by **MKev**.

The mods in the [collection](https://steamcommunity.com/sharedfiles/filedetails/?id=3827894199) belong to their authors. This repository ships none of their files.
