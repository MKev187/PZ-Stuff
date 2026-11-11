# MKev's Linux-Guard 1.0.0

Made by MKev.

*Deutsche Version: [weiter unten](#deutsch)*

Linux-Guard is an **optional** start script for **Linux** dedicated servers of Project Zomboid B42. It fixes mod files that
Linux does not find because of upper and lower case. Players and Windows servers do not need it.

**Files:** `start-server.sh` (the script), `Guide.txt` (which of the 3 setups fits your host), `README.md` (this file).
It comes with [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) (folder `Linux-Guard/` in [`Modpatch-Installer-v1.3.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.3.zip)).
**Download:** [`start-server.sh`](start-server.sh) and [`Guide.txt`](Guide.txt) in this folder (SHA256 in [`SHA256SUMS.txt`](SHA256SUMS.txt)). History: [`CHANGELOG.md`](CHANGELOG.md).

## The problem

Windows ignores upper and lower case in file names, Linux does not. Some mods use their own files with a different spelling,
and Project Zomboid looks up some mod paths completely in lower case (for example animation files linked with `x_extends`,
`.../media/AnimSets/...` is looked up as `.../media/animsets/...`). On Linux these files are not found: errors in the server
log, missing animations or recipes.

## What Linux-Guard does at every start

1. **Linux?** If the server does not run on Linux, nothing is changed and the server just starts.
2. **Already fixed?** If another script already made the links, or the original start script has its own case fix,
   Linux-Guard does nothing extra.
3. **Lowercase links:** next to every mod file and folder with capital letters it adds a link with the lowercase name
   (`AnimSets` → `animsets`). **Nothing is renamed, moved or overwritten.** Workshop files stay as they are, so Steam updates keep
   working. An existing real file is never replaced. Links only point to their neighbour in the same folder, so there are no loops.
   Running it again changes nothing (idempotent). Links of Linux-Guard whose original was removed by a mod update are cleaned up.
   Folders: `<server>/steamapps/workshop/content/108600` and `Zomboid/mods` (`-cachedir=` is respected, else `~/Zomboid`).
4. **Start:** exactly like the original `start-server.sh` of PZ (same Java setup, same `ProjectZomboid64` call, all start options
   are passed on). Used as a wrapper (see `Guide.txt`, case 1 and 3), it starts the original `start-server.sh` instead.
5. **After the boot:** when the console shows `SERVER STARTED`, it checks once more. Only if mods downloaded during this boot needed
   **new** links, it sends `servermsg` to the players, waits 60 s and restarts the server **once** with `quit` (the world is saved).
   Loop guard: at most one automatic restart per start, and none if the last one was less than an hour ago
   (`.linux-guard/last-auto-restart`).

Console input from your panel or terminal is passed on to the server. Stop signals (Ctrl+C, panel stop, `SIGTERM`) are sent as
`quit`, so the world is saved. Everything is logged to `linux-guard.log` in the server main folder.

## Setup

**Nothing has to be edited.** Pick your case in `Guide.txt`:

| Case | Your host | What you do |
|---|---|---|
| **1** | Start command can be changed | Put the script into `<server>/Linux-Guard/` and start with `bash Linux-Guard/start-server.sh <options>`. The original stays. |
| **2** | Start command fixed, files stay | Replace `start-server.sh` in the server main folder (next to `ProjectZomboid64`) with this one. Copy it in again after a PZ server update. |
| **3** | Docker / panel creates the `.sh` new | Put the folder into the persistent volume and call it with the start-command variable of the image, if it has one. Otherwise a lasting fix is not possible. |

## Commands

| Command | What it does |
|---|---|
| `bash start-server.sh --linux-guard-check` | Counts missing links. Writes nothing, does not start the server. |
| `bash start-server.sh --linux-guard-undo` | Removes only links made by Linux-Guard (they point to `./<name>`). Links of other tools stay. |

## Optional settings

Not needed. Set them as environment variables, or as `KEY=VALUE` lines in a file `linux-guard.conf` next to the script
(only these keys are read, nothing in the file is executed).

| Key | Default | Meaning |
|---|---|---|
| `LG_ENABLE` | `1` | `0` = no case fix at all, plain start like the original. |
| `LG_AUTORESTART` | `1` | `0` = no check after the boot and no automatic restart (the case fix before the start still runs). |
| `LG_RESTART_DELAY` | `60` | Seconds between the player message and the restart. |
| `LG_RESTART_COOLDOWN` | `3600` | No automatic restart if the last one was less than this many seconds ago. |
| `LG_BOOT_TIMEOUT` | `3600` | If `SERVER STARTED` never shows up, links are made after this time, without a restart. |
| `LG_STOP_TIMEOUT` | `300` | Seconds to wait after `quit` before the server gets `SIGTERM`. |
| `LG_SERVER_DIR` | auto | Server main folder (auto: folder of the script, or one folder above, with `ProjectZomboid64`). |
| `LG_ZOMBOID_DIR` | auto | Zomboid folder, if it is neither `-cachedir=` nor `~/Zomboid`. |
| `LG_SCAN_DIRS` | auto | Folders to fix, separated by `:` (replaces the two default folders). |

## Requirements and limits

- bash 4 or newer, GNU `find`, `ln`, `mkfifo` (standard on Linux servers and Docker images). Started with `sh`, it switches to bash.
- Without `mkfifo` it starts the server without the check after the boot.
- Only ASCII capital letters are linked. Paths that a mod writes with a *different* mixed spelling cannot be fixed with lowercase links.
- The first run on a big mod pack can take a minute (one link per file); later runs only check (a few seconds).
- Version 1.0.0 was tested with a test setup (fake server and Java), not yet on a real hosted server.

## Remove

Put back the original `start-server.sh` or the old start command. Optional first: `bash start-server.sh --linux-guard-undo`.
The links do no harm if they stay.

---

<a id="deutsch"></a>
## Deutsch

Made by MKev.

Linux-Guard ist ein **optionales** Startskript für **Linux**-Dedicated-Server von Project Zomboid B42. Es behebt Mod-Dateien, die
Linux wegen Groß- und Kleinschreibung nicht findet. Spieler und Windows-Server brauchen es nicht.

**Dateien:** `start-server.sh` (das Skript), `Guide.txt` (welcher der 3 Fälle zu deinem Host passt, Englisch), `README.md` (diese Datei).
Es liegt [MKev's Modpatch Installer](../../Modpatch-Installer/README.md) bei (Ordner `Linux-Guard/` in [`Modpatch-Installer-v1.3.zip`](../../Modpatch-Installer/Modpatch-Installer-v1.3.zip)).
**Download:** [`start-server.sh`](start-server.sh) und [`Guide.txt`](Guide.txt) in diesem Ordner (SHA256 in [`SHA256SUMS.txt`](SHA256SUMS.txt)). Verlauf: [`CHANGELOG.md`](CHANGELOG.md).

### Das Problem

Windows ignoriert Groß- und Kleinschreibung in Dateinamen, Linux nicht. Manche Mods sprechen ihre Dateien anders geschrieben an,
und Project Zomboid sucht manche Mod-Pfade komplett kleingeschrieben (zum Beispiel per `x_extends` verknüpfte Animationsdateien,
`.../media/AnimSets/...` wird als `.../media/animsets/...` gesucht). Unter Linux werden diese Dateien nicht gefunden: Fehler im
Server-Log, fehlende Animationen oder Rezepte.

### Was Linux-Guard bei jedem Start macht

1. **Linux?** Läuft der Server nicht auf Linux, wird nichts geändert und der Server startet einfach.
2. **Schon behoben?** Hat ein anderes Skript die Verknüpfungen schon angelegt oder hat das originale Startskript einen eigenen
   Case-Fix, macht Linux-Guard nichts zusätzlich.
3. **Kleinschreib-Verknüpfungen:** Neben jede Mod-Datei und jeden Mod-Ordner mit Großbuchstaben kommt eine Verknüpfung (Symlink) mit
   dem kleingeschriebenen Namen (`AnimSets` → `animsets`). **Nichts wird umbenannt, verschoben oder überschrieben.** Die Workshop-Dateien
   bleiben, wie sie sind, Steam-Updates funktionieren weiter. Eine vorhandene echte Datei wird nie ersetzt. Verknüpfungen zeigen nur auf
   den Nachbarn im selben Ordner, deshalb gibt es keine Schleifen. Ein zweiter Lauf ändert nichts. Verknüpfungen von Linux-Guard, deren
   Original ein Mod-Update entfernt hat, werden aufgeräumt.
   Ordner: `<Server>/steamapps/workshop/content/108600` und `Zomboid/mods` (`-cachedir=` wird beachtet, sonst `~/Zomboid`).
4. **Start:** genau wie die originale `start-server.sh` von PZ (gleiche Java-Einrichtung, gleicher Aufruf von `ProjectZomboid64`, alle
   Startoptionen werden durchgereicht). Als Wrapper (siehe `Guide.txt`, Fall 1 und 3) startet es stattdessen die originale `start-server.sh`.
5. **Nach dem Boot:** Sobald die Konsole `SERVER STARTED` zeigt, prüft es noch einmal. Nur wenn Mods, die bei diesem Boot heruntergeladen
   wurden, **neue** Verknüpfungen brauchten, schickt es `servermsg` an die Spieler, wartet 60 s und startet den Server **einmal** mit `quit`
   neu (die Welt wird gespeichert). Schleifensperre: höchstens ein automatischer Neustart pro Start, und keiner, wenn der letzte weniger als
   eine Stunde her ist (`.linux-guard/last-auto-restart`).

Eingaben in deinem Panel oder Terminal kommen weiter beim Server an. Stopp-Signale (Strg+C, Stopp im Panel, `SIGTERM`) werden als `quit`
weitergegeben, die Welt wird also gespeichert. Alles steht in `linux-guard.log` im Server-Hauptordner.

### Einrichtung

**Nichts muss bearbeitet werden.** Such dir deinen Fall in `Guide.txt` aus:

| Fall | Dein Host | Was du machst |
|---|---|---|
| **1** | Startbefehl änderbar | Skript nach `<Server>/Linux-Guard/` legen und mit `bash Linux-Guard/start-server.sh <Optionen>` starten. Das Original bleibt. |
| **2** | Startbefehl fest, Dateien bleiben | `start-server.sh` im Server-Hauptordner (neben `ProjectZomboid64`) durch diese ersetzen. Nach einem PZ-Server-Update neu hineinlegen. |
| **3** | Docker / Panel erzeugt die `.sh` neu | Ordner ins dauerhafte Volume legen und über die Startbefehl-Variable des Images aufrufen, falls es eine gibt. Sonst ist keine dauerhafte Reparatur möglich. |

### Befehle

| Befehl | Was er macht |
|---|---|
| `bash start-server.sh --linux-guard-check` | Zählt fehlende Verknüpfungen. Schreibt nichts, startet den Server nicht. |
| `bash start-server.sh --linux-guard-undo` | Entfernt nur Verknüpfungen von Linux-Guard (sie zeigen auf `./<Name>`). Verknüpfungen anderer Werkzeuge bleiben. |

### Optionale Einstellungen

Nicht nötig. Als Umgebungsvariablen oder als `KEY=VALUE`-Zeilen in einer Datei `linux-guard.conf` neben dem Skript (nur diese Schlüssel
werden gelesen, nichts in der Datei wird ausgeführt): `LG_ENABLE` (1, `0` = kein Case-Fix, Start wie das Original), `LG_AUTORESTART`
(1, `0` = keine Prüfung nach dem Boot und kein automatischer Neustart), `LG_RESTART_DELAY` (60 s), `LG_RESTART_COOLDOWN` (3600 s),
`LG_BOOT_TIMEOUT` (3600 s), `LG_STOP_TIMEOUT` (300 s), `LG_SERVER_DIR`, `LG_ZOMBOID_DIR`, `LG_SCAN_DIRS` (Bedeutung wie in der Tabelle oben).

### Voraussetzungen und Grenzen

- bash 4 oder neuer, GNU `find`, `ln`, `mkfifo` (auf Linux-Servern und Docker-Images Standard). Mit `sh` gestartet, wechselt es zu bash.
- Ohne `mkfifo` startet es den Server ohne die Prüfung nach dem Boot.
- Verknüpft werden nur ASCII-Großbuchstaben. Pfade, die eine Mod in einer *anderen* gemischten Schreibweise anspricht, lassen sich mit
  Kleinschreib-Verknüpfungen nicht beheben.
- Der erste Lauf kann bei einem großen Modpack eine Minute dauern (eine Verknüpfung pro Datei), spätere Läufe prüfen nur (wenige Sekunden).
- Version 1.0.0 wurde mit einem Testaufbau geprüft (simulierter Server und Java), noch nicht auf einem echten gemieteten Server.

### Entfernen

Originale `start-server.sh` oder den alten Startbefehl zurückholen. Optional vorher: `bash start-server.sh --linux-guard-undo`.
Die Verknüpfungen schaden nicht, wenn sie bleiben.

*Made by MKev.*
