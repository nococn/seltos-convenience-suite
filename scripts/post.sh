#!/system/bin/sh
# postinstall for seltos.convenience (v1.4.0)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log

log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }
notice() {
    log "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

log "=== 셀토스 음향 DSP 튜닝 패키지 설치 시작 ==="

# 1. 실행 권한 부여
chmod 755 $APP_DIR/svc/autolaunch.sh
chmod 755 $APP_DIR/bin/audio_toggle.sh
chmod 755 $APP_DIR/bin/audio_on.sh
chmod 755 $APP_DIR/bin/audio_off.sh
chmod 755 $APP_DIR/bin/dsp_engine.sh

# 2. 카플레이 프로젝션 속성 확인
setprop persist.ium.support carplay

# 3. ALSA DSP 10밴드 파라메트릭 EQ 기본 활성화
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    log "기본 6스피커 맞춤 ALSA DSP 10밴드 파라메트릭 EQ 적용..."
    sh "$APP_DIR/bin/dsp_engine.sh" enable >> $LOG 2>&1
fi

notice "셀토스 6스피커 맞춤 ALSA DSP 10밴드 EQ 패키지(v1.4.0)가 설치되었습니다!"
log "=== 설치 완료 ==="
exit 0
