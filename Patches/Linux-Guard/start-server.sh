#!/bin/bash
#
###############################################################################
#
# Edit memory option -Xmx in ProjectZomboid64.json for 64bit servers (common)
#
###############################################################################
#
# Linux-Guard 1.0.0 for Project Zomboid B42 dedicated servers. Made by MKev.
# LINUX-GUARD-SIGNATURE (do not remove: lets Linux-Guard recognise itself)
#
# Drop-in replacement for the start-server.sh of the PZ dedicated server
# (Steam app 380870). It starts the server exactly like the original file and
# adds a case fix for Linux:
#   1. Checks whether the server runs on Linux. If not, nothing is changed.
#   2. Checks whether another case fix already exists. If so, it does nothing.
#   3. Otherwise it adds lowercase symlinks (shortcuts) next to mod files and
#      folders that contain capital letters, e.g. media/AnimSets ->
#      media/animsets. Nothing is renamed, moved or overwritten.
#   4. After the server has started it checks once more. Only if mods that
#      were downloaded during the boot needed new links, the server is
#      restarted once (with save), so those mods load correctly.
# Details: Guide.txt and README.md in the Linux-Guard folder.
#
# Optional settings (not needed): environment variables or a file
# linux-guard.conf next to this script with KEY=VALUE lines, see README.md.
###############################################################################

# Some hosts start the file with "sh start-server.sh": switch to bash first.
if [ -z "${BASH_VERSION:-}" ]; then exec bash "$0" "$@"; fi

LG_VERSION="1.0.0"
LG_TAG="[Linux-Guard]"

# --------------------------------------------------------------- locations
LG_SELF_DIR="$(cd "$(dirname "$0")" && pwd -P)"
LG_SELF="${LG_SELF_DIR}/$(basename "$0")"

# read linux-guard.conf (only known keys, nothing is executed)
lg_read_conf() {
	local f="$1" line key val
	[ -f "$f" ] || return 0
	while IFS= read -r line || [ -n "$line" ]; do
		line="${line%$'\r'}"
		case "$line" in ''|'#'*) continue ;; esac
		key="${line%%=*}"; val="${line#*=}"
		key="${key//[[:space:]]/}"
		case "$key" in
			LG_ENABLE|LG_AUTORESTART|LG_RESTART_DELAY|LG_RESTART_COOLDOWN|LG_BOOT_TIMEOUT|LG_STOP_TIMEOUT|LG_SCAN_DIRS|LG_SERVER_DIR|LG_ZOMBOID_DIR)
				# environment wins over the file
				if [ -z "${!key+x}" ]; then printf -v "$key" '%s' "$val"; fi ;;
		esac
	done < "$f"
}
lg_read_conf "${LG_SELF_DIR}/linux-guard.conf"

LG_ENABLE="${LG_ENABLE:-1}"
LG_AUTORESTART="${LG_AUTORESTART:-1}"
LG_RESTART_DELAY="${LG_RESTART_DELAY:-60}"
LG_RESTART_COOLDOWN="${LG_RESTART_COOLDOWN:-3600}"
LG_BOOT_TIMEOUT="${LG_BOOT_TIMEOUT:-3600}"
LG_STOP_TIMEOUT="${LG_STOP_TIMEOUT:-300}"
LG_POLL="${LG_POLL:-2}"

lg_find_server_dir() {
	local d
	for d in "${LG_SERVER_DIR:-}" "$LG_SELF_DIR" "$(dirname "$LG_SELF_DIR")" "$PWD"; do
		[ -n "$d" ] || continue
		if [ -f "$d/ProjectZomboid64" ]; then (cd "$d" && pwd -P); return 0; fi
	done
	return 1
}

LG_LOG=""
lg_say() {
	local msg
	msg="$(date '+%F %T') ${LG_TAG} $*"
	printf '%s\n' "$msg"
	if [ -n "$LG_LOG" ]; then printf '%s\n' "$msg" >> "$LG_LOG" 2>/dev/null; fi
}

lg_setup_log() {
	local f="$1/linux-guard.log" size
	if touch "$f" 2>/dev/null; then
		size=$(wc -c < "$f" 2>/dev/null || echo 0)
		if [ "${size:-0}" -gt 1048576 ]; then mv -f "$f" "$f.1" 2>/dev/null; : > "$f"; fi
		LG_LOG="$f"
	fi
}

# --------------------------------------------------------------- launching
LG_SERVER="$(lg_find_server_dir)"
LG_NEXT=""   # original start script when used as a wrapper

lg_is_linux_guard() { grep -q 'LINUX-GUARD-SIGNATURE' "$1" 2>/dev/null; }

