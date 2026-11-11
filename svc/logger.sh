#!/system/bin/sh
# Seltos Suite 로그 기록 서비스 v1.8.1
# 유선/동글 카플레이 중에는 진단 USB를 못 꽂으므로 logcat을 차 내부에 계속 남긴다.
# v1.8.1: 킷캣(Android 4.4.2) logcat -r/-n 실패 시 필터링 logcat 폴백 실장
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
TMPD="${SELTOS_TMP:-/data/local/tmp}"
OFF="$TMPD/seltos-logger.off"
PIDF="$TMPD/seltos-logger.pid"
ERRF="$TMPD/seltos-logger.err"
LOGF="$TMPD/seltos-logcat.log"

idle() { while :; do sleep 3600; done; }

is_alive() { [ -n "$1" ] && kill -0 "$1" 2>/dev/null; }

[ -f "$OFF" ] && idle
if [ -f "$PIDF" ]; then
    OLD=$(cat "$PIDF" 2>/dev/null)
    is_alive "$OLD" && idle
fi

# 순환 logcat (-r, -n) 시도
logcat -v time -r 1024 -n 4 -f "$LOGF" >/dev/null 2>&1 &
LPID=$!
sleep 2

if ! is_alive "$LPID"; then
    echo "[$(date)] logcat -r/-n 미지원 또는 실패. TBT/CarPlay 전용 필터링 logcat으로 폴백..." > "$ERRF"
    # TBT 및 카플레이 관련 태그만 필터링하여 파일 비대화 방지
    logcat -v time -s CarPlay_:D Iap2Service:D DiPO:D NavigationCluster:D BCMCanManager:D -f "$LOGF" >/dev/null 2>&1 &
    LPID=$!
    sleep 2
    if ! is_alive "$LPID"; then
        echo "[$(date)] 폴백 logcat 실행 실패." >> "$ERRF"
        rm -f "$PIDF"
        idle
    fi
fi

echo "$LPID" > "$PIDF"
wait "$LPID"
