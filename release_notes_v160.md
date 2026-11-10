# Seltos Convenience Suite v1.6.0

기아 **더 뉴 셀토스(SP2PE)** 순정 Gen5W 와이드 내비게이션 전용 **SP2PE 맞춤 TBT 엔진 탑재 & 순정 6스피커 ALSA DSP 10밴드 EQ 패키지** v1.6.0 정식 릴리스입니다.

실차 TBT 미작동 원인 분석 및 실차 주행 검증 결과를 바탕으로, 셀토스 `SP2PE` 전용으로 리빌드 및 자체 서명된 HMG-API DiPO TBT 엔진 바이너리를 패키지에 전면 실장했습니다.

---

### 🚀 v1.6.0 주요 개선 사항 및 기술 분석

1. **🧭 셀토스 SP2PE 전용 TBT 엔진 바이너리 실장 (`wireless-carplay-aa.zip`)**:
   - **`mod.json` 차종 검증 통과**: 원본 코리아프로젝션의 지원 차종 목록(`system.model`)에 누락되어 있던 셀토스 모델 코드(`SP2PE`)를 공식 등록하고, Wi-Fi 칩 미실장(DNP)으로 인해 로딩을 차단하던 `hmgapi.wifi` 필수 검사 제약을 분리 제거.
   - **`patches.json` 매핑 완료**: `SP2PE.KOR.` 모델 코드를 `kor` 패치 세트에 정확히 연결하여 순정 내비게이션 펌웨어(`260902`)와의 호환성 확보.
   - **`settings.json` 스펙 확정**: `tbt` default: true, `bridge` default: false, `audio` default: false로 설정하여 하드웨어 Wi-Fi 핫스팟 구동 시도 없이 유선 케이블 직결 및 사제 무선 동글(카링킷, 주파집 등) 환경에서 순수 계기판 TBT 훅만 단독 구동.
   - **엔진 자체 서명 및 검증**: HMG-API 모드 패키징 규격(ECDSA secp256r1)에 맞추어 `META-HMGAPI/manifest.json` 해시 갱신 및 `signature` 서명을 완료하여 엔진 무결성 검증 100% 통과.

2. **🛠️ 클린 인스톨 & 서명 충돌 방지 스크립트 정비 (`scripts/post.sh`)**:
   - 기존에 다른 서명 키로 설치되어 있던 모드와의 충돌을 방지하기 위해 `hmgapid engine remove wireless-carplay-aa` 후 클린 설치 및 적용(`apply`)을 수행하도록 인스톨러 스크립트 고도화.

3. **🎚️ 기본 6스피커 맞춤 ALSA DSP 10밴드 파라메트릭 EQ (-5.0dBFS 마스터 프리앰프)**:
   - **-5.0dBFS 마스터 프리앰프 헤드룸 보호**: 8k/16k Biquad 필터 스커트 중첩 합성 피크(+4.39dB)를 상쇄하여 풀 볼륨 시에도 -0.61dBFS 절대 안전 헤드룸 상시 유지 (디지털 피크 클리핑 왜곡 제로).
   - **원터치 A/B 비교 청음 토글 (`bin/audio_toggle.sh`)**: NEMESIS 런처에서 `순정 모비스 플랫` ↔ `셀토스 10밴드 DSP EQ`를 즉각 교차 전환하며 단일 시스템 토스트 안내.

4. **⚡ 스마트 카플레이 자동 화면 전환 (`svc/autolaunch.sh`)**:
   - 부팅 후 카플레이 세션 감지 시 전면 화면 자동 전환 (후방카메라 안전 인터락 완비).

---

### 📦 설치 파일 안내

- **`seltos-convenience-usb.zip` (차량 원터치 설치용)**:
  - FAT32 포맷 USB 메모리 최상위에 압축 해제하면 `NEMESIS.data`, `README.txt`, `packages/seltos.convenience.zip`이 자동으로 구성되어 차량에서 자동 팝업 설치가 진행됩니다.
- **`seltos-convenience-pack.zip` (NEMESIS 패키지 파일)**:
  - NEMESIS Manager의 수동 설치를 위한 패키지 아카이브입니다.
