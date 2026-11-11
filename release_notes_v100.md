# Seltos Convenience Suite v1.0.0

기아 **더 뉴 셀토스(SP2PE)** 순정 Gen5W 와이드 내비게이션 전용 **실차 계측 기반 TBT 엔진 & 6스피커 맞춤 ALSA DSP 10밴드 EQ 패키지** v1.0.0 정식 릴리스입니다.

실차 진단 및 주행 로그 6종(`seltos-diag.txt`, `seltos-verify-map.txt`, `seltos-map-car.log`, `seltos-install-full.log`, `seltos-autolaunch.log`, `seltos-logger.err`)의 실측 결과를 완벽히 검증하고, 기존 시행착오 버전을 전면 정리하여 v1.0.0 신규 기점으로 형상 관리를 정립했습니다.

---

### 🔍 실차 실측 데이터 검증 결과

1. **실차 동적 맵 생성 및 검증 100% 성공 (rc=0)**:
   - 차내에서 직접 실행한 `map-car --write`와 `verify-map`이 모두 정상 종료되어 `unknown/sp2pe/kor/260902` 기준 342개 중 342개 훅 지점 전수 해석을 완료했습니다 (`hooks run with it from the next start`).
   - 사전 패키징된 정적 지도 대신 차내 동적 생성이 유일하게 안전하고 확실한 해법임을 실측으로 증명했습니다.
2. **모드 설치 실패(rc=2) 원인 규명 및 문법 정상화**:
   - `hmgapid engine install` CLI 규격은 `install <zip>` 단일 인자 구조이며, 존재하지 않는 `--any-car` 옵션 전달로 인해 `no package at --any-car` 실패가 발생했던 원인을 확인하여 표준 단일 인자 규격으로 정정했습니다.
3. **카플레이 자동 전환 루프 완치**:
   - 통화 상태 폴링 신호(`isTMUCall_ring()`)에 오반응하여 11초 주기로 화면 전환이 반복되던 결함을 제거하고, 실제 세션 연결 이벤트(`onSendConnected result 1`, `session_started`)에만 60초 쿨다운과 파일 락 기반으로 1회 진입하도록 정상화했습니다.
4. **안드로이드 4.4 킷캣 logcat 호환성 확보**:
   - 구형 킷캣에서 미지원되는 `-r/-n` 순환 옵션 실패 시 TBT/카플레이 전용 태그 필터링 스트림으로 자동 폴백하여 메모리 누수 없이 주행 로그를 보존하도록 조치했습니다.

---

### 🚀 v1.0.0 주요 구성

1. **차내 순정 맵 동적 생성 & 안전 Plan 수집**:
   - `map-car --write` -> `verify-map` 파이프라인으로 안전성을 검증하고, 모드 설치 후 `plan` 결과를 수집하여 무단 패치 없는 100% 안전 시퀀스를 보장합니다.
2. **기본 6스피커 맞춤 ALSA DSP 10밴드 EQ 탑재**:
   - 순정 기본 6스피커의 저역 부밍과 고역 답답함을 해소하는 파라메트릭 EQ 프로필 및 -5.0dBFS 마스터 프리앰프 무왜곡 헤드룸 설계.
3. **단일 USB 순환 로깅 및 원클릭 진단 추출**:
   - 단일 멀티미디어 USB 포트 환경에서도 주행 중 백그라운드에서 iAP2/TBT 데이터를 안전하게 기록하고, 주행 후 USB 삽입 시 원클릭으로 추출합니다.
