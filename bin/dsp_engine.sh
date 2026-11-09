#!/system/bin/sh
# Seltos SP2PE Stock 6-Speaker ALSA DSP 10-Band Parametric EQ Engine (v1.3.1)
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
    log "Enabling Seltos SP2PE Stock 6-Speaker Acoustic EQ (v1.3.1)..."

    # 1. ALSA Hardware Mixer DSP controls
    # Preamp Gain: -4.0 dB (Guarantees -0.5 dBFS digital headroom against +3.5 dB max boost)
    set_mixer "Preamp Gain" "108"
    set_mixer "Bass Boost" "1"
    set_mixer "Loudness Filter" "1"
    set_mixer "Loudness Low Cut" "40"
    set_mixer "Loudness High Boost" "1"

    # 10-Band Hardware Parametric EQ gains for Stock 6-Speaker:
    set_mixer "EQ Band 1 Gain" "9"      # 31.5 Hz: -2.0 dB (Cone roll-off protection)
    set_mixer "EQ Band 2 Gain" "16"     # 63.0 Hz: +3.5 dB (Kick/bass punch focus)
    set_mixer "EQ Band 3 Gain" "13"     # 125 Hz:  +1.5 dB (Trim booming prevention)
    set_mixer "EQ Band 4 Gain" "10"     # 250 Hz:  -1.0 dB (Boxy resonance notch)
    set_mixer "EQ Band 5 Gain" "12"     # 500 Hz:   0.0 dB (Vocal body)
    set_mixer "EQ Band 6 Gain" "11"     # 1 kHz:   -1.0 dB (Nav peak cut)
    set_mixer "EQ Band 7 Gain" "11"     # 2 kHz:   -0.5 dB (Vocal centering)
    set_mixer "EQ Band 8 Gain" "14"     # 4 kHz:   +1.0 dB (Treble clarity)
    set_mixer "EQ Band 9 Gain" "18"     # 8 kHz:   +3.0 dB (Sparkle & air)
    set_mixer "EQ Band 10 Gain" "19"    # 16 kHz:  +3.5 dB (Ultra-high extension)
    set_mixer "EQ Mode" "User"

    # 2. ALSA PCM DSP configuration overlay with -4.0 dB attenuation (0.631)
    cat << 'EOF' > "$ASOUND_CONF"
# Seltos SP2PE Stock 6-Speaker Audiophile Pipeline (v1.3.1)
pcm.!default {
    type plug
    slave.pcm "dsp_filter"
}

pcm.dsp_filter {
    type route
    slave.pcm "hw:0,0"
    ttable.0.0 0.631
    ttable.1.1 0.631
}
EOF
    chmod 644 "$ASOUND_CONF"

    # 3. Persistent DSP properties
    setprop persist.seltos.dsp.mode 1
    setprop persist.seltos.dsp.eq 1
    setprop persist.seltos.dsp.loudness 1
    setprop persist.seltos.dsp.profile "sp2pe_stock6spk_v131"

    # Reload mediaserver smoothly
    pkill -HUP mediaserver 2>/dev/null
    log "Seltos Stock 6-Speaker DSP enabled successfully."
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
