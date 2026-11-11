#!/system/bin/sh
# TBT Mode System Apply Script (v1.8.1)
# Plan 검증 후 시스템 프레임워크에 TBT 훅을 정식 적용(apply)하는 스크립트
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
HMGAPI=/data/nemesis/bin/hmgapid
LOG=/data/local/tmp/seltos-apply.log

toast() {
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

echo "[$(date)] === TBT Apply Execution ===" > "$LOG"

if [ ! -x "$HMGAPI" ]; then
    echo "[$(date)] HMG-API 바이너리 없음: $HMGAPI" >> "$LOG"
    toast "TBT 적용 실패: HMG-API 데몬 없음"
    exit 1
fi

echo "[$(date)] 실행: $HMGAPI apply" >> "$LOG"
$HMGAPI apply >> "$LOG" 2>&1
RC=$?

echo "[$(date)] 종료 코드: $RC" >> "$LOG"

if [ $RC -eq 0 ]; then
    toast "TBT 적용 완료 (rc=0) - 헤드유닛 핀홀 재부팅 필수"
else
    toast "TBT 적용 실패 (rc=$RC) - 진단 수집 필요"
fi

exit $RC
