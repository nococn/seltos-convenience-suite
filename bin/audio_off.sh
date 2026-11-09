#!/system/bin/sh
# Audio OFF: Revert to stock Mobis flat audio mode (DSP disabled, stock codec)
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

# 1. Disable ALSA DSP EQ & Loudness
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    sh "$APP_DIR/bin/dsp_engine.sh" disable >/dev/null 2>&1
fi

# 2. Revert HMG-API AAC codec overlay to stock
if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine remove wireless-carplay-aa >/dev/null 2>&1
    hmgapid engine apply >/dev/null 2>&1
fi

pkill -HUP mediaserver 2>/dev/null
notice "🔈 [오디오 OFF] 순정 모비스 플랫 오디오 모드로 원복됨"
exit 0
