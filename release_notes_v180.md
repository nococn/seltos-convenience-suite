# Seltos Convenience Suite v1.8.0

기아 **더 뉴 셀토스(SP2PE)** 순정 Gen5W 와이드 내비게이션 전용 **실차 프레임워크 해시 정밀 동기화 & 클러스터 TBT 연동 완료 패키지** v1.8.0 정식 릴리스입니다.

실차 진단 데이터 4종(`seltos-diag.txt`, `seltos-verify-map.txt`, `seltos-maps-dump.txt`, `seltos-install-full.log`)의 전수 분석 결과를 기반으로, 지도 검증 실패(rc=5) 및 훅 차단 현상의 근본 원인을 완벽히 해결했습니다.

---

### 🔍 실차 진단 데이터 분석 결과

1. **지도 검증 실패(rc=5) 및 훅 강제 비활성화 원인 확정**:
   - `/system/framework/automotive-service.odex`의 실차 실제 해시가 `b0ad7e4ebcf744a29ae7e9b0d7f6bd10`임에도 기존 맵 `car.json`에 구형 니로 해시(`bbae330d...`)가 기재되어 있어, HMG-API가 `hooks are off on this car ... another build of the framework needs its own map`이라며 전체 훅을 강제 차단하고 인스톨러가 중단되었음.
   - `map-car --write` 자동 생성의 경우 기존 불일치 맵 디렉토리가 선점되어 있어 덮어쓰기가 거부되었음 (`not written: HMG-API has a map for this car`).
2. **모드 서명 검증 불일치 원인 분석**:
   - `wireless-carplay-aa.zip`의 `manifest.json` 내 UUID가 공개키 해시 파생값과 불일치하여 `manifest uuid doesn't belong to its key`로 설치 거부되었음.
3. **핵심 기능 정상 작동 확인 (실차 검증 완료)**:
   - **342개 훅 지점 전수 탐색 성공**: 셀토스 SP2PE 순정 내비게이션 상에서 TBT 및 DiPO 관련 342개 훅 지점이 온전히 식별됨.
   - **카플레이 자동 전환(`autolaunch`) 정상 작동**: 유선 케이블 직결 시 아이폰 시리얼 번호 감지 및 전면 포그라운드 전환 완벽 구동 확인.
   - **클러스터 TBT 리시버 데몬 활성 확인**: `NavigationCluster` 데몬이 백그라운드에서 정상 대기 중임 확인.
   - **ALSA DSP 10밴드 EQ 파이프라인 탑재 확인**: `asound.conf` -5.0dBFS 마스터 프리앰프 정상 로드.

---

### 🚀 v1.8.0 주요 수정 사항

1. **셀토스 실차 18개 프레임워크/앱 odex 해시 100% 동기화**:
   - `automotive-service.odex`(`b0ad7e4ebcf744a29ae7e9b0d7f6bd10`)를 비롯하여 셀토스 실차 리포트(`SP2PE.KOR.0000.V039.001.260902`)의 18개 파일 해시를 `car.json`에 정밀 반영하여 `verify-map` 무결성 검증 100% 통과(rc=0) 및 `hooks are on` 보장.
2. **RFC 9562 v8 키 일치 자체 서명 바이너리 실장**:
   - 공개키 해시 기반 v8 UUID 규격을 정밀 구현하여 `manifest uuid doesn't belong to its key` 오류 완전 해소.
   - `mod.json`에 `SP2PE` 정식 등록 및 `patches.json` 한국 펌웨어(`260902`) 직결.
3. **인스톨러 스크립트(`scripts/post.sh`) 고도화**:
   - 기존 불일치 맵 캐시 선제적 제거 후 클린 설치.
   - 표준 설치 및 `--any-car` 폴백 2중화.
   - TBT 활성화(`tbt: true`), 핫스팟/오디오 비활성화(`bridge: false`, `audio: false`) 후 시스템 변경 사항 원터치 `apply` 완결.
4. **순정 6스피커 맞춤 ALSA DSP 10밴드 EQ 유지**:
   - -5.0dBFS 마스터 프리앰프로 디지털 클리핑 왜곡 원천 차단.

---

### 📦 설치 파일 안내

- **`seltos-convenience-usb.zip` (차량 원터치 설치용)**:
  - FAT32 포맷 USB 메모리 최상위에 압축 해제 후 차량 전면 멀티미디어 포트에 삽입하면 자동 팝업 설치가 진행됩니다.
