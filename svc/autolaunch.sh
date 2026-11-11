#!/system/bin/sh
# CarPlay Auto-Launch Daemon for Kia Seltos SP2PE (v1.8.1)
# Listens for CarPlay session establishment and brings CarPlay to foreground unless in Reverse gear
# Fixes in v1.8.1:
# - Replaced missing 'head' and 'cut' binaries with pure POSIX shell expansion
# - Added 60s cooldown and current-focus check to eliminate repeated 12s foreground looping

LOG=/data/local/tmp/cp-autolaunch.log
log() { echo "[$(date '+%m-%d %H:%M:%S')] [cp-autolaunch] $*" >> $LOG; }

log "CarPlay Auto-Launch service started (v1.8.1)"

# Wait for boot completion or minimum uptime without depending on 'cut'
while :; do
    BOOT=$(getprop sys.boot_completed 2>/dev/null)
    [ "$BOOT" = "1" ] && break
    UPTIME_RAW=$(cat /proc/uptime 2>/dev/null)
    UPTIME_SEC=${UPTIME_RAW%%.*}
    [ -n "$UPTIME_SEC" ] && [ "$UPTIME_SEC" -ge 40 ] 2>/dev/null && break
    sleep 2
done

log "System ready. Starting CarPlay event listener..."

# Clear logcat buffer to avoid reacting to stale events
logcat -c 2>/dev/null

LAST_LAUNCH=0

# Stream logcat for CarPlay connection indicators
logcat -v time -s CarPlay_:D Iap2Service:D DiPO:D BCMCanManager:D | while read -r line; do
    case "$line" in
        *"session_started"*|*"Session started"*|*"onSendConnected"*|*"CARPLAY_CONNECTED"*|*"isTMUCall_ring"*)
            # Debounce: avoid processing buffered lines repeatedly
            UPTIME_NOW=$(cat /proc/uptime 2>/dev/null)
            NOW_SEC=${UPTIME_NOW%%.*}
            NOW_SEC=${NOW_SEC:-0}
            
            DIFF=$((NOW_SEC - LAST_LAUNCH))
            if [ "$DIFF" -lt 60 ] && [ "$DIFF" -ge 0 ]; then
                continue
            fi
            
            # Check if CarPlay is already foreground focused
            if dumpsys window windows 2>/dev/null | grep -i 'mCurrentFocus' | grep -i 'carplay' >/dev/null; then
                continue
            fi
            
            log "CarPlay connection detected: $line"
            
            # Check if reverse camera is active (no 'head' dependency)
            CAM_ACTIVE=0
            for i in 1 2 3 4 5 6 7 8 9 10; do
                if dumpsys window windows 2>/dev/null | grep -i 'mCurrentFocus' | grep -iq "camera"; then
                    log "Reverse camera active, waiting ($i)..."
                    sleep 1
                    CAM_ACTIVE=1
                else
                    CAM_ACTIVE=0
                    break
                fi
            done
            
            [ "$CAM_ACTIVE" -eq 1 ] && continue
            
            sleep 1
            log "Bringing CarPlay to foreground..."
            am start -n com.hkmc.telematics.carplay/.CarPlayActivity >/dev/null 2>&1 || \
            am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n com.hkmc.telematics.carplay/com.hkmc.telematics.carplay.CarPlayActivity >/dev/null 2>&1
            
            LAST_LAUNCH=$NOW_SEC
            ;;
    esac
done
