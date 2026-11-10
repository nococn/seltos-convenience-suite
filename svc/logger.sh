#!/system/bin/sh
# Seltos Suite 로그 기록 서비스 v1.7.4
# 유선/동글 카플레이 중에는 진단 USB를 못 꽂으므로 logcat을 차 내부에 계속 남긴다.
# 용량 상한: 1MB x 4파일 순환. 상한을 걸 수 없으면(-r/-n 미지원) 기록하지 않고 사유만 남긴다.
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
TMPD="${SELTOS_TMP:-/data/local/tmp}"
OFF="$TMPD/seltos-logger.off"
PIDF="$TMPD/seltos-logger.pid"
ERRF="$TMPD/seltos-logger.err"
LOGF="$TMPD/seltos-logcat.log"

idle() { while :; do sleep 3600; done; }   # 서비스 재시작 루프 방지용 대기

is_logcat() { [ -n "$1" ] && [ -d "/proc/$1" ] && grep -q logcat "/proc/$1/cmdline" 2>/dev/null; }

[ -f "$OFF" ] && idle
if [ -f "$PIDF" ]; then
    OLD=$(cat "$PIDF" 2>/dev/null)
    is_logcat "$OLD" && idle           # 이미 실행 중
fi

logcat -v time -r 1024 -n 4 -f "$LOGF" &
LPID=$!
sleep 2
if ! is_logcat "$LPID"; then
    echo "[$(date)] logcat -r/-n 실행 실패 -> 용량 상한을 걸 수 없어 기록 안 함" > "$ERRF"
    rm -f "$PIDF"
    idle
fi
echo "$LPID" > "$PIDF"
wait "$LPID"
