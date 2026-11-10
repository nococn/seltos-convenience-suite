#!/system/bin/sh
# Audio ON: Enable Seltos Stock 6-Speaker ALSA DSP 10-Band Parametric EQ
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

# ALSA DSP 10-Band Parametric EQ & Road Noise Loudness Compensation
if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
    sh "$APP_DIR/bin/dsp_engine.sh" enable >/dev/null 2>&1
fi

pkill -HUP mediaserver 2>/dev/null
notice "🔊 [10밴드 EQ ON] 셀토스 6스피커 맞춤 DSP 활성화 (-5.0dB 마스터 프리앰프)"
exit 0
