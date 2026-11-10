# v1.7.1: Seltos SP2PE Standalone Cluster TBT Engine, ALSA DSP Suite & On-Vehicle Diagnostics

기아 **더 뉴 셀토스(SP2PE)** 순정 Gen5W 와이드 내비게이션 전용 **실차 계측 해시 기반 계기판 TBT 연동 & 순정 6스피커 ALSA DSP 10밴드 EQ 패키지** v1.7.1 정식 릴리스입니다.

v1.7.0의 정합성 수정에 더하여, 실차 하드웨어 믹서 및 데몬 상태를 원클릭으로 USB에 덤프할 수 있는 **실차 진단 수집 도구(diag.sh)**를 통합했습니다.

---

### 🚀 v1.7.1 주요 개선 사항 및 구성

1. **🧭 셀토스 순정 펌웨어 공식 맵 경로 및 실차 해시 정합성 (v1.7.0 반영분 유지)**:
   - 공식 맵 경로 `unknown/sp2pe/kor/260902`에 342개 훅 매핑 데이터 전면 배치.
   - `car.json` 내 `HKMC_DiPO.odex` 해시를 셀토스 실차 순정 파일 실측 해시(`110d0dc59cd7d65d51b141adf93bf8f8`)로 동기화하여 `verify-map` 무결성 검증 통과 보장.

2. **🛠️ 실차 훅 지도 자동 생성 폴백(`map-car --write`) & ping 루프**:
   - `scripts/post.sh` 설치 시 맵 검증 실패가 발생하더라도 `hmgapid engine map-car --write`를 즉시 실행하여 실차 파일 기반 342개 훅 지도를 실시간 자동 생성.
   - HMG-API 데몬 준비 지연에 대응하는 `ping` 대기 루프 유지.

3. **🎚️ 기본 6스피커 ALSA DSP 10밴드 EQ 및 -5.0dBFS 프리앰프**:
   - `/data/local/asound.conf` PCM 라우팅 복원: -5.0dBFS 마스터 감쇄로 디지털 클리핑 및 게인 스태킹 원천 차단.

4. **🔍 실차 진단 데이터 원클릭 USB 수집 기능 추가 (`bin/diag.sh`)**:
   - NEMESIS 앱 목록에 **'셀토스 실차 진단 데이터 수집 (USB 저장)'** 추가.
   - 실행 시 연결된 USB 메모리에 `seltos-diag.txt`를 자동 생성:
     - `tinymix` 전체 하드웨어 컨트롤 목록
     - ALSA 사운드 카드 및 `asound.conf` 상태
     - `hmgapid engine list` 및 모드 설치 로그
     - DSP 적용 상태 및 안드로이드 시스템 프로퍼티

---

### 📦 설치 방법
1. FAT32로 포맷된 32GB 이하 USB 메모리를 준비합니다.
2. `seltos-convenience-usb.zip` 압축을 해제한 뒤, 생성된 파일들(`NEMESIS.data`, `README.txt`, `packages/`)을 **USB 최상위(루트) 디렉터리**에 그대로 복사합니다.
3. 차량 시동을 켜고 순정 내비게이션이 완전히 부팅된 후, 전면 멀티미디어 USB 포트에 연결합니다.
4. NEMESIS 설치 확인 팝업에서 **'Yes'**를 터치합니다.
5. 설치 완료 안내 토스트 확인 후 내비게이션 RESET 핀홀을 눌러 재부팅합니다.
6. (선택) 상세 오디오/시스템 분석이 필요할 경우, NEMESIS 앱 목록에서 **'셀토스 실차 진단 데이터 수집'**을 터치하면 USB에 `seltos-diag.txt`가 저장됩니다.
