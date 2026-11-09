#!/system/bin/sh
# Seltos SP2PE ALSA DSP & 10-Band Parametric EQ Engine
# Mode: enable | disable

ACTION="$1"
CONF_DIR="/data/nemesis/apps/seltos.convenience/etc/dsp"
ASOUND_CONF="/data/local/asound.conf"

log() {
    echo "[DSP] $*"
}

set_mixer() {
    CTRL="$1"
    VAL="$2"
    if command -v tinymix >/dev/null 2>&1; then
        tinymix "$CTRL" "$VAL" >/dev/null 2>&1
    fi
}

enable_dsp() {
    log "Enabling Seltos SP2PE 10-Band Acoustic EQ & Loudness..."

    # 1. ALSA Hardware Mixer DSP controls (Telechips/Mobis Gen5W Audio SoC)
    set_mixer "Preamp Gain" "115"        # -1.5 dB headroom
    set_mixer "Bass Boost" "1"
    set_mixer "Loudness Filter" "1"
    set_mixer "Loudness Low Cut" "45"
    set_mixer "Loudness High Boost" "2"

    # 10-Band Hardware Parametric EQ gains
    set_mixer "EQ Band 1 Gain" "15"     # 31.5 Hz: +3.0 dB
    set_mixer "EQ Band 2 Gain" "18"     # 63.0 Hz: +4.5 dB
    set_mixer "EQ Band 3 Gain" "15"     # 125 Hz:  +3.0 dB
    set_mixer "EQ Band 4 Gain" "10"     # 250 Hz:  -1.0 dB
    set_mixer "EQ Band 5 Gain" "12"     # 500 Hz:   0.0 dB
    set_mixer "EQ Band 6 Gain" "9"      # 1 kHz:   -1.5 dB
    set_mixer "EQ Band 7 Gain" "10"     # 2 kHz:   -1.0 dB
    set_mixer "EQ Band 8 Gain" "15"     # 4 kHz:   +1.5 dB
    set_mixer "EQ Band 9 Gain" "18"     # 8 kHz:   +3.0 dB
    set_mixer "EQ Band 10 Gain" "20"    # 16 kHz:  +4.0 dB
    set_mixer "EQ Mode" "User"

    # 2. ALSA PCM DSP configuration overlay
    cat << 'EOF' > "$ASOUND_CONF"
# Seltos SP2PE High-Fidelity ALSA Audio Pipeline
pcm.!default {
    type plug
    slave.pcm "dsp_filter"
}

pcm.dsp_filter {
    type route
    slave.pcm "hw:0,0"
    ttable.0.0 0.95
    ttable.1.1 0.95
}
EOF
    chmod 644 "$ASOUND_CONF"

    # 3. Persistent DSP properties
    setprop persist.seltos.dsp.mode 1
    setprop persist.seltos.dsp.eq 1
    setprop persist.seltos.dsp.loudness 1
    setprop persist.seltos.dsp.profile "sp2pe_acoustic_v1"

    # Reload mediaserver smoothly
    pkill -HUP mediaserver 2>/dev/null
    log "Seltos DSP enabled successfully."
}

disable_dsp() {
    log "Disabling DSP and restoring flat Mobis OEM profile..."

    # 1. Reset Hardware Mixer to Flat (0 dB)
    set_mixer "Preamp Gain" "120"        # 0.0 dB unity
    set_mixer "Bass Boost" "0"
    set_mixer "Loudness Filter" "0"

    set_mixer "EQ Band 1 Gain" "12"     # 0.0 dB flat
    set_mixer "EQ Band 2 Gain" "12"
    set_mixer "EQ Band 3 Gain" "12"
    set_mixer "EQ Band 4 Gain" "12"
    set_mixer "EQ Band 5 Gain" "12"
    set_mixer "EQ Band 6 Gain" "12"
    set_mixer "EQ Band 7 Gain" "12"
    set_mixer "EQ Band 8 Gain" "12"
    set_mixer "EQ Band 9 Gain" "12"
    set_mixer "EQ Band 10 Gain" "12"
    set_mixer "EQ Mode" "Flat"

    # 2. Remove ALSA config overlay
    rm -f "$ASOUND_CONF"

    # 3. Reset persistent properties
    setprop persist.seltos.dsp.mode 0
    setprop persist.seltos.dsp.eq 0
    setprop persist.seltos.dsp.loudness 0

    pkill -HUP mediaserver 2>/dev/null
    log "Seltos DSP disabled. Stock audio restored."
}

case "$ACTION" in
    enable)
        enable_dsp
        ;;
    disable)
        disable_dsp
        ;;
    *)
        echo "Usage: $0 {enable|disable}"
        exit 1
        ;;
esac
exit 0
