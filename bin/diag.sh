#!/system/bin/sh
# 진단 수집: 결과를 /data/local/tmp/seltos-diag.txt 에 저장하고, 쓰기 가능한 USB가 있으면 복사
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH
OUT=/data/local/tmp/seltos-diag.txt
sec() { echo; echo "##### $*"; }
{
sec "date/build";   date; getprop ro.build.fingerprint; getprop ro.product.model; getprop ro.build.display.id
sec "props";        getprop | grep -E "seltos|iap2|ium|hmg|carplay"
sec "hmgapid";      if command -v hmgapid >/dev/null 2>&1; then echo "present: $(command -v hmgapid)"; hmgapid engine list 2>&1; else echo "NOT FOUND"; fi
sec "hmgapi maps";  ls -R /data/hmgapi 2>&1
sec "tinymix";      if command -v tinymix >/dev/null 2>&1; then tinymix 2>&10; else echo "tinymix NOT FOUND"; fi
sec "asound cards"; cat /proc/asound/cards 2>&1
sec "asound.conf";  ls -l /data/local/asound.conf 2>&1
sec "install log";  cat /data/local/tmp/seltos-suite-install.log 2>&1
sec "dsp log";      cat /data/local/tmp/seltos-dsp-status.log 2>&1
sec "autolaunch";   cat /data/local/tmp/cp-autolaunch.log 2>&1
sec "iap2/tbt logcat"; logcat -d -v time | grep -iE "routeguidance|iap2|dipo|cluster|tbt|hmg-api" 2>&1
} > "$OUT" 2>&1
for d in /storage/*/ /mnt/media_rw/*/ /mnt/udisk/ /udisk/ /mnt/usb*/; do
    [ -d "$d" ] && [ -w "$d" ] && cp "$OUT" "${d}seltos-diag.txt" 2>/dev/null
done
am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "진단 저장: seltos-diag.txt (USB 루트 또는 /data/local/tmp)" >/dev/null 2>&1
exit 0
