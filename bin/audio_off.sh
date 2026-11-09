#!/system/bin/sh
# Audio OFF: Revert to stock Mobis audio mode
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine remove wireless-carplay-aa >/dev/null 2>&1
    hmgapid engine apply >/dev/null 2>&1
    pkill -HUP mediaserver 2>/dev/null
    notice "🔈 [오디오 비교 OFF] 순정 모비스 오디오 모드로 원복됨"
else
    notice "오디오 엔진을 찾을 수 없습니다."
fi
