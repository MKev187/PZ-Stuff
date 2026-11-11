# Changelog: MKev's Server BootPatch

Mod id `mkevserverbootpatch`. Current version **1.1.2**. Standalone zip: [`Server-BootPatch-v1.1.2.zip`](Server-BootPatch-v1.1.2.zip). The same mod ships inside [MKev's Modpatch Installer v1.3b](../../Modpatch-Installer/README.md) (unchanged since v1.3).

## MKev's Server BootPatch 1.1.2 — 2026-11-11

**SHA256** of `Server-BootPatch-v1.1.2.zip`: `6bf15134a416a64edcfb068316ba5fdf1dc7717ad4fa4ca1b6a22f3524c38ab8`

- Version and docs only. It ships with [MKev's Modpatch Installer v1.3](../../Modpatch-Installer/CHANGELOG.md). The F1–F3 files, the placeholders and the self-healing logic (`tools/bootfix.ps1`, `tools/check_upstream.ps1`, `tools/check_upstream.sh`) are the same as in 1.1.1; only their header comments name 1.1.2.
- `mod.info` and READMEs: the installer is named as "1.2 or newer"; a note says that Linux case problems of other mods are handled by the optional [MKev's Linux-Guard](../Linux-Guard/README.md), not by this mod. `versionMin=42.21`, no `versionMax`.
- `mod.info` name: `MKev's Server BootPatch` (was `MKevServerBootPatch v1.1.1`). Only the name in the mod list changes; the id `mkevserverbootpatch` stays.
- The standalone `Server-BootPatch-v1.1.1.zip` (SHA256 `f218f38753b77cc7c0eaa2fb6aba116f403f2a21c85f8011a4167a663eb23466`) is no longer stored in this repository; 1.1.1 is inside the archived installer v1.2.

## MKev's Server BootPatch 1.1.1 — 2026-11-10

- F1–F3 are fixed parts of the mod again: `42/media/scripts/recipes/recipes_fletching.txt`, `42/media/scripts/recipes/recipes_MCR_1Handed.txt`, `42/media/scripts/sounds/LabSounds.txt`. No installer step is needed, so the mod works on Linux (and any) dedicated servers by copying the folder.
- Reason: on a Linux dedicated server the Windows installer never ran. 1.1.0 then had only placeholders, and all F1–F3 boot messages stayed (`//Royalty-free`, `Unknown skill "Carpentry"`, 6× `Unknown skill "Electrical"`; server log of 2026-11-10).
- Built from the current Workshop files (checked 2026-11-10, unchanged since 1.1.0) with the same transformation as the installer. Same bytes as the installer build of 1.1.0 and the 1.0.2 overrides.
- Self-healing: when one of the original mods updates, the fix is rewritten from the new original instead of needing a new BootPatch version. Same logic in installer v1.2 and the optional admin tools `tools/check_upstream.ps1 -Fix` / new `tools/check_upstream.sh --fix` (no setup step for server admins) (core `tools/bootfix.ps1`): find the file the game loads (highest `42.x` folder, `PZ_GAMEBUILD` cap, else `common`, case-insensitive); unchanged → `KEEP` the bundled file; changed with the error → `REBUILT` by the token edit (BOM/CRLF kept; checked: error tokens gone, only intended lines, braces balanced); error gone → `FIXED_UPSTREAM`, override removed; file no longer loaded → `NOT_LOADED`, override removed; mod missing → bundled file stays; check failed → `FAIL`, previous file stays, warning only. `MANIFEST.sha256` is rewritten after a change. Without the switch both tools are a dry run (exit `2` = changes found, `3` = FAIL).
- `mod.info`: modversion 1.1.1, `versionMin=42.21`, no `versionMax`. New `README_DE.md` in the mod folder.
- [MKev's Modpatch Installer v1.2](../../Modpatch-Installer/CHANGELOG.md) ships this version; it no longer builds F1–F3 from scratch, it only rewrites a fix when a mod was updated.

## MKev's Server BootPatch 1.1.0 — 2026-11-06

- F1–F3 are no longer shipped as copies of third-party files. ModPatchInstaller 0.2.0 builds them from the installed Workshop originals (SHA256 of the original and of the result checked, same bytes as the 1.0.2 overrides). [MKev's Modpatch Installer v1.0](../Patch-Installer/CHANGELOG.md), v1.1, and v1.1b still ship this same 1.1.0 mod and still build F1–F3 at install time.
- F4 removed: Sentry Turret Upgrade (Workshop 3633082678, id `SentryTurret042`) is not in the pack on the 2026-11-06 list (381 mods / 328 Workshop items). `loadModAfter` no longer names `SentryTurret042`. `AUDIT.md` was removed from the release copy.
- `tools/check_upstream.ps1`: no private paths, Sentry checks removed, `PZ_WORKSHOP` override added. The script is read-only.

## MKev's Server BootPatch 1.0.2 — 2026-10-30

Staged, not installed.

- F6 placeholders for every folder the 42.21 `AdvancedAnimator` scans per mod. `collectModFiles` calls `loadModMedia` on the `common` folder and on the version folder. Each scans `media/AnimSets` and `media/actiongroups` with `Files.walkFileTree`. A missing folder ends in `visitFileFailed`, which logs `NoSuchFileException`. Boot continues.
- New folders, each with `readme_placeholder.txt`: `42/media/AnimSets/`, `common/media/AnimSets/`, `common/media/actiongroups/`. `42/media/actiongroups/` from 1.0.1 stays.
- Only names ending in `.xml` are read and checksummed, so the `.txt` placeholder is ignored. `anims_X` is not scanned and has no placeholder.
- `mod.info`: modversion 1.0.2.

## MKev's Server BootPatch 1.0.1 — 2026-10-30

- F5: empty `42/media/actiongroups/` with `readme_placeholder.txt`. `AdvancedAnimator` scanned `media/actiongroups` of every mod at boot and logged `NoSuchFileException` for this mod because the folder was missing. No game data inside.
- `mod.info`: modversion 1.0.1.

## MKev's Server BootPatch 1.0 — 2026-10-25

- F1 Archery Nexus [Fixed]: recipe skill Carpentry → Woodwork (`recipes_fletching.txt` override, shipped as a file copy in this version).
- F2 Mad Crafter: recipe skill Electrical → Electricity in 2 recipes (`recipes_MCR_1Handed.txt` override, folder 42.15).
- F3 Zombie Virus Vaccine: `LabSounds.txt` `//` comment → `/* */`, which restores sound `Injection_A` (folder 42.20).
- F4 Sentry Turret Upgrade: require-path shim for `ST_MP_TurretUtil` (server only, and only if that mod is active). Removed in 1.1.0.
- `tools/check_upstream.ps1`: read-only drift check for the overridden upstream files.
