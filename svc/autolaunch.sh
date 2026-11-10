#!/system/bin/sh
# CarPlay Auto-Launch Daemon for Kia Seltos SP2PE
# Listens for CarPlay session establishment and brings CarPlay to foreground unless in Reverse gear

LOG=/data/local/tmp/cp-autolaunch.log
log() { echo "[$(date '+%m-%d %H:%M:%S')] [cp-autolaunch] $*" >> $LOG; }

log "CarPlay Auto-Launch service started"

# Wait for boot completion or minimum uptime
until [ "$(getprop sys.boot_completed)" = "1" ] || [ $(cut -d. -f1 /proc/uptime) -ge 40 ]; do
    sleep 2
done

log "System ready. Starting CarPlay event listener..."

# Clear logcat buffer to avoid reacting to stale events
logcat -c 2>/dev/null

# Stream logcat for CarPlay connection indicators
logcat -v time -s CarPlay_:D Iap2Service:D DiPO:D BCMCanManager:D | while read -r line; do
    case "$line" in
        *"session_started"*|*"Session started"*|*"onSendConnected"*|*"CARPLAY_CONNECTED"*|*"isTMUCall_ring"*)
            log "CarPlay connection detected: $line"
            
            # Check if reverse camera is currently active
            for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30; do
                TOP=$(dumpsys window windows 2>/dev/null | grep -E 'mCurrentFocus|mFocusedApp' | head -n 1)
                if echo "$TOP" | grep -iq "camera"; then
                    log "Reverse camera active, waiting ($i)..."
                    sleep 1
                else
                    break
                fi
            done
            
            # Settle delay
            sleep 1
            
            log "Bringing CarPlay to foreground..."
            am start -n com.hkmc.telematics.carplay/.CarPlayActivity >/dev/null 2>&1 || \
            am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n com.hkmc.telematics.carplay/com.hkmc.telematics.carplay.CarPlayActivity >/dev/null 2>&1
            
            # Debounce
            sleep 10
            ;;
    esac
done
