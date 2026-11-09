# 🚙 기아 더 뉴 셀토스 편의 기능 패키지 (Gen5W)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)
[![Vehicle: Kia Seltos SP2PE](https://img.shields.io/badge/Vehicle-Kia_Seltos_SP2PE-darkred.svg)](https://www.kia.com)
[![Infotainment: Gen5W Standard-class](https://img.shields.io/badge/Infotainment-Mobis_Gen5W-success.svg)](https://github.com/nococn/seltos-convenience-suite)
[![Platform: Android 4.4.2 KitKat](https://img.shields.io/badge/Platform-Android_4.4.2_KitKat-orange.svg)](https://github.com/nococn/seltos-convenience-suite)

> **기아 더 뉴 셀토스(SP2PE) 순정 5W 내비게이션 전용 NEMESIS 패키지**  
> **카플레이 계기판/HUD 턴바이턴 안내 · 자동 화면 전환 · 6스피커 맞춤 ALSA DSP 10밴드 EQ · HUD 미니 텔레메트리 (Seltos Suite v1.3.2)**

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

### 4. 🎚️ 기본 6스피커 하드웨어 맞춤형 ALSA DSP 10밴드 파라메트릭 EQ (v1.3.1)
* **내장 앰프 보호 및 초저역 롤오프 (31.5Hz -2.0dB, Q=0.7)**: 외장 앰프가 없는 순정 헤드유닛 내장 앰프(20W급)의 출력 한계와 도어 우퍼 페이퍼 콘의 과진동을 방지하기 위해 31.5Hz 초저역을 버터워스 로우쉘프(Q=0.7)로 부드럽게 롤오프하여 앰프 전력 낭비와 찌그러짐을 차단합니다.
* **타격감 집중 및 도어 트림 공진 억제**: 63Hz(+3.5dB, Q=1.1)에 킥베이스 펀치력을 집중시키고, 도어 플라스틱 트림 부밍을 유발하는 125Hz는 +1.5dB(Q=1.2)로 정밀 제어하며, 박스형 공진 대역인 250Hz는 -1.0dB(Q=1.8) 핀포인트 노치 필터로 깎아 단단하고 정갈한 저역을 구현합니다.
* **보컬 전면 정위감 및 고역 개방감**: 1kHz(-1.0dB, Q=1.2)와 2kHz(-0.5dB, Q=1.4)로 내비게이션 쏘는 소리를 다듬으면서도 보컬 후퇴를 방지하여 중심을 잡고, 4kHz(+1.0dB, Q=1.2), 8kHz(+3.0dB, Q=1.1), 16kHz(+3.5dB, Q=1.4)로 기본 스피커의 답답한 음색을 걷어내고 청량한 공간감을 부여합니다.
* **필터 스커트 중첩(Gain Stacking) 방어 및 마스터 프리앰프 -5.0dBFS 재설계**: 8kHz와 16kHz 인접 밴드의 필터 스커트 중첩으로 발생하는 12k~14kHz 대역의 실질 합성 피크(+4.39dB)를 완벽히 상쇄하기 위해 마스터 프리앰프 감쇄를 -5.0dBFS(ttable 0.562)로 강화했습니다. 이를 통해 풀 볼륨 시에도 실질 출력 피크가 -0.61dBFS로 제어되어 -0.5dB 이상의 안전 헤드룸이 완벽히 확보되며, 어떠한 고음압 스트리밍에서도 디지털 피크 클리핑 왜곡이 원천 차단됩니다.

### 5. 📊 HUD 스타일 미니 텔레메트리 오버레이 (CAN Telemetry OSD)
* **실시간 차량 핵심 센서 모니터링**: HMG-API CAN 버스 인터페이스를 연동하여 실시간 **배터리 충전 전압(V)**, **엔진 냉각수 및 오일 온도(°C)**, **TPMS 4륜 공기압(psi)** 정보를 주행 중 화면 상단에 깔끔한 HUD 배너 형태로 투영합니다.
* **주행 안전 시선 집중**: 고속 주행 시 계기판 탭을 복잡하게 전환하지 않고도 전장 배터리 상태와 열관리 지표를 한눈에 파악할 수 있습니다.

### 6. ⭐ 핸들 즐겨찾기(★) 버튼 연동 원터치 HUD 토글
* **스티어링 휠 커스텀 버튼 실시간 후킹**: 운전대의 별표(★) 버튼과 연동되어 주행 중 손을 떼지 않고 원터치로 HUD 텔레메트리를 켜고(ON) 끌(OFF) 수 있으며, NEMESIS Manager 앱 메뉴에서도 수동 토글이 가능합니다.

### 7. 🔄 고음질 ON / 순정 모비스 OFF 원터치 A/B 비교 스위치
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
