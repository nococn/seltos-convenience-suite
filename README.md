# 🚙 Seltos SP2PE Convenience Suite (Gen5W)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
[![Vehicle: Kia Seltos SP2PE](https://img.shields.io/badge/Vehicle-Kia_Seltos_SP2PE-darkred.svg)](https://www.kia.com)
[![Infotainment: Gen5W Standard-class](https://img.shields.io/badge/Infotainment-Mobis_Gen5W-success.svg)](https://github.com/nococn/seltos-convenience-suite)
[![Platform: Android 4.4.2 KitKat](https://img.shields.io/badge/Platform-Android_4.4.2_KitKat-orange.svg)](https://github.com/nococn/seltos-convenience-suite)

> **Kia Seltos SP2PE (The New Seltos, Gen5W Standard-class Navigation)**  
> **Turn-by-Turn Cluster Guidance · Smart Auto-Launch · High-Res AAC Audio · App Sideloading**

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

### 4. 📦 서드파티 독립 앱 무인 간편 설치 (App Sideloading)
* **자동 배치 인스톨러 (`bin/install_apps.sh`)**: USB의 `/apps/*.apk` 디렉터리에 저장된 안드로이드 4.4(KitKat) 호환 앱을 감지하여 백그라운드에서 원터치로 순정 시스템에 설치합니다.

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
3. *(선택 사항)* 순정 화면에서 실행할 추가 앱이 있는 경우, USB 루트에 `apps` 폴더를 만들고 안드로이드 4.4 호환 APK 파일을 넣습니다:
   ```text
   USB Drive (FAT32)
   └── apps/
       ├── NewPipeLegacy_0.20.8.apk
       └── MXPlayer_NEON_KitKat.apk
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
