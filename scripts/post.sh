#!/system/bin/sh
# postinstall for seltos.convenience (v1.7.3)
# v1.7.1과 달라진 점: 각 단계의 성공/실패를 기록하고 토스트에 그대로 표시.
# 지도 검증이 끝내 실패하면 시스템 패치(install/apply)를 하지 않음.
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin
APP_DIR=/data/nemesis/apps/seltos.convenience
LOG=/data/local/tmp/seltos-suite-install.log
ST=/data/local/tmp/seltos-status.txt
log() { echo "[$(date '+%m-%d %H:%M:%S')] $*" | tee -a $LOG; }
toast() { am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1; }
step() { # step <이름> <명령...> : 결과를 기록하고 종료코드를 그대로 반환
    NAME="$1"; shift
    "$@" >> $LOG 2>&1; RC=$?
    log "$NAME rc=$RC"; echo "$NAME rc=$RC" >> $ST
    return $RC
}

: > $ST
log "=== 셀토스 편의 기능 패키지(v1.7.3) 설치 시작 ==="
for f in svc/autolaunch.sh bin/audio_toggle.sh bin/audio_on.sh bin/audio_off.sh bin/dsp_engine.sh bin/diag.sh bin/logger_toggle.sh svc/logger.sh; do chmod 755 "$APP_DIR/$f"; done

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
    mkdir -p /data/hmgapi/maps 2>/dev/null
    cp -r "$APP_DIR"/hmgapi/maps/* /data/hmgapi/maps/ 2>>$LOG

    if ! step "verify-map(1차)" hmgapid engine verify-map; then
        step "map-car --write" hmgapid engine map-car --write
        step "verify-map(2차)" hmgapid engine verify-map
        VM=$?
    else
        VM=0
    fi

    if [ "$VM" -ne 0 ]; then
        TBT="미적용(지도 검증 실패)"
        log "지도 검증 실패 -> 시스템 패치 중단"
    else
        step "remove(기존 모드)" hmgapid engine remove wireless-carplay-aa   # 없을 수 있음
        if step "install" hmgapid engine install "$APP_DIR/hmgapi/wireless-carplay-aa.zip"; then
            step "set tbt"    hmgapid engine set-setting wireless-carplay-aa tbt true
            step "set bridge" hmgapid engine set-setting wireless-carplay-aa bridge false
            step "set audio"  hmgapid engine set-setting wireless-carplay-aa audio false
            if step "apply" hmgapid engine apply; then
                TBT="적용 시도 성공(실제 TBT는 직결 시험으로 확인 필요)"
            else
                TBT="apply 실패"
            fi
        else
            TBT="install 실패"
        fi
    fi
fi
log "TBT 결과: $TBT"

sh "$APP_DIR/bin/dsp_engine.sh" enable >> $LOG 2>&1
if command -v tinymix >/dev/null 2>&1; then EQ="tinymix 있음"; else EQ="tinymix 없음-믹서 EQ 불가, asound.conf -5dB만(효과 미검증)"; fi
log "EQ 결과: $EQ"
echo "TBT: $TBT" >> $ST; echo "EQ: $EQ" >> $ST

toast "Suite v1.7.3 | TBT: $TBT | EQ: $EQ"
log "=== 설치 종료 ==="
exit 0
