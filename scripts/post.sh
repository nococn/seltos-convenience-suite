#!/system/bin/sh
# postinstall for seltos.convenience (v1.7.0)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log

log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }
notice() {
    log "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

log "=== 셀토스 편의 기능 패키지(v1.7.0) 설치 시작 ==="

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
    log "HMG-API 데몬 확인됨. 응답 대기 중..."
    
    # 데몬 응답 대기 (ping 루프)
    PING_COUNT=0
    until hmgapid ping >/dev/null 2>&1; do
        sleep 1
        PING_COUNT=$((PING_COUNT + 1))
        if [ $PING_COUNT -ge 15 ]; then
            log "HMG-API 데몬 ping 타임아웃 (15초 경과)"
            break
        fi
    done
    log "HMG-API 데몬 준비 완료 (ping 대기: ${PING_COUNT}초)"
    
    # 순정 맵 복사: unknown/sp2pe/kor/260902 및 kia/seltos/kor/260902 양방향 배포
    if [ -d "$APP_DIR/hmgapi/maps" ]; then
        mkdir -p /data/hmgapi/maps 2>/dev/null || true
        cp -r $APP_DIR/hmgapi/maps/* /data/hmgapi/maps/ 2>/dev/null || true
        log "HMG-API 순정 맵 복사 완료 (/data/hmgapi/maps/)"
    fi
    
    # 맵 유효성 검증 및 map-car --write 폴백
    log "HMG-API 맵 유효성 검증(verify-map) 수행..."
    if ! hmgapid engine verify-map >> $LOG 2>&1; then
        log "맵 검증 실패 감지 -> 실차 바이너리 기반 훅 지도 자동 생성(map-car --write) 실행..."
        hmgapid engine map-car --write >> $LOG 2>&1 || true
        hmgapid engine verify-map >> $LOG 2>&1 || true
    else
        log "HMG-API 맵 유효성 검증 정상 통과"
    fi
    
    # wireless-carplay-aa 모드 클린 설치 및 TBT 단독 적용
    if [ -f "$APP_DIR/hmgapi/wireless-carplay-aa.zip" ]; then
        log "기존 모드 서명 충돌 방지 클린 제거..."
        hmgapid engine remove wireless-carplay-aa >> $LOG 2>&1 || true
        hmgapid engine apply >> $LOG 2>&1 || true
        
        log "SP2PE TBT 엔진 모드 클린 인스톨..."
        hmgapid engine install "$APP_DIR/hmgapi/wireless-carplay-aa.zip" >> $LOG 2>&1 || true
        
        # 무선 핫스팟/브릿지 배제, 유선/동글 순수 계기판 TBT 훅만 강제 활성화
        hmgapid engine set-setting wireless-carplay-aa tbt true >> $LOG 2>&1 || true
        hmgapid engine set-setting wireless-carplay-aa bridge false >> $LOG 2>&1 || true
        hmgapid engine set-setting wireless-carplay-aa audio false >> $LOG 2>&1 || true
        
        log "HMG-API 모드 엔진 최종 적용(apply)..."
        hmgapid engine apply >> $LOG 2>&1 || true
        log "HMG-API DiPO TBT 훅 엔진 적용 완료."
    fi
fi

# 4. ALSA DSP 10밴드 파라메트릭 EQ 기본 활성화
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    log "기본 6스피커 맞춤 ALSA DSP 10밴드 파라메트릭 EQ 적용..."
    sh "$APP_DIR/bin/dsp_engine.sh" enable >> $LOG 2>&1
fi

notice "셀토스 계기판 TBT & 10밴드 DSP 패키지(v1.7.0) 설치 완료!"
log "=== 설치 완료 ==="
exit 0