# A start script that already brings its own case fix (ln -s + lowercase).
lg_has_case_fix() {
	local f="$1"
	[ -f "$f" ] || return 1
	grep -Eq '(^|[^[:alnum:]_])ln[[:space:]]+(-[[:alnum:]]*s|--symbolic)' "$f" 2>/dev/null || return 1
	grep -Eqi ',,\}|\[:upper:\].*\[:lower:\]|A-Z.*a-z|tolower|case[-_ ]?fix|lowercase' "$f" 2>/dev/null
}

# environment of the original PZ start-server.sh (64 bit)
lg_java_env() {
	INSTDIR="$LG_SERVER"
	cd "${INSTDIR}" || return 1
	if "${INSTDIR}/jre64/bin/java" -version > /dev/null 2>&1; then
		echo "64-bit java detected"
		export PATH="${INSTDIR}/jre64/bin:$PATH"
		export LD_LIBRARY_PATH="${INSTDIR}/linux64:${INSTDIR}/natives:${INSTDIR}:${INSTDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
		JSIG="libjsig.so"
		return 0
	fi
	echo "couldn't determine 32/64 bit of java"
	return 1
}

# start exactly like the original file and end with "exit 0" like it
lg_exec_plain() {
	export LINUX_GUARD_ACTIVE=1
	if [ -n "$LG_NEXT" ]; then
		cd "$LG_SERVER" || exit 1
		if [ -x "$LG_NEXT" ]; then exec "$LG_NEXT" "$@"; else exec bash "$LG_NEXT" "$@"; fi
	fi
	if lg_java_env; then
		LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 "$@"
	fi
	exit 0
}

# --------------------------------------------------------------- case fix
LG_C_CREATED=0; LG_C_EXIST=0; LG_C_CONFLICT=0; LG_C_CI=0; LG_C_FAILED=0; LG_C_PRUNED=0; LG_C_OURS=0; LG_C_OTHER=0

# $1 = fix|check, $2 = root. Never renames, moves or overwrites anything.
lg_casefix_root() {
	local mode="$1" root="$2" entry name parent lower target
	local created=0 exist=0 conflict=0 ci=0 failed=0 pruned=0 ours=0 other=0
	if [ ! -d "$root" ]; then lg_say "skip (folder not found, ok if no mods there): $root"; return 0; fi
	if [ "$mode" = fix ]; then
		# remove only OUR links whose original is gone (mod update renamed or deleted it)
		while IFS= read -r -d '' entry; do
			if [ -L "$entry" ] && [ ! -e "$entry" ] && rm -f -- "$entry"; then pruned=$((pruned + 1)); fi
		done < <(LC_ALL=C find -P "$root" -type l -lname './*' -print0 2>/dev/null)
	fi
	while IFS= read -r -d '' entry; do
		name="${entry##*/}"
		parent="${entry%/*}"
		lower="${name,,}"
		[ "$name" = "$lower" ] && continue
		target="$parent/$lower"
		if [ -L "$target" ]; then
			exist=$((exist + 1))
		elif [ -e "$target" ]; then
			if [ "$entry" -ef "$target" ]; then ci=$((ci + 1)); else conflict=$((conflict + 1)); fi
		elif [ "$mode" = check ]; then
			created=$((created + 1))
		elif ln -s -- "./$name" "$target" 2>/dev/null; then
			created=$((created + 1))
		else
			failed=$((failed + 1))
		fi
	done < <(LC_ALL=C find -P "$root" -mindepth 1 \( -type f -o -type d \) -name '*[A-Z]*' -print0 2>/dev/null)
	ours=$(LC_ALL=C find -P "$root" -type l -lname './*' 2>/dev/null | wc -l)
	other=$(LC_ALL=C find -P "$root" -type l ! -lname './*' 2>/dev/null | wc -l)
	LG_C_CREATED=$((LG_C_CREATED + created)); LG_C_EXIST=$((LG_C_EXIST + exist)); LG_C_CONFLICT=$((LG_C_CONFLICT + conflict))
	LG_C_CI=$((LG_C_CI + ci)); LG_C_FAILED=$((LG_C_FAILED + failed)); LG_C_PRUNED=$((LG_C_PRUNED + pruned))
	LG_C_OURS=$((LG_C_OURS + ours)); LG_C_OTHER=$((LG_C_OTHER + other))
	local what="created"; [ "$mode" = check ] && what="missing"
	lg_say "$root: ${what}=$created present=$exist same-name-files=$conflict failed=$failed removed-stale=$pruned (links by Linux-Guard=$ours, other links=$other)"
	if [ "$ci" -gt 0 ]; then lg_say "$root: file system ignores upper/lower case here ($ci names) - nothing needed."; fi
}

