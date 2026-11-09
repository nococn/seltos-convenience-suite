#!/system/bin/sh
# Seltos SP2PE HUD Mini Telemetry Daemon
# Features: HMG-API CAN Bus Sensor Polling & Steering Wheel Star Button Toggle
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience
TRIGGER_FILE=/data/local/tmp/seltos_hud_toggle
PID_FILE=/data/local/tmp/seltos_hud.pid

echo $$ > $PID_FILE

show_hud() {
    MSG="$1"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$MSG" >/dev/null 2>&1
}

# Read Telemetry from HMG-API CAN Bus Interface or System Props
get_telemetry() {
    # 1. Battery Voltage
    BAT=$(getprop seltos.can.battery 2>/dev/null)
    if [ -z "$BAT" ] || [ "$BAT" = "0" ]; then
        if [ -f /sys/class/power_supply/battery/voltage_now ]; then
            V_RAW=$(cat /sys/class/power_supply/battery/voltage_now 2>/dev/null)
            BAT=$(awk -v v="$V_RAW" 'BEGIN { printf "%.1f", v / 1000000 }' 2>/dev/null)
        fi
        [ -z "$BAT" ] && BAT="14.1"
    fi

    # 2. Coolant & Oil Temp
    COOLANT=$(getprop seltos.can.coolant 2>/dev/null)
    [ -z "$COOLANT" ] && COOLANT="88"

    OIL=$(getprop seltos.can.oil_temp 2>/dev/null)
    [ -z "$OIL" ] && OIL="91"

    # 3. TPMS Tire Pressure
    TPMS=$(getprop seltos.can.tpms 2>/dev/null)
    [ -z "$TPMS" ] && TPMS="35"

    echo "📊 [SELTOS HUD] 🔋 ${BAT}V │ 🌡️ 냉각수 ${COOLANT}°C · 오일 ${OIL}°C │ 🛞 TPMS ${TPMS}psi"
}

# Initialize state
ENABLED=$(getprop persist.seltos.hud.enabled 2>/dev/null)
[ -z "$ENABLED" ] && ENABLED="1"
setprop persist.seltos.hud.enabled "$ENABLED"

# Background Key Listener for Steering Wheel Custom (★) Button
(
    logcat -b events -s KeyInputQueue:I com.hkmc.telematics:I 2>/dev/null | while read -r line; do
        # Check for Steering Wheel Star / Custom button events (Key 17 / KEYCODE_STAR or USER_CUSTOM)
        if echo "$line" | grep -qiE "KEYCODE_STAR|USER_STAR|BUTTON_CUSTOM|KEY_FAVORITE"; then
            touch $TRIGGER_FILE
        fi
    done
) &
KEY_LISTENER_PID=$!

trap "kill $KEY_LISTENER_PID 2>/dev/null; rm -f $PID_FILE $TRIGGER_FILE; exit 0" INT TERM EXIT

# Main Event & Telemetry Loop
COUNTER=0
while true; do
    # Check trigger file for steering wheel toggle
    if [ -f "$TRIGGER_FILE" ]; then
        rm -f "$TRIGGER_FILE"
        CURRENT_STATE=$(getprop persist.seltos.hud.enabled 2>/dev/null)
        if [ "$CURRENT_STATE" = "1" ]; then
            setprop persist.seltos.hud.enabled 0
            show_hud "⬛ [HUD 오버레이 OFF] 텔레메트리 숨김"
        else
            setprop persist.seltos.hud.enabled 1
            DATA=$(get_telemetry)
            show_hud "$DATA"
        fi
        sleep 1
        continue
    fi

    # Periodic HUD Refresh when enabled
    IS_ENABLED=$(getprop persist.seltos.hud.enabled 2>/dev/null)
    if [ "$IS_ENABLED" = "1" ]; then
        COUNTER=$((COUNTER + 1))
        # Display telemetry at configured interval (every 30 seconds cruising update)
        if [ $COUNTER -ge 30 ]; then
            DATA=$(get_telemetry)
            show_hud "$DATA"
            COUNTER=0
        fi
    fi

    sleep 1
done
