#!/system/bin/sh
# postinstall for seltos.convenience (v1.7.6)
# 실차 진단 피드백 3대 원칙 100% 정석 구현:
# 1. 패키지 지도 전면 제외 -> 차내에서 map-car --write로 실차 순정 맵 동적 생성 후 verify-map
# 2. 모드를 --any-car로 설치하고 절대 apply하지 않고 plan 결과(/data/local/tmp/seltos-plan.txt)만 안전 수집
# 3. tee/head/cut 부재 환경을 고려한 순수 쉘 로깅 및 미지원 명령어(set-setting) 전면 배제
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log
ST=/data/local/tmp/seltos-status.txt
PLAN=/data/local/tmp/seltos-plan.txt
VM_OUT=/data/local/tmp/seltos-verify-map.txt

log() {
    _MSG="[$(date '+%m-%d %H:%M:%S')] $*"
    echo "$_MSG"
    echo "$_MSG" >> "$LOG"
}
toast() { am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1; }

: > "$ST"
: > "$LOG"
log "=== 셀토스 편의 기능 패키지(v1.7.6) 설치 시작 ==="

for f in svc/autolaunch.sh bin/audio_toggle.sh bin/audio_on.sh bin/audio_off.sh bin/dsp_engine.sh bin/diag.sh bin/logger_toggle.sh svc/logger.sh; do
    [ -f "$APP_DIR/$f" ] && chmod 755 "$APP_DIR/$f"
done

setprop persist.ium.support carplay
setprop persist.sys.iap2.routeguidance 1
setprop persist.sys.iap2.tbt 1

TBT="미적용"
if ! command -v hmgapid >/dev/null 2>&1; then
    TBT="미적용(hmgapid 없음)"
    log "$TBT"
else
    PING=0
    until hmgapid ping >/dev/null 2>&1; do
        sleep 1; PING=$((PING+1))
        [ $PING -ge 15 ] && break
    done
    log "hmgapid ping 대기 ${PING}초"

    # 1. 기존 불일치/가짜 맵 디렉토리 완전 삭제 (map-car 충돌 방지)
    log "기존 맵 디렉토리 정리 (kia/seltos, unknown/sp2pe)..."
    rm -rf /data/hmgapi/maps/kia/seltos 2>/dev/null
    rm -rf /data/hmgapi/maps/unknown/sp2pe 2>/dev/null
    mkdir -p /data/hmgapi/maps 2>/dev/null

    # 2. 실차 프레임워크 기반 맵 동적 생성 (map-car --write)
    log "실차 맵 동적 생성 실행: hmgapid engine map-car --write"
    hmgapid engine map-car --write > /data/local/tmp/seltos-map-car.log 2>&1
    RC_MC=$?
    log "map-car --write 종료코드: $RC_MC"
    cat /data/local/tmp/seltos-map-car.log >> "$LOG"

    # 3. 맵 검증 수행 (verify-map)
    log "실차 맵 검증 실행: hmgapid engine verify-map"
    hmgapid engine verify-map > "$VM_OUT" 2>&1
    RC_VM=$?
    log "verify-map 종료코드: $RC_VM"
    cat "$VM_OUT" >> "$LOG"

    if [ $RC_VM -ne 0 ]; then
        TBT="실패 (지도 검증 rc=$RC_VM)"
        log "지도 검증 실패 -> 모드 설치 및 plan 중단"
    else
        log "지도 검증 통과 (hooks are on 정상)"
        
        # 4. 기존 모드 정리 후 --any-car 설치
        hmgapid engine remove wireless-carplay-aa >/dev/null 2>&1
        log "모드 설치 실행: hmgapid engine install --any-car"
        hmgapid engine install --any-car "$APP_DIR/hmgapi/wireless-carplay-aa.zip" > /data/local/tmp/seltos-install.log 2>&1
        RC_INST=$?
        log "install --any-car 종료코드: $RC_INST"
        cat /data/local/tmp/seltos-install.log >> "$LOG"

        if [ $RC_INST -eq 0 ]; then
            # 5. 안전 Plan 결과 수집 (apply는 실행하지 않음)
            log "안전 Plan 실행: hmgapid engine plan"
            hmgapid engine plan > "$PLAN" 2>&1
            RC_PLAN=$?
            log "plan 종료코드: $RC_PLAN"
            cat "$PLAN" >> "$LOG"
            
            if [ $RC_PLAN -eq 0 ]; then
                TBT="성공 (plan rc=0, USB 진단 수집 대기)"
            else
                TBT="실패 (plan rc=$RC_PLAN)"
            fi
        else
            TBT="실패 (install rc=$RC_INST)"
        fi
    fi
fi

log "TBT 결과: $TBT"
echo "TBT: $TBT" >> "$ST"

sh "$APP_DIR/bin/dsp_engine.sh" enable >> "$LOG" 2>&1
EQ="설정 파일 배치 완료 (DSP 직결 환경)"
log "EQ 결과: $EQ"
echo "EQ: $EQ" >> "$ST"

toast "Suite v1.7.6 | TBT: $TBT"
log "=== 설치 종료 ==="
exit 0
