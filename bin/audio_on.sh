#!/system/bin/sh
# Audio ON: Enable high-res AAC lossless patch & ALSA DSP 10-Band Parametric EQ
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

# 1. HMG-API AAC High-Resolution Codec Overlay
if command -v hmgapid >/dev/null 2>&1; then
    hmgapid engine install $APP_DIR/hmgapi/wireless-carplay-aa.zip >/dev/null 2>&1
    hmgapid engine apply >/dev/null 2>&1
fi

# 2. ALSA DSP 10-Band Parametric EQ & Road Noise Loudness Compensation
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    sh "$APP_DIR/bin/dsp_engine.sh" enable >/dev/null 2>&1
fi

pkill -HUP mediaserver 2>/dev/null
notice "🔊 [오디오 ON] AAC 무손실 + ALSA DSP 10밴드 EQ/라우드니스 적용됨"
exit 0
