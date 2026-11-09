import numpy as np, sys

FS = float(sys.argv[1]) if len(sys.argv) > 1 else 48000.0  # 실제 샘플레이트로 변경
PREAMP_DB = -5.0
MARGIN_DB = 0.5

# (freq Hz, gain dB, Q)
BANDS = [
    (31.5, -2.0, 0.7), (63, 3.5, 1.1), (125, 1.5, 1.2),
    (250, -1.0, 1.8), (500, 0.0, 1.0), (1000, -1.0, 1.2),
    (2000, -0.5, 1.4), (4000, 1.0, 1.2), (8000, 3.0, 1.1),
    (16000, 3.5, 1.4),
]

def peaking_response_db(f, f0, gain, q, fs):
    # RBJ Audio EQ Cookbook peaking biquad
    A = 10 ** (gain / 40)
    w0 = 2 * np.pi * f0 / fs
    alpha = np.sin(w0) / (2 * q)
    c = np.cos(w0)
    b = [1 + alpha * A, -2 * c, 1 - alpha * A]
    a = [1 + alpha / A, -2 * c, 1 - alpha / A]
    z = np.exp(-1j * 2 * np.pi * f / fs)
    H = (b[0] + b[1] * z + b[2] * z**2) / (a[0] + a[1] * z + a[2] * z**2)
    return 20 * np.log10(np.abs(H))

def lowshelf_response_db(f, f0, gain, q, fs):
    A = 10 ** (gain / 40)
    w0 = 2 * np.pi * f0 / fs
    alpha = np.sin(w0) / (2 * q)
    c = np.cos(w0)
    b = [
        A * ((A + 1) - (A - 1) * c + 2 * np.sqrt(A) * alpha),
        2 * A * ((A - 1) - (A + 1) * c),
        A * ((A + 1) - (A - 1) * c - 2 * np.sqrt(A) * alpha),
    ]
    a = [
        (A + 1) + (A - 1) * c + 2 * np.sqrt(A) * alpha,
        -2 * ((A - 1) + (A + 1) * c),
        (A + 1) + (A - 1) * c - 2 * np.sqrt(A) * alpha,
    ]
    z = np.exp(-1j * 2 * np.pi * f / fs)
    H = (b[0] + b[1] * z + b[2] * z**2) / (a[0] + a[1] * z + a[2] * z**2)
    return 20 * np.log10(np.abs(H))

def highshelf_response_db(f, f0, gain, q, fs):
    A = 10 ** (gain / 40)
    w0 = 2 * np.pi * f0 / fs
    alpha = np.sin(w0) / (2 * q)
    c = np.cos(w0)
    b = [
        A * ((A + 1) + (A - 1) * c + 2 * np.sqrt(A) * alpha),
        -2 * A * ((A - 1) + (A + 1) * c),
        A * ((A + 1) + (A - 1) * c - 2 * np.sqrt(A) * alpha),
    ]
    a = [
        (A + 1) - (A - 1) * c + 2 * np.sqrt(A) * alpha,
        2 * ((A - 1) - (A + 1) * c),
        (A + 1) - (A - 1) * c - 2 * np.sqrt(A) * alpha,
    ]
    z = np.exp(-1j * 2 * np.pi * f / fs)
    H = (b[0] + b[1] * z + b[2] * z**2) / (a[0] + a[1] * z + a[2] * z**2)
    return 20 * np.log10(np.abs(H))

f = np.logspace(np.log10(20), np.log10(min(20000, FS / 2 * 0.999)), 20000)

# 1. Pure Peaking on all bands
total_peaking = sum(peaking_response_db(f, *b, FS) for b in BANDS)
i_p = np.argmax(total_peaking)
peak_p, peak_f_p = total_peaking[i_p], f[i_p]
needed_p = -(max(peak_p, 0) + MARGIN_DB)

print(f"=== [케이스 1: 10개 밴드 전원 Peaking Biquad] ===")
print(f"샘플레이트: {FS:.0f} Hz")
print(f"합산 최대 게인: {peak_p:+.2f} dB @ {peak_f_p:.0f} Hz")
print(f"권장 프리앰프(여유 {MARGIN_DB}dB): {needed_p:+.2f} dB")
print(f"현재 프리앰프 {PREAMP_DB:+.1f} dB 기준 최소 헤드룸: {-(peak_p + PREAMP_DB):+.2f} dB")
print("판정:", "OK" if PREAMP_DB <= needed_p else "프리앰프를 더 낮춰야 함")

# 2. Hybrid: 31.5Hz Low-shelf + 16kHz High-shelf
total_hybrid = (
    lowshelf_response_db(f, BANDS[0][0], BANDS[0][1], BANDS[0][2], FS)
    + sum(peaking_response_db(f, *b, FS) for b in BANDS[1:9])
    + highshelf_response_db(f, BANDS[9][0], BANDS[9][1], BANDS[9][2], FS)
)
i_h = np.argmax(total_hybrid)
peak_h, peak_f_h = total_hybrid[i_h], f[i_h]
needed_h = -(max(peak_h, 0) + MARGIN_DB)

print(f"\n=== [케이스 2: 31.5Hz Low-shelf + 16kHz High-shelf 하이브리드] ===")
print(f"샘플레이트: {FS:.0f} Hz")
print(f"합산 최대 게인: {peak_h:+.2f} dB @ {peak_f_h:.0f} Hz")
print(f"권장 프리앰프(여유 {MARGIN_DB}dB): {needed_h:+.2f} dB")
print(f"현재 프리앰프 {PREAMP_DB:+.1f} dB 기준 최소 헤드룸: {-(peak_h + PREAMP_DB):+.2f} dB")
print("판정:", "OK" if PREAMP_DB <= needed_h else "프리앰프를 더 낮춰야 함")
