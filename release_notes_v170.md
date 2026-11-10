# 🧭 Seltos Convenience Suite v1.7.0 Release Notes

기아 **더 뉴 셀토스(SP2PE)** 순정 Gen5W 와이드 내비게이션 전용 **실차 계측 해시 기반 계기판 TBT 연동 & 순정 6스피커 ALSA DSP 10밴드 EQ 패키지** v1.7.0 정식 릴리스입니다.

실차 진단 로그 분석 결과를 바탕으로, HMG-API 맵 경로 불일치 문제 해결 및 실차 바이너리 해시 검증 파이프라인을 전면 보완하여 계기판 턴바이턴(TBT) 연동을 정상화했습니다.

---

### 🚀 v1.7.0 주요 개선 사항 및 기술 분석

1. **🧭 셀토스 순정 펌웨어 공식 맵 경로 및 실차 해시 정합성 확보**:
   - **공식 맵 경로 배치 (`unknown/sp2pe/kor/260902`)**: HMG-API가 SP2PE 차종 식별 시 인식하는 공식 맵 디렉터리에 342개 훅 매핑 데이터 전면 배치 (하위 호환성을 위해 `kia/seltos/kor/260902` 동시 유지).
   - **실차 바이너리 해시 일치화**: `car.json` 내 `HKMC_DiPO.odex` 해시를 셀토스 실차 순정 파일 실측 해시(`110d0dc59cd7d65d51b141adf93bf8f8`)로 전면 동기화하여 `verify-map` 무결성 검증 통과 보장.

2. **🛠️ 실차 훅 지도 자동 생성 폴백(`map-car --write`) 실장**:
   - `scripts/post.sh` 설치 스크립트에 `hmgapid engine verify-map` 검증 로직 추가.
   - 사전 빌드된 맵과 불일치 발생 시 즉시 `hmgapid engine map-car --write`를 실행하여 실차 파일 기반으로 342개 훅 지도를 실시간 자동 생성하는 폴백 메커니즘 구축.

3. **⏱️ HMG-API 데몬 응답 대기 루프(`ping`) 추가**:
   - 설치 초기 백그라운드 데몬 준비 지연으로 인한 명령 누락(Race Condition)을 방지하기 위해 `until hmgapid ping; do sleep 1; done` 대기 루프 추가.

4. **🎚️ 기본 6스피커 ALSA DSP 10밴드 EQ 유지**:
   - -5.0dBFS 마스터 프리앰프 게인 감쇄로 디지털 클리핑을 원천 차단하고 순정 6스피커 음향 대역 밸런스 최적화.

---

### 📦 설치 방법
1. FAT32로 포맷된 32GB 이하 USB 메모리를 준비합니다.
2. `seltos-convenience-usb.zip` 압축을 해제한 뒤, 생성된 파일들(`NEMESIS.data`, `README.txt`, `packages/`)을 **USB 최상위(루트) 디렉터리**에 그대로 복사합니다.
3. 차량 시동을 켜고 순정 내비게이션이 완전히 부팅된 후, 전면 멀티미디어 USB 포트에 연결합니다.
4. NEMESIS 설치 확인 팝업에서 **'Yes'**를 터치합니다.
5. 설치 완료 안내 토스트 확인 후 내비게이션 RESET 핀홀을 눌러 재부팅합니다.
