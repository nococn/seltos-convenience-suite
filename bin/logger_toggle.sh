#!/system/bin/sh
# 로그 기록 켜기/끄기(끌 때 기록 삭제)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
APP_DIR=/data/nemesis/apps/seltos.convenience
TMPD="${SELTOS_TMP:-/data/local/tmp}"
OFF="$TMPD/seltos-logger.off"; PIDF="$TMPD/seltos-logger.pid"; LOGF="$TMPD/seltos-logcat.log"
toast() { echo "$*"; am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1; }

RUNNING=0
if [ -f "$PIDF" ]; then
    P=$(cat "$PIDF" 2>/dev/null)
    [ -n "$P" ] && [ -d "/proc/$P" ] && RUNNING=1
fi

if [ "$RUNNING" = "1" ]; then
    : > "$OFF"
    kill "$P" 2>/dev/null
    pkill -f "logcat.*seltos-logcat" 2>/dev/null
    rm -f "$PIDF" "$LOGF" "$LOGF".1 "$LOGF".2 "$LOGF".3 "$LOGF".4
    toast "📝 로그 기록 끔 (기록 삭제됨)"
else
    rm -f "$OFF"
    sh "$APP_DIR/svc/logger.sh" >/dev/null 2>&1 &
    toast "📝 로그 기록 켬 (최대 약 4MB 순환)"
fi
exit 0
