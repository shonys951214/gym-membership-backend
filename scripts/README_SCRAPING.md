# StrengthLevel.com 데이터 수집 스크립트 사용 가이드

## 📋 목차

1. [필수 사항](#필수-사항)
2. [설치 방법](#설치-방법)
3. [사용 방법](#사용-방법)
4. [문제 해결](#문제-해결)
5. [주의사항](#주의사항)

---

## 필수 사항

### 1. Python 설치
- Python 3.7 이상 필요
- 설치 확인: `python --version` 또는 `python3 --version`

### 2. Chrome 브라우저 설치
- Google Chrome 브라우저가 설치되어 있어야 합니다
- ChromeDriver는 스크립트가 자동으로 다운로드합니다 (webdriver-manager 사용 시)

---

## 설치 방법

### 1단계: 필수 라이브러리 설치

터미널에서 다음 명령어를 실행하세요:

```bash
# 프로젝트 루트 디렉토리에서 실행
pip install selenium beautifulsoup4 webdriver-manager
```

또는 `requirements.txt`가 있다면:

```bash
pip install -r requirements.txt
```

### 2단계: 설치 확인

```bash
python -c "import selenium; print('Selenium 설치 완료')"
python -c "import bs4; print('BeautifulSoup 설치 완료')"
python -c "from webdriver_manager.chrome import ChromeDriverManager; print('webdriver-manager 설치 완료')"
```

모든 라이브러리가 정상적으로 import되면 설치 완료입니다.

---

## 사용 방법

### 기본 실행

```bash
# 프로젝트 루트 디렉토리에서 실행
python scripts/scrape_strengthlevel.py
```

또는

```bash
python3 scripts/scrape_strengthlevel.py
```

### 실행 과정

1. **Chrome 브라우저 자동 실행**
   - 스크립트가 Chrome 브라우저를 자동으로 열고 strengthlevel.com에 접속합니다
   - 브라우저 창이 보이면서 진행 상황을 확인할 수 있습니다

2. **운동 목록 수집**
   - Standards 페이지에서 "More Exercises" 버튼을 자동으로 클릭
   - 모든 운동이 로드될 때까지 반복

3. **SQL 파일 생성**
   - 수집한 데이터를 `database/addExercise.sql` 파일로 저장
   - 운동 기본 정보 (이름, 카테고리, 부위)가 포함됩니다

### 헤드리스 모드 (브라우저 창 없이 실행)

스크립트의 `main()` 함수에서 다음을 수정:

```python
# headless=True로 변경
driver = setup_chrome_driver(headless=True)
```

---

## 문제 해결

### 1. ChromeDriver 오류

**오류 메시지:**
```
selenium.common.exceptions.WebDriverException: Message: 'chromedriver' executable needs to be in PATH
```

**해결 방법:**
```bash
# webdriver-manager 설치 확인
pip install webdriver-manager

# 또는 ChromeDriver 수동 설치
# 1. Chrome 버전 확인: chrome://version/
# 2. https://chromedriver.chromium.org/ 에서 해당 버전 다운로드
# 3. PATH에 추가하거나 스크립트에서 경로 지정
```

### 2. 요소를 찾을 수 없음

**오류 메시지:**
```
⚠️  요소를 찾을 수 없습니다: ...
```

**원인:**
- strengthlevel.com의 HTML 구조가 변경되었을 수 있습니다
- 네트워크 지연으로 페이지 로딩이 완료되지 않았을 수 있습니다

**해결 방법:**
1. 스크립트의 `extract_exercise_data()` 함수에서 선택자 확인
2. 브라우저 개발자 도구로 실제 HTML 구조 확인
3. `time.sleep()` 시간을 늘려보기

### 3. "More Exercises" 버튼을 찾을 수 없음

**원인:**
- 버튼의 텍스트나 클래스명이 변경되었을 수 있습니다
- 이미 모든 운동이 로드된 상태일 수 있습니다

**해결 방법:**
1. 브라우저에서 실제 버튼의 HTML 확인
2. `click_more_exercises_button()` 함수의 선택자 수정

### 4. 네트워크 오류

**오류 메시지:**
```
TimeoutException 또는 ConnectionError
```

**해결 방법:**
1. 인터넷 연결 확인
2. 방화벽 설정 확인
3. `time.sleep()` 시간을 늘려보기

---

## 주의사항

### 1. 웹사이트 부하 방지
- 스크립트에 적절한 딜레이(`time.sleep()`)가 포함되어 있습니다
- 수집 속도를 더 느리게 하려면 딜레이 시간을 늘리세요

### 2. HTML 구조 변경
- 웹사이트의 HTML 구조가 변경되면 스크립트 수정이 필요합니다
- 선택자(selector)를 실제 HTML 구조에 맞게 업데이트하세요

### 3. 데이터 정확성
- 수집된 데이터는 자동으로 생성되므로 검증이 필요할 수 있습니다
- SQL 파일을 실행하기 전에 데이터를 확인하세요

### 4. 저작권 및 이용 약관
- 이 스크립트는 포트폴리오 프로젝트용으로만 사용됩니다
- strengthlevel.com의 이용 약관을 확인하고 준수하세요
- 상업적 용도로 사용하지 마세요

### 5. 상세 기준 데이터
- 현재 스크립트는 운동 목록만 수집합니다
- 각 운동의 체중 범위별, 성별별, 레벨별 상세 기준 데이터는 별도로 수집해야 합니다
- `scrape_exercise_standards()` 함수를 사용하여 각 운동의 상세 페이지에서 수집 가능

---

## 추가 기능

### 상세 기준 데이터 수집

각 운동의 상세 기준 데이터를 수집하려면:

```python
# main() 함수에 추가
for exercise in exercises_data:
    standards = scrape_exercise_standards(driver, exercise['name_en'])
    exercise['standards'] = standards
    time.sleep(2)  # 서버 부하 방지
```

**주의:** 이 작업은 시간이 오래 걸릴 수 있습니다 (운동 개수 × 페이지 로딩 시간)

---

## 출력 파일

스크립트 실행 후 다음 파일이 생성됩니다:

- `database/addExercise.sql`: 수집한 운동 데이터를 SQL INSERT 문으로 변환한 파일

---

## 문의 및 지원

문제가 발생하거나 질문이 있으면 프로젝트 관리자에게 문의하세요.