LG_ROOTS=()
lg_roots() {
	LG_ROOTS=()
	if [ -n "${LG_SCAN_DIRS:-}" ]; then
		local IFS=':' d
		for d in $LG_SCAN_DIRS; do [ -n "$d" ] && LG_ROOTS+=("$d"); done
		return 0
	fi
	LG_ROOTS+=("$LG_SERVER/steamapps/workshop/content/108600")
	LG_ROOTS+=("$LG_ZOMBOID/mods")
}

# $1 = fix|check, $2 = label. Sets LG_C_* totals.
lg_casefix() {
	local mode="$1" label="$2" r
	LG_C_CREATED=0; LG_C_EXIST=0; LG_C_CONFLICT=0; LG_C_CI=0; LG_C_FAILED=0; LG_C_PRUNED=0; LG_C_OURS=0; LG_C_OTHER=0
	lg_roots
	for r in "${LG_ROOTS[@]}"; do lg_casefix_root "$mode" "$r"; done
	if [ "$mode" = fix ]; then
		lg_say "$label DONE created=$LG_C_CREATED present=$LG_C_EXIST failed=$LG_C_FAILED"
		if [ "$LG_C_CREATED" = 0 ] && [ "$LG_C_EXIST" -gt 0 ] && [ "$LG_C_OURS" = 0 ]; then
			lg_say "$label: another case fix already made all links - Linux-Guard changed nothing."
		fi
		if [ "$LG_C_FAILED" -gt 0 ]; then lg_say "$label WARNING: $LG_C_FAILED links could not be created (no write permission?)."; fi
	else
		lg_say "$label DONE missing=$LG_C_CREATED present=$LG_C_EXIST (check only, nothing written)"
	fi
}

# remove only links made by Linux-Guard (target "./Name" of a sibling)
lg_undo() {
	local r entry n=0 t
	lg_roots
	for r in "${LG_ROOTS[@]}"; do
		[ -d "$r" ] || continue
		while IFS= read -r -d '' entry; do
			t="$(readlink -- "$entry")"
			t="${t#./}"
			if [ "${t,,}" = "${entry##*/}" ] && [ "$t" != "${entry##*/}" ] && rm -f -- "$entry"; then n=$((n + 1)); fi
		done < <(LC_ALL=C find -P "$r" -type l -lname './*' -print0 2>/dev/null)
	done
	lg_say "undo: removed $n links made by Linux-Guard. Originals untouched."
}

