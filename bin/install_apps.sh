#!/system/bin/sh
# APK Installer script for Seltos Suite
export PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

notice "USB 앱 설치를 시작합니다..."

INSTALLED=0
for APK in /storage/usb0/apps/*.apk /storage/usb1/apps/*.apk /data/nemesis/apps/seltos.convenience/apps/*.apk; do
    if [ -f "$APK" ]; then
        NAME=$(basename "$APK")
        notice "$NAME 설치 중..."
        pm install -r "$APK"
        if [ $? -eq 0 ]; then
            INSTALLED=$((INSTALLED + 1))
        fi
    fi
done

if [ $INSTALLED -gt 0 ]; then
    notice "총 ${INSTALLED}개 앱 설치가 완료되었습니다!"
else
    notice "설치할 APK 파일을 찾지 못했습니다. USB의 apps 폴더를 확인해 주세요."
fi
