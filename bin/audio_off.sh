#!/system/bin/sh
# Audio OFF: Revert to stock Mobis flat audio mode (DSP disabled)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

# Disable ALSA DSP EQ & Loudness
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    sh "$APP_DIR/bin/dsp_engine.sh" disable >/dev/null 2>&1
fi

pkill -HUP mediaserver 2>/dev/null
notice "🔈 [오디오 순정 모드 OFF] 모비스 플랫 음향으로 원복되었습니다."
exit 0
