#!/system/bin/sh
# Audio ON: Enable high-res AAC lossless patch
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine install $APP_DIR/hmgapi/wireless-carplay-aa.zip >/dev/null 2>&1
    hmgapid engine apply >/dev/null 2>&1
    pkill -HUP mediaserver 2>/dev/null
    notice "🔊 [오디오 비교 ON] AAC 고음질 무손실 패치 적용됨"
else
    notice "오디오 엔진을 찾을 수 없습니다."
fi
