#!/system/bin/sh
# preuninstall for seltos.convenience
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-uninstall.log
log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" >> $LOG; }

log "=== 셀토스 편의 패키지 삭제 시작 ==="

# 데몬 종료 (PID 파일 기반)
[ -f /data/local/tmp/cp-autolaunch.pid ] && kill $(cat /data/local/tmp/cp-autolaunch.pid) 2>/dev/null
[ -f /data/local/tmp/seltos-logger.pid ] && kill $(cat /data/local/tmp/seltos-logger.pid) 2>/dev/null
rm -f /data/local/tmp/cp-autolaunch.* /data/local/tmp/seltos-logger.*

# ALSA DSP EQ 해제 및 원복
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    sh "$APP_DIR/bin/dsp_engine.sh" disable >> $LOG 2>&1
fi

# HMG-API 모드 롤백 & 원래 프레임워크 적용
if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine remove wireless-carplay-aa >> $LOG 2>&1 || true
    hmgapid engine apply >> $LOG 2>&1 || true
fi

log "=== 삭제 완료 ==="
exit 0
