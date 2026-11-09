#!/system/bin/sh
# HUD Mini Telemetry Manual Toggle Script (Steering Wheel Star Button Shortcut)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

TRIGGER_FILE=/data/local/tmp/seltos_hud_toggle

# Trigger daemon toggle
touch "$TRIGGER_FILE"

CURRENT=$(getprop persist.seltos.hud.enabled 2>/dev/null)
if [ "$CURRENT" = "1" ]; then
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "⬛ [HUD 오버레이 OFF] 텔레메트리 표시를 숨깁니다." >/dev/null 2>&1
else
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "📊 [HUD 오버레이 ON] 배터리: 14.1V │ 냉각수: 88°C │ TPMS: 35psi" >/dev/null 2>&1
fi

exit 0
