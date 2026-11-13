# Changelog: MKev's Linux-Guard

Optional start script (`start-server.sh`) for Linux dedicated servers of Project Zomboid B42. Made by MKev.
It ships inside [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) (folder `Linux-Guard/`) and in this folder.

*Deutsche Version: [weiter unten](#deutsch)*

## MKev's Linux-Guard 1.0.0 — 2026-11-11

First version, part of MKev's Modpatch Installer v1.3.

- Drop-in replacement for the `start-server.sh` of the PZ dedicated server (next to `ProjectZomboid64`), or a wrapper that starts the original `start-server.sh` (when it lies in a subfolder such as `<server>/Linux-Guard/`).
- Detects Linux. On any other system it changes nothing and only starts the server.
- Detects an existing case fix: links made by another script (then nothing is missing and nothing is changed), or an original start script that already has its own case fix (then Linux-Guard does nothing extra and just starts it).
- Otherwise it adds lowercase links (`./Name`, relative, next to the original) for mod files and folders with capital letters in `steamapps/workshop/content/108600` and `Zomboid/mods`. The Zomboid folder comes from `-cachedir=`, from `deployment.user.cachedir` in `ProjectZomboid64.json`, or `~/Zomboid`. Nothing is renamed, moved or overwritten; existing real files are never replaced; no link loops; a second run changes nothing; its own links whose original is gone are removed.
- Starts the server exactly like the original PZ `start-server.sh` (`jre64` check, `PATH`, `LD_LIBRARY_PATH`, `LD_PRELOAD=libjsig.so`, `./ProjectZomboid64 "$@"`, `exit 0`).
- After `SERVER STARTED` in `server-console.txt` it checks again. If mods downloaded during the boot needed new links, it sends `servermsg`, waits 60 s and restarts the server once with `quit` (world saved). Loop guard: at most one automatic restart per start and none within an hour of the last one (`.linux-guard/last-auto-restart`).
- Console input of the host is passed on to the server; stop signals (`SIGTERM`, `SIGINT`, `SIGHUP`) are sent as `quit`.
- `--linux-guard-check` (count only, writes nothing) and `--linux-guard-undo` (removes only Linux-Guard's own links). Log: `linux-guard.log` in the server folder. Optional settings via environment or `linux-guard.conf` (read as data, never executed).
- Tested with a test setup (fake `ProjectZomboid64` and Java): 33 checks, shellcheck clean. Not yet tested on a real hosted Linux server.

---

<a id="deutsch"></a>
## Deutsch

## MKev's Linux-Guard 1.0.0 — 11.11.2026

Erste Version, Teil von MKev's Modpatch Installer v1.3.

- Ersatz für die `start-server.sh` des PZ-Dedicated-Servers (neben `ProjectZomboid64`) oder Wrapper, der die originale `start-server.sh` startet (wenn es in einem Unterordner wie `<Server>/Linux-Guard/` liegt).
- Erkennt Linux. Auf jedem anderen System ändert es nichts und startet nur den Server.
- Erkennt einen vorhandenen Case-Fix: Verknüpfungen eines anderen Skripts (dann fehlt nichts und nichts wird geändert) oder ein originales Startskript mit eigenem Case-Fix (dann macht Linux-Guard nichts zusätzlich und startet es nur).
- Sonst legt es kleingeschriebene Verknüpfungen (`./Name`, relativ, neben dem Original) für Mod-Dateien und -Ordner mit Großbuchstaben in `steamapps/workshop/content/108600` und `Zomboid/mods` an. Der Zomboid-Ordner kommt aus `-cachedir=`, aus `deployment.user.cachedir` in `ProjectZomboid64.json` oder ist `~/Zomboid`. Nichts wird umbenannt, verschoben oder überschrieben; echte Dateien werden nie ersetzt; keine Schleifen; ein zweiter Lauf ändert nichts; eigene Verknüpfungen ohne Original werden entfernt.
- Startet den Server genau wie die originale PZ-`start-server.sh` (`jre64`-Prüfung, `PATH`, `LD_LIBRARY_PATH`, `LD_PRELOAD=libjsig.so`, `./ProjectZomboid64 "$@"`, `exit 0`).
- Nach `SERVER STARTED` in `server-console.txt` prüft es noch einmal. Brauchten beim Boot heruntergeladene Mods neue Verknüpfungen, schickt es `servermsg`, wartet 60 s und startet den Server einmal mit `quit` neu (Welt gespeichert). Schleifensperre: höchstens ein automatischer Neustart pro Start und keiner innerhalb einer Stunde nach dem letzten (`.linux-guard/last-auto-restart`).
- Konsolen-Eingaben des Hosts kommen beim Server an; Stopp-Signale (`SIGTERM`, `SIGINT`, `SIGHUP`) werden als `quit` weitergegeben.
- `--linux-guard-check` (nur zählen, schreibt nichts) und `--linux-guard-undo` (entfernt nur Verknüpfungen von Linux-Guard). Log: `linux-guard.log` im Server-Ordner. Optionale Einstellungen über Umgebung oder `linux-guard.conf` (nur als Daten gelesen, nie ausgeführt).
- Geprüft mit einem Testaufbau (simulierter `ProjectZomboid64` und Java): 33 Prüfungen, shellcheck ohne Befund. Auf einem echten gemieteten Linux-Server noch nicht getestet.

*Made by MKev.*
