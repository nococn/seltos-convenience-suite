#!/system/bin/sh
# Seltos Suite 진단 수집 v1.7.4
# 이 헤드유닛(Android 4.4.2)에는 head/tail이 없어서 순수 쉘로 대체함.
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
OUT=/data/local/tmp/seltos-diag.txt
TMP=/data/local/tmp/seltos-diag.tmp

sec() { echo; echo "##### $*"; }

# 파일 마지막 N줄 (tail 대체)
tailn() {
    N="$1"; F="$2"
    [ -f "$F" ] || { echo "(파일 없음: $F)"; return; }
    TOTAL=0
    while IFS= read -r _l; do TOTAL=$((TOTAL+1)); done < "$F"
    SKIP=$((TOTAL-N)); I=0
    while IFS= read -r _l; do
        I=$((I+1)); [ $I -gt $SKIP ] && echo "$_l"
    done < "$F"
}
# 파일 처음 N줄 (head 대체)
headn() {
    N="$1"; F="$2"; I=0
    [ -f "$F" ] || { echo "(파일 없음: $F)"; return; }
    while IFS= read -r _l; do
        I=$((I+1)); [ $I -gt $N ] && break; echo "$_l"
    done < "$F"
}
# 명령 실행: 출력과 종료코드를 같이 기록
run() {
    "$@" > "$TMP" 2>&1; RC=$?
    headn 60 "$TMP"; echo "(rc=$RC)"
}

{
sec "date/build";  date; getprop ro.build.fingerprint; getprop ro.build.version.release
sec "which";       for t in cat grep sed awk wc head tail tinymix tinyplay logcat hmgapid busybox toolbox; do P=$(command -v $t 2>/dev/null); echo "$t: ${P:-NOT FOUND}"; done
sec "props";       getprop | grep -E "seltos|iap2|ium|hmg|carplay|tbt|route"
sec "hmgapid";     command -v hmgapid
echo "-- hmgapid ping";          run hmgapid ping
echo "-- hmgapid engine list";   run hmgapid engine list
echo "-- hmgapid engine verify-map (읽기 전용 확인)"; run hmgapid engine verify-map
sec "hmgapi dirs"; ls -l /data/hmgapi 2>&1; ls -l /data/hmgapi/maps 2>&1; ls -R /data/hmgapi/maps/kia/seltos 2>&1
sec "hmgapi logs"; for f in /data/hmgapi/log /data/hmgapi/logs /data/hmgapi/hmgapid.log /data/local/tmp/hmgapid.log; do [ -e "$f" ] && { echo "== $f"; ls -l "$f"; [ -f "$f" ] && tailn 60 "$f"; }; done
sec "asound";      cat /proc/asound/cards 2>&1; ls /proc/asound 2>&1; ls -l /data/local/asound.conf 2>&1; cat /data/local/asound.conf 2>&1
sec "audio libs";  ls /system/lib/hw 2>&1 | grep -i -E "audio|tinyalsa" ; ls /system/lib 2>&1 | grep -i -E "alsa|tinyalsa"; ls /system/etc 2>&1 | grep -i -E "audio|mixer|asound"
sec "install log"; tailn 150 /data/local/tmp/seltos-suite-install.log
sec "status";      tailn 40 /data/local/tmp/seltos-status.txt
sec "dsp log";     tailn 40 /data/local/tmp/seltos-dsp-status.log
sec "logger status"; ls -l /data/local/tmp/seltos-logger.* 2>&1; [ -f /data/local/tmp/seltos-logger.err ] && cat /data/local/tmp/seltos-logger.err 2>&1
sec "plan status";   [ -f /data/local/tmp/seltos-plan.txt ] && cat /data/local/tmp/seltos-plan.txt 2>&1
sec "autolaunch";  tailn 40 /data/local/tmp/cp-autolaunch.log
sec "내부 logcat 기록 (seltos-logcat.log*, 유선 시험 중 기록분)"
LF=/data/local/tmp/seltos-logcat.log
ls -l $LF $LF.1 $LF.2 $LF.3 2>&1
grep -i -E "iap2|routeguid|route_guid|tbt|guidance|hmgapi|dipo|carplay" $LF.3 $LF.2 $LF.1 $LF > "$TMP.2" 2>/dev/null
tailn 400 "$TMP.2"
sec "현재 logcat 버퍼(보조)"
logcat -d -v time > "$TMP" 2>&1
grep -i -E "iap2|routeguid|route_guid|tbt|guidance|hmgapi|dipo|carplay" "$TMP" > "$TMP.2" 2>&1
tailn 150 "$TMP.2"
} > "$OUT" 2>&1
rm -f "$TMP" "$TMP.2"

for d in /storage/*/ /mnt/media_rw/*/ /mnt/udisk/ /udisk/ /mnt/usb*/ /storage/usbdisk*/; do
    if [ -d "$d" ] && [ -w "$d" ]; then
        cp "$OUT" "${d}seltos-diag.txt" 2>/dev/null
        [ -f /data/local/tmp/seltos-plan.txt ] && cp /data/local/tmp/seltos-plan.txt "${d}seltos-plan.txt" 2>/dev/null
        [ -f /data/local/tmp/seltos-logger.err ] && cp /data/local/tmp/seltos-logger.err "${d}seltos-logger.err" 2>/dev/null
        for n in "" .1 .2 .3; do [ -f "/data/local/tmp/seltos-logcat.log$n" ] && cp "/data/local/tmp/seltos-logcat.log$n" "${d}seltos-logcat${n}.txt" 2>/dev/null; done
    fi
done
am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "진단 저장 완료: seltos-diag.txt (USB 루트)" >/dev/null 2>&1
exit 0
