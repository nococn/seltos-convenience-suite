#!/system/bin/sh
# postinstall for seltos.convenience
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log

log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }
notice() {
    log "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

log "=== 셀토스 편의 패키지 설치 시작 ==="

# 1. 실행 권한 부여
chmod 755 $APP_DIR/svc/autolaunch.sh
chmod 755 $APP_DIR/bin/install_apps.sh

# 2. HMG-API 모드(TBT 클러스터 연동 및 AAC 오디오) 설치
if command -v hmgapid >/dev/null 2>&1; then
    log "HMG-API 데몬 확인됨. TBT 및 오디오 모드 설치 시도..."
    
    # 지도 복사 (필요시)
    if [ -d $APP_DIR/hmgapi/maps ] && [ -d /data/hmgapi/maps ]; then
        cp -rn $APP_DIR/hmgapi/maps/* /data/hmgapi/maps/ 2>/dev/null
    fi
    
    # 모드 설치 및 적용
    hmgapid engine install $APP_DIR/hmgapi/wireless-carplay-aa.zip >> $LOG 2>&1
    hmgapid engine apply >> $LOG 2>&1
    log "HMG-API 모드 적용 완료."
fi

# 3. 카플레이 프로젝션 속성 확인
setprop persist.ium.support carplay

# 4. 번들 앱 자동 설치
if [ -d $APP_DIR/apps ]; then
    for APK in $APP_DIR/apps/*.apk; do
        if [ -f "$APK" ]; then
            log "번들 앱 설치: $APK"
            pm install -r "$APK" >> $LOG 2>&1
        fi
    done
fi

notice "셀토스 편의 기능 패키지가 성공적으로 설치되었습니다!"
log "=== 설치 완료 ==="
exit 0
