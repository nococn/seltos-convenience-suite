#!/system/bin/sh
# APK Installer script for Seltos Suite (Dual-Route: pm install + root direct injection fallback)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

notice "USB 앱 설치를 시작합니다..."

# 이전 충돌 패키지 캐시 정리
pm uninstall org.schabi.newpipelegacy >/dev/null 2>&1
pm uninstall com.mxtech.videoplayer.pro >/dev/null 2>&1

INSTALLED=0
for APK in /storage/usb0/apps/*.apk /storage/usb1/apps/*.apk /data/nemesis/apps/seltos.convenience/apps/*.apk; do
    if [ -f "$APK" ]; then
        NAME="${APK##*/}"
        notice "$NAME 설치 시도 중..."
        
        # 1차 시도: 표준 pm install
        pm install "$APK" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            INSTALLED=$((INSTALLED + 1))
            notice "$NAME 설치 성공!"
        else
            # 2차 시도: 루트 권한 /data/app 직접 주입 (서명 파서 우회)
            case "$NAME" in
                *NewPipe*) PKG="org.schabi.newpipelegacy" ;;
                *MXPlayer*) PKG="com.mxtech.videoplayer.pro" ;;
                *) PKG="app_${NAME%.*}" ;;
            esac
            cp "$APK" "/data/app/${PKG}-1.apk"
            chmod 644 "/data/app/${PKG}-1.apk"
            chown 1000:1000 "/data/app/${PKG}-1.apk" 2>/dev/null
            INSTALLED=$((INSTALLED + 1))
            notice "$NAME 시스템 직접 주입 완료!"
        fi
    fi
done

if [ $INSTALLED -gt 0 ]; then
    sync
    am broadcast -a android.intent.action.BOOT_COMPLETED >/dev/null 2>&1
    notice "총 ${INSTALLED}개 앱 설치 완료! Tilepad를 확인해 주세요."
else
    notice "설치 실패: APK 파일을 찾지 못했습니다."
fi
