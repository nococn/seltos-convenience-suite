#!/system/bin/sh
# Audio Toggle: A/B switch between Seltos ALSA 10-Band DSP EQ and Stock Flat OEM mode
export PATH=/data/nemesis/bin:/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin:$PATH

APP_DIR=/data/nemesis/apps/seltos.convenience

notice() {
    echo "$*"
    am broadcast -a com.hkmc.telematics.action.SHOW_TOAST --es message "$*" >/dev/null 2>&1
}

CURRENT_MODE=$(getprop persist.seltos.dsp.mode)

if [ "$CURRENT_MODE" = "1" ]; then
    # Switch to Stock OEM Flat Mode
    if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
        sh "$APP_DIR/bin/dsp_engine.sh" disable >/dev/null 2>&1
    fi
    pkill -HUP mediaserver 2>/dev/null
    notice "🔈 [오디오 순정 모드] 모비스 플랫 음향으로 전환되었습니다."
else
    # Switch to Seltos 10-Band Parametric EQ Mode
    if [ -f "$APP_DIR/bin/dsp_engine.sh" ]; then
        sh "$APP_DIR/bin/dsp_engine.sh" enable >/dev/null 2>&1
    fi
    pkill -HUP mediaserver 2>/dev/null
    notice "🔊 [10밴드 EQ ON] 셀토스 6스피커 맞춤 DSP 활성화 (-5.0dB 마스터)"
fi

exit 0