# Zomboid user folder: -cachedir= argument, ProjectZomboid64.json, else ~/Zomboid
lg_zomboid_dir() {
	local a prev="" v=""
	for a in "$@"; do
		case "$a" in
			-cachedir=*) v="${a#-cachedir=}" ;;
			*) if [ "$prev" = "-cachedir" ]; then v="$a"; fi ;;
		esac
		prev="$a"
	done
	if [ -z "$v" ] && [ -n "${LG_ZOMBOID_DIR:-}" ]; then v="$LG_ZOMBOID_DIR"; fi
	if [ -z "$v" ] && [ -f "$LG_SERVER/ProjectZomboid64.json" ]; then
		v="$(grep -o 'deployment\.user\.cachedir=[^"]*' "$LG_SERVER/ProjectZomboid64.json" 2>/dev/null | head -n 1)"
		v="${v#deployment.user.cachedir=}"
		[ -n "$v" ] && v="${v%/}/Zomboid"
	fi
	if [ -z "$v" ]; then v="${HOME:-$(cd ~ 2>/dev/null && pwd)}/Zomboid"; fi
	case "$v" in /*) ;; *) v="$LG_SERVER/$v" ;; esac
	printf '%s\n' "${v%/}"
}

# --------------------------------------------------------------- supervised run
LG_TMP=""; LG_CHILD=""; LG_FWD=""; LG_STOPPING=0; LG_RESTARTING=0; LG_STOP_AT=0; LG_KILLED=0

# shellcheck disable=SC2329  # used by trap
lg_cleanup() {
	if [ -n "$LG_FWD" ]; then kill "$LG_FWD" 2>/dev/null; fi
	if [ -n "$LG_TMP" ]; then rm -rf -- "$LG_TMP"; fi
}

lg_console() { ( printf '%s\n' "$1" >&3 ) 2>/dev/null; }

# shellcheck disable=SC2329  # used by trap
lg_on_signal() {
	if [ "$LG_STOPPING" = 1 ]; then return 0; fi
	LG_STOPPING=1; LG_RESTARTING=0
	lg_say "stop signal ($1): sending \"quit\" to the server (saves the world)."
	lg_console "quit"
	LG_STOP_AT=$((SECONDS + LG_STOP_TIMEOUT))
}

lg_start_child() {
	local fifo="$LG_TMP/console"
	rm -f -- "$fifo"
	mkfifo "$fifo" || return 1
	: > "$LG_TMP/started"
	export LINUX_GUARD_ACTIVE=1
	if [ -n "$LG_NEXT" ]; then
		if [ -x "$LG_NEXT" ]; then "$LG_NEXT" "$@" < "$fifo" & else bash "$LG_NEXT" "$@" < "$fifo" & fi
	else
		LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 "$@" < "$fifo" &
	fi
	LG_CHILD=$!
	exec 3> "$fifo"
	# forward the console input of the host (panel, terminal) to the server
	cat <&4 >&3 2>/dev/null &
	LG_FWD=$!
}

lg_stop_child_hard() {
	if [ "$LG_KILLED" = 1 ]; then return 0; fi
	LG_KILLED=1
	lg_say "server did not stop within ${LG_STOP_TIMEOUT}s - sending SIGTERM."
	if command -v pkill > /dev/null 2>&1; then pkill -TERM -P "$LG_CHILD" 2>/dev/null; fi
	kill -TERM "$LG_CHILD" 2>/dev/null
}

lg_restart_allowed() {
	local m="$LG_STATE/last-auto-restart" last now
	[ "$LG_RESTARTS" -lt 1 ] || { lg_say "no automatic restart: already restarted once in this run (loop guard)."; return 1; }
	if [ -f "$m" ]; then
		last="$(head -n 1 "$m" 2>/dev/null)"; now="$(date +%s)"
		case "$last" in ''|*[!0-9]*) last=0 ;; esac
		if [ $((now - last)) -lt "$LG_RESTART_COOLDOWN" ]; then
			lg_say "no automatic restart: the last one was $((now - last))s ago (loop guard, LG_RESTART_COOLDOWN=${LG_RESTART_COOLDOWN}s)."
			return 1
		fi
	fi
	return 0
}

lg_supervise() {
	LG_RESTARTS=0
	local booted due console="$LG_ZOMBOID/server-console.txt" t0
	trap 'lg_on_signal TERM' TERM
	trap 'lg_on_signal INT' INT
	trap 'lg_on_signal HUP' HUP
	# keep the console input of the host (or /dev/null if there is none)
	{ exec 4<&0; } 2>/dev/null || exec 4</dev/null
	while :; do
		LG_STOPPING=0; LG_RESTARTING=0; LG_KILLED=0; booted=0; due=0
		lg_start_child "$@" || { lg_say "could not create the console pipe - plain start."; exec 4<&-; lg_exec_plain "$@"; }
		t0=$SECONDS
		while kill -0 "$LG_CHILD" 2>/dev/null; do
			sleep "$LG_POLL"
			if [ "$LG_STOPPING" = 1 ] || [ "$LG_RESTARTING" = 1 ]; then
				if [ "$SECONDS" -ge "$LG_STOP_AT" ]; then lg_stop_child_hard; fi
				continue
			fi
			if [ "$booted" = 0 ]; then
				if [ -f "$console" ] && [ "$console" -nt "$LG_TMP/started" ] && grep -q 'SERVER STARTED' "$console" 2>/dev/null; then
					booted=1
					lg_say "server started - checking mods that were downloaded during the boot."
					lg_casefix fix "after-boot"
					if [ "$LG_C_CREATED" -gt 0 ]; then
						if [ "$LG_AUTORESTART" = 1 ] && lg_restart_allowed; then
							due=$((SECONDS + LG_RESTART_DELAY))
							lg_say "$LG_C_CREATED new links for freshly downloaded mods: automatic restart in ${LG_RESTART_DELAY}s (once)."
							lg_console "servermsg \"Server restarts in ${LG_RESTART_DELAY} seconds (mod file fix, one time).\""
						else
							lg_say "$LG_C_CREATED new links made after the boot - they are used from the next server restart."
						fi
					fi
				elif [ $((SECONDS - t0)) -ge "$LG_BOOT_TIMEOUT" ]; then
					booted=1
					lg_say "no \"SERVER STARTED\" in $console after ${LG_BOOT_TIMEOUT}s - fixing links without restart."
					lg_casefix fix "late-check"
				fi
			fi
			if [ "$due" -gt 0 ] && [ "$SECONDS" -ge "$due" ]; then
				due=0; LG_RESTARTING=1; LG_RESTARTS=$((LG_RESTARTS + 1))
				date +%s > "$LG_STATE/last-auto-restart" 2>/dev/null
				lg_say "automatic restart: sending \"quit\" (saves the world)."
				lg_console "quit"
				LG_STOP_AT=$((SECONDS + LG_STOP_TIMEOUT))
			fi
		done
		wait "$LG_CHILD" 2>/dev/null
		exec 3>&-
		if [ -n "$LG_FWD" ]; then kill "$LG_FWD" 2>/dev/null; wait "$LG_FWD" 2>/dev/null; LG_FWD=""; fi
		if [ "$LG_RESTARTING" = 1 ] && [ "$LG_STOPPING" = 0 ]; then
			lg_say "server stopped - starting it again."
			lg_casefix fix "before-boot"
			continue
		fi
		break
	done
	exit 0
}

# --------------------------------------------------------------- main
LG_OS="${LG_UNAME:-$(uname -s 2>/dev/null)}"

if [ -n "$LG_SERVER" ]; then
	if [ -f "$LG_SERVER/start-server.sh" ] && ! [ "$LG_SERVER/start-server.sh" -ef "$LG_SELF" ] && ! lg_is_linux_guard "$LG_SERVER/start-server.sh"; then
		LG_NEXT="$LG_SERVER/start-server.sh"
	fi
	lg_setup_log "$LG_SERVER"
fi

case "${1:-}" in
	--linux-guard-check|--linux-guard-undo) LG_ACTION="$1"; shift ;;
	*) LG_ACTION="" ;;
esac

if [ "${LINUX_GUARD_ACTIVE:-0}" = 1 ] && [ -z "$LG_ACTION" ]; then
	# called again by a chained start script: just start
	LG_NEXT=""; lg_exec_plain "$@"
fi

if [ "$LG_OS" != "Linux" ]; then
	echo "${LG_TAG} ${LG_VERSION}: system is ${LG_OS:-unknown}, not Linux - no case fix needed, nothing changed."
	if [ -n "$LG_ACTION" ]; then exit 0; fi
	if [ -z "$LG_SERVER" ]; then
		echo "${LG_TAG} ProjectZomboid64 not found. On Windows start the server with StartServer64.bat."
		exit 0
	fi
	lg_exec_plain "$@"
fi

if [ -z "$LG_SERVER" ]; then
	echo "${LG_TAG} ERROR: ProjectZomboid64 not found next to this script or one folder above."
	echo "${LG_TAG} Put start-server.sh into the server main folder (next to ProjectZomboid64)."
	exit 1
fi

LG_ZOMBOID="$(lg_zomboid_dir "$@")"
LG_STATE="$LG_SERVER/.linux-guard"
mkdir -p "$LG_STATE" 2>/dev/null

if [ -z "$LG_ACTION" ]; then
	lg_say "Linux-Guard $LG_VERSION (Made by MKev) - server: $LG_SERVER, Zomboid: $LG_ZOMBOID${LG_NEXT:+, original start script: $LG_NEXT}"
fi

if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
	lg_say "bash ${BASH_VERSION} is too old for the case fix (needs 4+) - starting without it."
	[ -n "$LG_ACTION" ] && exit 1
	lg_exec_plain "$@"
fi

case "$LG_ACTION" in
	--linux-guard-check) lg_casefix check "check"; exit 0 ;;
	--linux-guard-undo) lg_undo; exit 0 ;;
esac

if [ "$LG_ENABLE" = 0 ]; then
	lg_say "disabled (LG_ENABLE=0) - plain start."
	lg_exec_plain "$@"
fi

if [ -n "$LG_NEXT" ] && lg_has_case_fix "$LG_NEXT"; then
	lg_say "the original start-server.sh already has its own case fix - Linux-Guard does nothing extra."
	lg_exec_plain "$@"
fi

lg_casefix fix "before-boot"

if [ "$LG_AUTORESTART" != 1 ]; then
	lg_say "automatic restart off (LG_AUTORESTART=$LG_AUTORESTART) - plain start."
	lg_exec_plain "$@"
fi

if [ -z "$LG_NEXT" ]; then
	lg_java_env || exit 0
else
	cd "$LG_SERVER" || exit 1
fi
if ! command -v mkfifo > /dev/null 2>&1 || ! LG_TMP="$(mktemp -d "${TMPDIR:-/tmp}/linux-guard.XXXXXX" 2>/dev/null)"; then
	lg_say "no mkfifo/mktemp - plain start without the after-boot check."
	LG_TMP=""; lg_exec_plain "$@"
fi
trap lg_cleanup EXIT
lg_supervise "$@"
