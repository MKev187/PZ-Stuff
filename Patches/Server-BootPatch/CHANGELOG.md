# Changelog: MKev's Server BootPatch

Mod id `mkevserverbootpatch`. Current version **1.1.0**. There is no standalone zip. The mod ships inside [MKev's Modpatch Installer](../../Modpatch-Installer/README.md).

These notes are the mod's own `CHANGELOG.md` from installer v1.1b (the BootPatch copy is unchanged from installer v1.0).

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
