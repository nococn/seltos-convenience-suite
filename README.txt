Seltos Convenience Suite v1.7.4 - USB Install Guide
===================================================
1. USB: FAT32 (32GB 이하 권장)
2. 구조: NEMESIS.data / README.txt / packages/seltos.convenience.zip (zip은 풀지 말 것)
3. 차량: 내비 부팅 완료 -> 전면 USB -> 60초 내 'Yes' -> 설치 토스트 확인 -> RESET으로 재부팅
4. 유선/동글 시험 (USB 단자 1개)
   a) 재부팅 후 내부 로그 기록이 자동 시작 (1MB x 4개 순환, 최대 약 4MB)
   b) 아이폰/동글을 꽂고 카카오맵 길안내 시험 (계기판을 내비 화면으로)
   c) 시험 후 아이폰/동글을 뽑고 USB를 꽂아 "셀토스 실차 진단 데이터 수집" 실행
      -> USB 루트에 seltos-diag.txt, seltos-logcat*.txt 저장
   d) 끝나면 "로그 기록 켜기/끄기"로 끄기 (기록 삭제됨)
   * 로그 기록이 안 되면 /data/local/tmp/seltos-logger.err 에 사유가 남고, 진단 파일에 빈 구간으로 나옴
