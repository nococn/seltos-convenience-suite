#!/system/bin/sh
# Seltos Suite 로그 기록 서비스 v1.7.3
# 유선/동글 카플레이 중에는 진단 USB를 못 꽂으므로 logcat을 차 내부에 계속 남긴다.
# 용량 상한: 1MB x 4파일 순환 (최대 약 4MB). 끄기: 앱 "로그 기록 켜기/끄기(삭제)".
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
TMPD="${SELTOS_TMP:-/data/local/tmp}"
OFF="$TMPD/seltos-logger.off"
PIDF="$TMPD/seltos-logger.pid"
LOGF="$TMPD/seltos-logcat.log"

idle() { while :; do sleep 3600; done; }   # 서비스 재시작 루프 방지용 대기

[ -f "$OFF" ] && idle
if [ -f "$PIDF" ]; then
    OLD=$(cat "$PIDF" 2>/dev/null)
    [ -n "$OLD" ] && [ -d "/proc/$OLD" ] && idle      # 이미 실행 중
fi
echo $$ > "$PIDF"
if ! logcat -v time -r 1024 -n 4 -f "$LOGF"; then
    exec logcat -v time -f "$LOGF"
fi
