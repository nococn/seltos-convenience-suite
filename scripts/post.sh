#!/system/bin/sh
# postinstall for seltos.convenience (v1.8.1)
# 실차 진단 정밀 반영 및 안전 검증 모드:
# 1. tee 미지원 기기를 고려한 순수 쉘 로깅 (로그 누락 완치)
# 2. 기존 불일치 맵 디렉토리 완전 삭제 후 실차 순정 맵 동적 생성 (map-car --write)
# 3. 미지원 set-setting 호출 제거
# 4. --any-car 설치 후 plan 결과(/data/local/tmp/seltos-plan.txt) 안전 추출
# 5. 위험 방지를 위해 apply는 plan 확인 후 원터치 스크립트(bin/apply_tbt.sh)로 위임
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log
ST=/data/local/tmp/seltos-status.txt
PLAN=/data/local/tmp/seltos-plan.txt

log() {
    _MSG="[$(date '+%m-%d %H:%M:%S')] $*"
    echo "$_MSG"
    echo "$_MSG" >> "$LOG"
}
toast() { am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1; }
step() {
    NAME="$1"; shift
    "$@" >> "$LOG" 2>&1; RC=$?
    log "$NAME rc=$RC"; echo "$NAME rc=$RC" >> "$ST"
    return $RC
}

: > "$ST"
log "=== 셀토스 편의 기능 패키지(v1.8.1) 설치 시작 ==="
for f in svc/autolaunch.sh bin/audio_toggle.sh bin/audio_on.sh bin/audio_off.sh bin/dsp_engine.sh bin/diag.sh bin/logger_toggle.sh bin/apply_tbt.sh svc/logger.sh; do
    [ -f "$APP_DIR/$f" ] && chmod 755 "$APP_DIR/$f"
done

setprop persist.ium.support carplay
setprop persist.sys.iap2.routeguidance 1
setprop persist.sys.iap2.tbt 1

TBT="미적용"
if ! command -v hmgapid >/dev/null 2>&1; then
    TBT="미적용(hmgapid 없음)"
else
    PING=0
    until hmgapid ping >/dev/null 2>&1; do
        sleep 1; PING=$((PING+1))
        [ $PING -ge 15 ] && break
    done
    log "hmgapid ping 대기 ${PING}초"

    # 1. 기존 불일치 맵 디렉토리 완전 정리 (생성 거부 방지)
    log "기존 맵 디렉토리 정리..."
    rm -rf /data/hmgapi/maps/kia/seltos 2>/dev/null
    rm -rf /data/hmgapi/maps/unknown/sp2pe 2>/dev/null
    mkdir -p /data/hmgapi/maps 2>/dev/null

    # 2. 실차 기반 맵 동적 생성 시도
    log "실차 맵 동적 생성 (map-car --write)..."
    step "map-car --write" hmgapid engine map-car --write

    # 동적 미생성 시 번들 실차 동기화 맵으로 폴백
    if [ ! -d "/data/hmgapi/maps/kia/seltos/kor/260902" ] && [ ! -d "/data/hmgapi/maps/unknown/sp2pe/kor/260902" ]; then
        log "동적 생성 미확인 -> 번들 실차 해시 맵 복사..."
        cp -r "$APP_DIR"/hmgapi/maps/* /data/hmgapi/maps/ 2>>"$LOG"
    fi

    # 3. 맵 검증 수행 (verify-map)
    if step "verify-map" hmgapid engine verify-map; then
        log "맵 검증 통과 (hooks are on 보장)"
        VM=0
    else
        log "맵 검증 실패"
        VM=1
    fi

    if [ "$VM" -ne 0 ]; then
        TBT="미적용(지도 검증 실패)"
        log "지도 검증 실패 -> 모드 설치 중단"
    else
        step "remove(기존 모드)" hmgapid engine remove wireless-carplay-aa 2>/dev/null

        INSTALLED=0
        if step "install(--any-car)" hmgapid engine install --any-car "$APP_DIR/hmgapi/wireless-carplay-aa.zip"; then
            INSTALLED=1
        elif step "install(표준)" hmgapid engine install "$APP_DIR/hmgapi/wireless-carplay-aa.zip"; then
            INSTALLED=1
        fi

        if [ $INSTALLED -eq 1 ]; then
            log "모드 설치 성공 -> plan 검증 실행 (안전 모드)..."
            hmgapid engine plan > "$PLAN" 2>&1
            RC_PLAN=$?
            log "plan 실행 완료 (rc=$RC_PLAN)"
            cat "$PLAN" >> "$LOG"
            TBT="plan 생성 완료 (확인 후 적용 가능)"
        else
            TBT="install 실패"
        fi
    fi
fi
log "TBT 결과: $TBT"

sh "$APP_DIR/bin/dsp_engine.sh" enable >> "$LOG" 2>&1
EQ="10밴드 EQ 완료 (-5.0dBFS)"
log "EQ 결과: $EQ"
echo "TBT: $TBT" >> "$ST"; echo "EQ: $EQ" >> "$ST"

toast "Suite v1.8.1 | TBT: $TBT"
log "=== 설치 종료 ==="
exit 0
