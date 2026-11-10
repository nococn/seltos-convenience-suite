#!/system/bin/sh
# postinstall for seltos.convenience (v1.5.0)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log

log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }
notice() {
    log "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

log "=== 셀토스 편의 기능 패키지(v1.5.0) 설치 시작 ==="

# 1. 실행 권한 부여
chmod 755 $APP_DIR/svc/autolaunch.sh
chmod 755 $APP_DIR/bin/audio_toggle.sh
chmod 755 $APP_DIR/bin/audio_on.sh
chmod 755 $APP_DIR/bin/audio_off.sh
chmod 755 $APP_DIR/bin/dsp_engine.sh

# 2. 카플레이 프로젝션 및 iAP2 라우트 가이던스(TBT) 속성 활성화
setprop persist.ium.support carplay
setprop persist.sys.iap2.routeguidance 1
setprop persist.sys.iap2.tbt 1

# 3. HMG-API DiPO 계기판 TBT 연동 모드 설치 (무선 핫스팟 배제, 순수 유선/동글 TBT 전용)
if command -v hmgapid >/dev/null 2>&1; then
    log "HMG-API 데몬 확인됨. 셀토스 전용 계기판 TBT 훅 연동 시작..."
    
    # 셀토스 SP2PE 맵 등록
    if [ -d "$APP_DIR/hmgapi/maps" ]; then
        mkdir -p /data/hmgapi/maps 2>/dev/null || true
        cp -r $APP_DIR/hmgapi/maps/* /data/hmgapi/maps/ 2>/dev/null || true
    fi
    
    # 맵 검증 및 모드 적용
    if [ -f "$APP_DIR/hmgapi/wireless-carplay-aa.zip" ]; then
        hmgapid engine verify-map >> $LOG 2>&1 || true
        hmgapid engine install "$APP_DIR/hmgapi/wireless-carplay-aa.zip" >> $LOG 2>&1 || true
        
        # 무선 핫스팟/브릿지 배제, 유선/동글 순수 계기판 TBT 훅만 강제 활성화
        hmgapid engine set-setting wireless-carplay-aa tbt true >> $LOG 2>&1 || true
        hmgapid engine set-setting wireless-carplay-aa bridge false >> $LOG 2>&1 || true
        hmgapid engine set-setting wireless-carplay-aa audio false >> $LOG 2>&1 || true
        hmgapid engine apply >> $LOG 2>&1 || true
        log "HMG-API DiPO TBT 훅 엔진 적용 완료."
    fi
fi

# 4. ALSA DSP 10밴드 파라메트릭 EQ 기본 활성화
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    log "기본 6스피커 맞춤 ALSA DSP 10밴드 파라메트릭 EQ 적용..."
    sh "$APP_DIR/bin/dsp_engine.sh" enable >> $LOG 2>&1
fi

notice "셀토스 계기판 TBT & 10밴드 DSP 패키지(v1.5.0) 설치 완료!"
log "=== 설치 완료 ==="
exit 0
