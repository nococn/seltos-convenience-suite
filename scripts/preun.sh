#!/system/bin/sh
# preuninstall for seltos.convenience
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

LOG=/data/local/tmp/seltos-suite-uninstall.log
log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }

log "=== 셀토스 편의 패키지 삭제 시작 ==="

# autolaunch 데몬 종료
pkill -f autolaunch.sh 2>/dev/null

# HMG-API 모드 롤백
if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine remove wireless-carplay-aa >> $LOG 2>&1
    hmgapid engine apply >> $LOG 2>&1
fi

log "=== 삭제 완료 ==="
exit 0
