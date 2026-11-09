# 🚙 기아 더 뉴 셀토스 편의 기능 패키지 (Gen5W)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
[![Vehicle: Kia Seltos SP2PE](https://img.shields.io/badge/Vehicle-Kia_Seltos_SP2PE-darkred.svg)](https://www.kia.com)
[![Infotainment: Gen5W Standard-class](https://img.shields.io/badge/Infotainment-Mobis_Gen5W-success.svg)](https://github.com/nococn/seltos-convenience-suite)
[![Platform: Android 4.4.2 KitKat](https://img.shields.io/badge/Platform-Android_4.4.2_KitKat-orange.svg)](https://github.com/nococn/seltos-convenience-suite)

> **기아 더 뉴 셀토스(SP2PE) 순정 5W 내비게이션 전용 NEMESIS 패키지**  
> **카플레이 계기판/HUD 턴바이턴 안내 · 자동 화면 전환 · AAC 무손실 + ALSA DSP 10밴드 EQ 및 라우드니스 (Seltos Suite v1.2.0)**

기아 **더 뉴 셀토스(SP2PE)** 등 하드웨어상 Wi-Fi 칩셋이 미실장(DNP - Do Not Populate)된 내수용 현대·기아 5세대 와이드(Gen5W) 순정 내비게이션 전용 통합 편의 기능 패키지입니다.

내장 무선 프로젝션이 불가능한 내수용 전장 환경에서, **유선 카플레이 직결 및 사제 무선 동글(카링킷, 주파집 등)** 환경의 편의성을 극대화하도록 개발되었습니다.

---

## 🌟 주요 기능 (Key Features)

### 1. 🧭 카플레이 계기판/HUD 턴바이턴(TBT) 연동
* **DiPO CAN 클러스터 실시간 후킹**: 애플 지도(Apple Maps), TMAP, 네이버 지도, 카카오내비의 다음 회전 방향 및 남은 거리 정보를 순정 10.25인치 슈퍼비전 계기판과 컴바이너 HUD 내비게이션 탭에 실시간 투영합니다.
* **유선 및 사제 무선 동글 완벽 지원**: 사제 무선 동글이 전송하는 표준 Apple iAP2 프로토콜 패킷을 가로채 순정 계기판 프로토콜로 변환하므로 동글 환경에서도 순정처럼 TBT 안내를 받을 수 있습니다.

### 2. ⚡ 스마트 카플레이 자동 화면 전환 (Auto-Launch Daemon)
* **이벤트 기반 백그라운드 데몬 (`svc/autolaunch.sh`)**: 고정 타이머 방식 대신 시스템 로그캣의 `CarPlay Session Ready` 브로드캐스트 이벤트를 실시간 감지하여, 카플레이 연결이 완료되는 즉시 메인 디스플레이를 카플레이 화면으로 자동 전환합니다.
* **후방카메라 안전 인터락 (Safety Interlock)**: 시동 직후 후진(R단) 중일 때는 화면 전환 명령을 안전하게 보류하고, 후방 카메라가 해제된 후 부드럽게 카플레이 화면을 띄웁니다.

### 3. 🎵 순정 오디오 AAC 고음질 코덱 패치 (Hi-Res Audio)
* **저대역폭 디코더 개선**: Gen5W 기본 오디오의 저대역폭 압축 라이브러리를 고해상도 AAC(`libleafiaaac.so`) 오디오 엔진으로 교체하여 카플레이 스트리밍(Apple Music, Melon, Spotify 등)의 음질 왜곡을 줄이고 다이내믹 레인지를 복원합니다.

### 4. 🎚️ ALSA DSP 기반 10밴드 파라메트릭 EQ & 주행 노면 소음 라우드니스 부스팅
* **셀토스(SP2PE) 실내 음향 전용 10밴드 파라메트릭 튜닝**: 소형 SUV 특유의 휠하우스 저음 마스킹과 45~60Hz 대역 타이어 로드노이즈를 극복하기 위해 31.5Hz(+3.0dB), 63Hz(+4.5dB), 125Hz(+3.0dB) 저역 펀치감을 단단하게 보강합니다.
* **내비 음성 피크 제거 및 고역 개방감**: 1kHz(-1.5dB), 2kHz(-1.0dB)를 다듬어 내비게이션 길 안내 시 발생하는 쏘는 소리와 보컬 피로도를 줄이고, 8kHz(+3.0dB), 16kHz(+4.0dB) 초고역 에어 대역을 확장하여 카플레이 스트리밍 음원의 투명도와 해상력을 극대화합니다.
* **디지털 클리핑 방지 프리앰프 감쇄 (-1.5dB)**: 주파수 부스팅에 따른 인터샘플 디지털 피크 왜곡을 방지하도록 헤드룸을 자동 확보합니다.
* **플레처-먼슨(Fletcher-Munson) 라우드니스 보정**: 저볼륨 주행 시에도 풍성한 저음과 고음을 유지하도록 청명한 라우드니스 보정 커브를 결합합니다.

### 5. 🔄 고음질 ON / 순정 모비스 OFF 원터치 A/B 비교 스위치
* **실시간 원터치 음질 비교**: NEMESIS Manager 앱 목록에서 `[오디오 고음질 ON (AAC + 10밴드 EQ)]` 및 `[오디오 순정 모드 OFF (플랫 원복)]`를 원터치로 전환하여 순정 오디오와 패치 후 음질 차이를 차량 안에서 즉각적으로 비교 청음할 수 있습니다.

---

## 🚘 호환 차종 및 펌웨어

* **대상 차종**: 기아 더 뉴 셀토스 SP2PE (2022 ~ 현재)
* **인포테인먼트 사양**: 현대모비스 5세대 와이드(Gen5W Standard-class) 내비게이션 (10.25인치 통합형 디스플레이)
* **지원 펌웨어 빌드**:
  * `SP2PE.KOR.S5W_M.V011.005.240711` (검증 완료)
  * 및 동일 계열 Gen5W 최신 업데이트 빌드
* **호환 패키지 매니저**: [NEMESIS Manager](https://seogaemo.github.io) v1.4.0+

---

## 🛠️ 설치 방법 (Installation)

### 1단계: 패키지 파일 준비
1. [Releases](https://github.com/nococn/seltos-convenience-suite/releases) 탭에서 최신 `seltos-convenience-pack.zip`을 다운로드합니다.
2. FAT32로 포맷된 USB 메모리의 루트에 `packages` 폴더를 만들고 zip 파일을 복사합니다:
   ```text
   USB Drive (FAT32)
   └── packages/
       └── seltos-convenience-pack.zip
   ```

### 2단계: 차량 내비게이션 설치
1. 셀토스 시동을 켠 후 준비된 USB를 전면 통신용 USB 포트(CarPlay 지원 포트)에 연결합니다.
2. 순정 화면에서 **NEMESIS Manager**를 실행합니다.
3. 패키지 목록에서 **Seltos Convenience Suite (`seltos.convenience`)**를 선택하고 **[설치]**를 터치합니다.
4. 설치가 완료되면 안내에 따라 인포테인먼트를 1회 재부팅합니다.

---

## 🛡️ 시스템 아키텍처 및 안전성

```text
[ Apple iPhone / Wireless Dongle ]
              │ (USB iAP2 Protocol)
              ▼
[ Gen5W Infotainment (Android 4.4.2) ]
   ├── svc/autolaunch.sh  ──▶ CarPlay Session Event Detection (Reverse Camera Safe)
   ├── hmgapi (DiPO Hook) ──▶ DiPO CAN Gateway Intercept
   │                                   │
   │                                   ▼
   │                        [ 10.25" Cluster & HUD (TBT Display) ]
   └── lib/libleafiaaac.so ──▶ High-Res Audio DAC Engine
```

* **파워트레인 격리**: 본 패키지는 모비스 멀티미디어 안드로이드 유저랜드 환경에서만 구동되며, 차량의 조향·제동·엔진 구동계 CAN 버스와는 물리적으로 게이트웨이 격리되어 있어 차량 주행 안전에 영향을 미치지 않습니다.
* **100% 원상 복구 (Clean Rollback)**: 차량 검사나 순정 상태 복귀가 필요한 경우, NEMESIS Manager에서 **[삭제]** 버튼을 터치하면 백업된 순정 파일로 100% 자동 롤백됩니다.

---

## 📜 오픈소스 크레딧 및 라이선스 (Attribution)

본 프로젝트는 현대·기아 오픈소스 전장 연구 커뮤니티의 소중한 선행 연구를 바탕으로 제작되었습니다.

* **HMG-API & HMG-Mod**: `xwtk`, `VysseCodes` (DiPO 클러스터 CAN 프레임워크)
* **NEMESIS Automotive Mod Manager**: `seogaemo` (패키지 사양 및 매니저)
* **Korea Projection**: `StopDragon` (하드웨어 진단 및 텔레메트리 연구)
* **Leafia AAC Audio Mod**: Leafia Team

자세한 저작권 정보는 [NOTICE.md](NOTICE.md)를 참조하십시오.  
본 프로젝트의 소스 코드는 **[GNU Affero General Public License v3.0 (AGPL-3.0)](LICENSE)** 하에 배포됩니다.
