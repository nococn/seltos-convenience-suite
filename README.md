# 🚙 기아 더 뉴 셀토스 편의 기능 패키지 (Gen5W Seltos Suite)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
[![Vehicle: Kia Seltos SP2PE](https://img.shields.io/badge/Vehicle-Kia_Seltos_SP2PE-darkred.svg)](https://www.kia.com)
[![Infotainment: Gen5W Standard-class](https://img.shields.io/badge/Infotainment-Mobis_Gen5W-success.svg)](https://github.com/nococn/seltos-convenience-suite)
[![Platform: Android 4.4.2 KitKat](https://img.shields.io/badge/Platform-Android_4.4.2_KitKat-orange.svg)](https://github.com/nococn/seltos-convenience-suite)
[![Audio: 10--Band ALSA DSP](https://img.shields.io/badge/Audio-ALSA_DSP_10--Band_EQ-blueviolet.svg)](https://github.com/nococn/seltos-convenience-suite)
[![Navi: Cluster TBT Hook](https://img.shields.io/badge/Navi-Cluster_TBT_Injection-success.svg)](https://github.com/nococn/seltos-convenience-suite)

> **기아 더 뉴 셀토스(SP2PE) 순정 5W 내비게이션 전용 NEMESIS 패키지**  
> **유선/동글 카플레이 계기판 턴바이턴(TBT) 연동 · 순정 6스피커 맞춤 ALSA DSP 10밴드 EQ (-5.0dBFS 마스터 프리앰프 무왜곡) · 원터치 A/B 청음 토글 (v1.5.0)**

기아 **더 뉴 셀토스(SP2PE)** 등 현대모비스 5세대 와이드(Gen5W Standard-class) 순정 내비게이션 탑재 차량 전용 패키지입니다.

실차 주행 테스트 피드백을 바탕으로 하드웨어 제약상 불가능한 미작동 루틴(가짜 HUD 오버레이, 물리 별표 버튼 후킹, Wi-Fi 핫스팟 의존성)을 전면 배제하고, 실차에서 완벽하게 동작하는 **2대 핵심 실질 기능**에 집중하여 개발되었습니다:
1. **유선 케이블 및 사제 무선 동글(카링킷 등) 전용 순수 DiPO + iAP2 계기판 턴바이턴(TBT) 연동**
2. **순정 기본 6스피커 하드웨어 맞춤형 ALSA DSP 10밴드 파라메트릭 EQ (-5.0dBFS 마스터 프리앰프 헤드룸 보호)**

---

## ⚠️ 실차 적용 주의사항 및 하드웨어 안전 가이드

### 1. 적용 대상 및 아키텍처 제한
* **지원 플랫폼**: 현대모비스 **Standard Gen5W 와이드(10.25" / 12.3") 내비게이션** (내수용 Android 4.4.2 KitKat 유저랜드)
* **호환 불가 플랫폼 (설치 금지)**:
  * **ccNC (connected car Navigation Cockpit)**: 2023+ 신형 디 올 뉴 그랜저(GN7), 쏘렌토 페이스리프트, 싼타페(MX5), 코나(SX2) 등 ccNC 탑재 차량은 리눅스/QNX 기반 신규 아키텍처로 본 패키지가 구동되지 않습니다.
  * **고급형 5세대 (Premium Gen5)**: 제네시스 구형 DIS 계열 인포테인먼트는 시스템 파티션 구조가 상이합니다.
  * **4세대 및 표준형 5세대(7"/8" 컴팩트 내비)**: 해상도 및 오디오 ALSA 라우팅이 호환되지 않습니다.

### 2. 음향 신호 보호: -5.0dBFS 마스터 프리앰프 헤드룸 설계 원리
* 순정 기본 6스피커 환경에서 고역 해상도를 확보하기 위해 8kHz(+3.0dB) 및 16kHz(+3.5dB) 부스트를 적용하면 인접 Biquad 필터 스커트가 중첩되어 12k~14kHz 대역에서 최대 **+4.39dB 합성 피크**가 발생합니다.
* 본 패키지는 ALSA `route` 플러그인의 `ttable` 변환 계수를 `0.562`(-5.0dBFS)로 설정하여 **합성 피크(+4.39dB)를 완벽히 상쇄**하고, 0dBFS 최대 디지털 입력 시에도 **-0.61dBFS의 절대 안전 헤드룸**을 상시 보장합니다.

---

## 🌟 2대 핵심 기능 (Key Features)

### 1. 🧭 카플레이 계기판 턴바이턴(TBT) 연동 (유선 & 사제 무선 동글 전용)
* **순수 DiPO + iAP2 라우트 가이던스 엔진**:
  * 내비 내부 `Iap2Service`의 `iAP2UsedRouteGuidance` 스트리밍을 개방하여 아이폰 내비(티맵, 카카오내비, 애플 지도)가 회전 및 거리 패킷을 전송하도록 유도합니다.
  * `com.daudio.app.dipo.telechips.CarPlayService`의 `oniAPSendMessage`를 가로채 순정 계기판 CAN TBT 규격으로 실시간 변환 주입합니다.
* **무선 핫스팟/Wi-Fi 종속성 완전 배제**:
  * 기존 코리아 프로젝션이 셀토스의 Wi-Fi 칩셋 부재(DNP)로 인해 핫스팟 실패 시 TBT 모듈까지 전체 롤백되던 구조적 결함을 완벽히 해결했습니다.
  * Wi-Fi 검사 루틴을 100% 제거하여 유선 케이블 직결 및 사제 무선 동글(카링킷, 주파집 등) 환경에서 셀토스 10.25인치 슈퍼비전 클러스터 내비 탭에 턴바이턴 화살표와 남은 거리가 상시 안정적으로 표출됩니다.

### 2. 🎚️ 기본 6스피커 하드웨어 맞춤형 ALSA DSP 10밴드 파라메트릭 EQ (v1.5.0)
* **내장 앰프 보호 및 초저역 롤오프 (31.5Hz -2.0dB, Q=0.7)**: 도어 우퍼 페이퍼 콘의 과진동을 방지하고 20W급 순정 내장 앰프의 전력 낭비와 찌그러짐을 차단합니다.
* **타격감 집중 및 도어 트림 공진 억제**: 63Hz(+3.5dB, Q=1.1)에 킥베이스 펀치력을 집중시키고, 도어 플라스틱 부밍을 유발하는 125Hz는 +1.5dB(Q=1.2)로 제어하며, 캐비티 공진 대역인 250Hz는 -1.0dB(Q=1.8) 핀포인트 노치 필터로 깎아 단단한 저역을 구현합니다.
* **보컬 전면 정위감 및 고역 개방감**: 1kHz(-1.0dB, Q=1.2)와 2kHz(-0.5dB, Q=1.4)로 내비게이션 쏘는 소리를 다듬으면서도 보컬 후퇴를 방지하고, 4kHz(+1.0dB, Q=1.2), 8kHz(+3.0dB, Q=1.1), 16kHz(+3.5dB, Q=1.4)로 기본 스피커의 답답한 음색을 걷어냅니다.
* **마스터 프리앰프 -5.0dBFS 무왜곡 보장**: 10개 전 밴드 필터 상호작용 분석 결과, 최대 음압에서도 클리핑 마진 -0.61dBFS를 상시 유지합니다.

| 밴드 | 중심 주파수 | 게인 (Gain) | Q값 | 필터 특성 및 튜닝 목적 |
| :---: | :---: | :---: | :---: | :--- |
| **Band 1** | **31.5 Hz** | **-2.0 dB** | 0.7 | 초저역 서브소닉 롤오프, 도어 우퍼 페이퍼 콘 과진동 보호 |
| **Band 2** | **63.0 Hz** | **+3.5 dB** | 1.1 | 킥드럼 및 베이스기타 타격감(Punch) 집중 부스트 |
| **Band 3** | **125 Hz** | **+1.5 dB** | 1.2 | 저음역 양감 보강 및 도어 플라스틱 부밍 방지 |
| **Band 4** | **250 Hz** | **-1.0 dB** | 1.8 | 도어 트림 내부 캐비티 공진 억제 핀포인트 노치 |
| **Band 5** | **500 Hz** | **0.0 dB** | 1.0 | 보컬 바디감 기준 대역 (Flat 유지) |
| **Band 6** | **1 kHz** | **-1.0 dB** | 1.2 | 내비게이션 및 라디오 중고역 자극음 완화 |
| **Band 7** | **2 kHz** | **-0.5 dB** | 1.4 | 보컬 전면 센터 정위감 확립 |
| **Band 8** | **4 kHz** | **+1.0 dB** | 1.2 | 대시보드 트위터 명료도(Clarity) 개선 |
| **Band 9** | **8 kHz** | **+3.0 dB** | 1.1 | 심벌 및 어쿠스틱 악기 에어감(Sparkle) 형성 |
| **Band 10** | **16 kHz** | **+3.5 dB** | 1.4 | 초고역 개방감 복원 (마스터 프리앰프로 피크 상쇄) |

### 3. 🔄 단일 원터치 A/B 비교 청음 토글 (`bin/audio_toggle.sh`)
* **NEMESIS 런처 메뉴 일원화 및 동시 토스트 버그 해결**: 기존의 ON/OFF 분리 나열로 발생하던 중복 토스트 버그를 제거하고, NEMESIS 런처에 **단일 원터치 토글 아이콘**으로 통합했습니다.
* **실시간 A/B 청음**: 주행 중 터치 한 번으로 `순정 플랫 음향`과 `셀토스 10밴드 DSP EQ`를 즉각 교차 전환하며 사운드 스테이지 차이를 체감할 수 있습니다. 상태 전환 시 명확한 단일 시스템 토스트가 표출됩니다.

### 4. ⚡ 스마트 카플레이 자동 화면 전환 (Auto-Launch Daemon)
* **이벤트 기반 백그라운드 데몬 (`svc/autolaunch.sh`)**: 카플레이 연결 완료 브로드캐스트 이벤트를 실시간 감지하여, 부팅 후 카플레이 화면으로 자동 전환합니다.
* **후방카메라 안전 인터락 (Safety Interlock)**: 후진(R단) 중일 때는 화면 전환 명령을 안전하게 보류하고, 후방 카메라가 해제된 후 부드럽게 카플레이 화면을 띄웁니다.

---

## 🛠️ 설치 및 순정 원복 매뉴얼 (Installation & Clean Restore)

### 1단계: USB 드라이브 구조 준비
1. **FAT32** 파일 시스템으로 포맷된 USB 메모리를 준비합니다.
2. [Releases](https://github.com/nococn/seltos-convenience-suite/releases) 탭에서 `seltos-convenience-usb.zip`을 다운로드하여 USB 최상위 루트에 압축 해제합니다.
3. USB 최상위 루트 구조:

```text
USB Drive (FAT32 Root)
├── NEMESIS.data              <-- v1.5.0 자동 설치 트리거 (type=install)
├── README.txt
└── packages/
    └── seltos.convenience.zip <-- 실제 설치 패키지 번들
```

### 2단계: 차량 내비게이션 원터치 설치
1. 차량 시동(ACC/ON 또는 시동 상태)을 켭니다.
2. 준비된 USB 메모리를 콘솔 전면 **통신용 USB 포트**(CarPlay / Android Auto 유선 연결 포트)에 삽입합니다.
3. USB가 인식되면 화면에 NEMESIS Manager 설치 확인 창이 자동으로 팝업됩니다.
   *(자동 팝업이 뜨지 않을 경우: NEMESIS Manager 앱을 실행하여 `packages/seltos.convenience.zip`을 직접 선택)*
4. **[Install / 설치]**를 터치하여 설치를 진행합니다.
5. 설치 완료 토스트가 표출되면 USB를 제거하고, 전면 리셋 홀(RESET pinhole)을 눌러 내비게이션을 1회 재부팅합니다.

### 3단계: 100% 순정 원복 보장 (Clean Restore Guide)
1. 인포테인먼트 화면에서 **NEMESIS Manager**를 실행합니다.
2. 설치된 패키지 목록에서 **셀토스 편의 기능 패키지 (`seltos.convenience`)**를 선택합니다.
3. **[Uninstall / 삭제]** 버튼을 터치합니다.
4. **원복 메커니즘**:
   * HMG-API TBT 엔진 및 등록된 모드가 원상 복원됩니다.
   * `bin/dsp_engine.sh disable`이 자동 실행되어 `/data/local/asound.conf`가 삭제되고 ALSA 하드웨어 믹서가 순정 플랫(Flat) 상태로 1:1 복원됩니다.
   * 내비게이션을 재부팅하면 차량 출고 시점의 100% 순정 상태로 안전하게 복구됩니다.

---

## 🛡️ 시스템 아키텍처 및 안전성

```text
[ Apple iPhone / Carlinkit Wireless Dongle ]
              │ (USB iAP2 Protocol: Route Guidance Packets)
              ▼
[ Gen5W Infotainment (Android 4.4.2) ]
   ├── svc/autolaunch.sh       ──▶ CarPlay Session Event Detection (Reverse Camera Safe)
   ├── hmgapi (DiPO TBT Hook)  ──▶ Intercepts CarPlayService.oniAPSendMessage
   │                                        │
   │                                        ▼
   │                             [ 10.25" Supervision Cluster TBT Display ]
   └── bin/dsp_engine.sh       ──▶ ALSA DSP 10-Band Parametric EQ Engine (-5.0dB Preamp)
                                            │
                                            ▼
                               [ Stock 6-Speaker Soundstage ]
```

* **파워트레인 물리 격리**: 본 패키지는 모비스 멀티미디어 안드로이드 유저랜드 환경에서만 구동되며, 차량의 조향·제동·엔진 구동계 CAN 버스와는 물리적으로 게이트웨이 격리되어 있어 차량 주행 안전에 영향을 미치지 않습니다.
* **디지털 클리핑 제로**: -5.0dBFS 마스터 프리앰프 감쇄 설계로 볼륨 최댓값에서도 왜곡 없는 안전한 신호 처리를 보장합니다.

---

## 📜 오픈소스 크레딧 및 라이선스 (Attribution)

본 프로젝트는 현대·기아 오픈소스 전장 연구 커뮤니티의 소중한 선행 연구를 바탕으로 제작되었습니다.

* **HMG-API & HMG-Mod**: `xwtk`, `VysseCodes` (DiPO 클러스터 CAN 프레임워크)
* **NEMESIS Automotive Mod Manager**: `seogaemo` (패키지 사양 및 매니저)
* **Korea Projection**: `StopDragon` (하드웨어 진단 및 TBT 프로토콜 연구)
* **ALSA TinyMix Framework**: Android Open Source Project

자세한 저작권 정보는 [NOTICE.md](NOTICE.md)를 참조하십시오.  
본 프로젝트의 소스 코드는 **[GNU Affero General Public License v3.0 (AGPL-3.0)](LICENSE)** 하에 배포됩니다.
