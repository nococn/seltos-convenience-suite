#!/system/bin/sh
# preuninstall for seltos.convenience (v1.5.0)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-uninstall.log
log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }

log "=== 셀토스 편의 패키지 삭제 시작 ==="

# 데몬 종료
pkill -f autolaunch.sh 2>/dev/null

# ALSA DSP EQ 해제 및 원복
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    sh "$APP_DIR/bin/dsp_engine.sh" disable >> $LOG 2>&1
fi

# HMG-API 모드 롤백
if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine remove wireless-carplay-aa >> $LOG 2>&1 || true
    hmgapid engine apply >> $LOG 2>&1 || true
fi

pkill -HUP mediaserver 2>/dev/null

log "=== 삭제 완료 ==="
exit 0
