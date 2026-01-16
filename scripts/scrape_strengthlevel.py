#!/usr/bin/env python3
"""
StrengthLevel.com 데이터 자동 수집 스크립트
모든 운동의 기준 데이터를 수집하여 SQL 파일로 생성합니다.

사용 목적: 포트폴리오 프로젝트용 데이터 수집
저작권: 공개 데이터 수집 (포트폴리오용)

필수 라이브러리 설치:
    pip install selenium beautifulsoup4 webdriver-manager

Chrome 브라우저 필요 (ChromeDriver는 webdriver-manager가 자동 설치)
"""

import time
import json
import re
from typing import List, Dict, Optional
from datetime import datetime

# Selenium 관련 import
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, NoSuchElementException

# BeautifulSoup for HTML 파싱
from bs4 import BeautifulSoup

# webdriver-manager: ChromeDriver 자동 관리
try:
    from webdriver_manager.chrome import ChromeDriverManager
    USE_WEBDRIVER_MANAGER = True
except ImportError:
    USE_WEBDRIVER_MANAGER = False
    print("⚠️  webdriver-manager가 설치되지 않았습니다. ChromeDriver를 수동으로 설정해야 합니다.")

BASE_URL = "https://strengthlevel.com"


def setup_chrome_driver(headless: bool = False) -> webdriver.Chrome:
    """
    Chrome 브라우저 드라이버 설정
    
    Args:
        headless: True면 브라우저 창을 띄우지 않음 (백그라운드 실행)
    
    Returns:
        설정된 Chrome WebDriver 인스턴스
    """
    # Chrome 옵션 설정
    chrome_options = Options()
    
    if headless:
        # 헤드리스 모드: 브라우저 창을 띄우지 않고 백그라운드에서 실행
        chrome_options.add_argument('--headless')
    
    # 성능 및 안정성 옵션
    chrome_options.add_argument('--no-sandbox')  # 샌드박스 모드 비활성화
    chrome_options.add_argument('--disable-dev-shm-usage')  # 공유 메모리 사용량 제한 해제
    chrome_options.add_argument('--disable-gpu')  # GPU 가속 비활성화
    chrome_options.add_argument('--window-size=1920,1080')  # 창 크기 설정
    chrome_options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36')
    
    # 로그 레벨 설정 (불필요한 로그 제거)
    chrome_options.add_experimental_option('excludeSwitches', ['enable-logging'])
    
    try:
        if USE_WEBDRIVER_MANAGER:
            # webdriver-manager를 사용하여 ChromeDriver 자동 다운로드 및 설정
            service = Service(ChromeDriverManager().install())
            driver = webdriver.Chrome(service=service, options=chrome_options)
        else:
            # 시스템 PATH에 있는 ChromeDriver 사용
            driver = webdriver.Chrome(options=chrome_options)
        
        print("✅ Chrome 드라이버 설정 완료")
        return driver
    
    except Exception as e:
        print(f"❌ Chrome 드라이버 설정 실패: {e}")
        print("\n해결 방법:")
        print("1. Chrome 브라우저가 설치되어 있는지 확인")
        print("2. pip install webdriver-manager 실행")
        print("3. 또는 ChromeDriver를 수동으로 다운로드하여 PATH에 추가")
        raise


def wait_for_element(driver: webdriver.Chrome, by: By, value: str, timeout: int = 10):
    """
    요소가 나타날 때까지 대기
    
    Args:
        driver: WebDriver 인스턴스
        by: 요소를 찾는 방법 (By.ID, By.CLASS_NAME 등)
        value: 요소의 값
        timeout: 최대 대기 시간 (초)
    
    Returns:
        찾은 요소
    """
    try:
        element = WebDriverWait(driver, timeout).until(
            EC.presence_of_element_located((by, value))
        )
        return element
    except TimeoutException:
        print(f"⚠️  요소를 찾을 수 없습니다: {value} (타임아웃: {timeout}초)")
        return None


def click_more_exercises_button(driver: webdriver.Chrome) -> bool:
    """
    "More Exercises" 버튼을 클릭하여 더 많은 운동을 로드
    
    Args:
        driver: WebDriver 인스턴스
    
    Returns:
        버튼 클릭 성공 여부
    """
    try:
        # 다양한 선택자로 버튼 찾기 시도
        selectors = [
            "//button[contains(text(), 'More Exercises')]",
            "//button[contains(text(), 'more exercises')]",
            "//a[contains(text(), 'More Exercises')]",
            "//a[contains(text(), 'more exercises')]",
            "//*[@id='more-exercises']",
            "//button[@class='more-exercises']",
        ]
        
        for selector in selectors:
            try:
                button = driver.find_element(By.XPATH, selector)
                # 버튼이 보이고 클릭 가능한지 확인
                if button.is_displayed() and button.is_enabled():
                    # JavaScript로 클릭 (일부 경우 더 안정적)
                    driver.execute_script("arguments[0].click();", button)
                    time.sleep(2)  # 페이지 로딩 대기
                    print("✅ 'More Exercises' 버튼 클릭 성공")
                    return True
            except NoSuchElementException:
                continue
        
        print("⚠️  'More Exercises' 버튼을 찾을 수 없습니다 (모든 운동이 로드되었을 수 있음)")
        return False
    
    except Exception as e:
        print(f"⚠️  버튼 클릭 중 오류: {e}")
        return False


def extract_exercise_data(soup: BeautifulSoup) -> List[Dict]:
    """
    HTML에서 운동 데이터 추출
    
    Args:
        soup: BeautifulSoup 파싱된 HTML
    
    Returns:
        추출된 운동 데이터 리스트
    """
    exercises = []
    
    # strengthlevel.com의 실제 HTML 구조에 맞춰 수정 필요
    # 일반적인 선택자 예시 (실제 사이트 구조 확인 후 수정)
    
    # 운동 카드 또는 리스트 아이템 찾기
    # 예시 선택자들 (실제 구조에 맞게 수정 필요)
    exercise_elements = soup.find_all(['div', 'article', 'li'], class_=re.compile(r'exercise|card|item', re.I))
    
    for element in exercise_elements:
        try:
            # 운동명 추출 (한글명과 영문명)
            name_elem = element.find(['h2', 'h3', 'h4', 'a'], class_=re.compile(r'name|title', re.I))
            if not name_elem:
                continue
            
            name = name_elem.get_text(strip=True)
            
            # 영문명 추출 시도
            name_en_elem = element.find(['span', 'div'], class_=re.compile(r'en|english', re.I))
            name_en = name_en_elem.get_text(strip=True) if name_en_elem else name
            
            # 카테고리 추출 (UPPER, LOWER, FULL_BODY)
            category_elem = element.find(['span', 'div'], class_=re.compile(r'category|type', re.I))
            category = 'FULL_BODY'  # 기본값
            if category_elem:
                category_text = category_elem.get_text(strip=True).upper()
                if 'UPPER' in category_text or '상체' in category_text:
                    category = 'UPPER'
                elif 'LOWER' in category_text or '하체' in category_text:
                    category = 'LOWER'
            
            # 부위 추출 (가슴, 등, 어깨, 팔, 하체)
            body_part_elem = element.find(['span', 'div'], class_=re.compile(r'body|part|muscle', re.I))
            body_part = body_part_elem.get_text(strip=True) if body_part_elem else ''
            
            exercises.append({
                'name': name,
                'name_en': name_en,
                'category': category,
                'body_part': body_part,
            })
        
        except Exception as e:
            print(f"⚠️  운동 데이터 추출 중 오류: {e}")
            continue
    
    return exercises


def scrape_exercise_standards(driver: webdriver.Chrome, exercise_name: str) -> List[Dict]:
    """
    특정 운동의 상세 기준 데이터 수집
    체중 범위별, 성별별, 레벨별 기준 무게를 가져옵니다.
    
    Args:
        driver: WebDriver 인스턴스
        exercise_name: 운동명 (영문)
    
    Returns:
        기준 데이터 리스트
    """
    standards = []
    
    try:
        # 운동 상세 페이지로 이동
        # strengthlevel.com의 URL 구조에 맞춰 수정 필요
        exercise_url = f"{BASE_URL}/strength-standards/{exercise_name.lower().replace(' ', '-')}"
        driver.get(exercise_url)
        time.sleep(3)  # 페이지 로딩 대기
        
        soup = BeautifulSoup(driver.page_source, 'html.parser')
        
        # 테이블 또는 데이터 구조에서 기준 추출
        # 실제 HTML 구조에 맞춰 수정 필요
        tables = soup.find_all('table', class_=re.compile(r'standard|table', re.I))
        
        for table in tables:
            rows = table.find_all('tr')
            for row in rows[1:]:  # 헤더 제외
                cells = row.find_all(['td', 'th'])
                if len(cells) < 5:
                    continue
                
                try:
                    # 체중 범위 파싱 (예: "60-70kg")
                    bodyweight_text = cells[0].get_text(strip=True)
                    bodyweight_match = re.search(r'(\d+)\s*-\s*(\d+)', bodyweight_text)
                    if bodyweight_match:
                        bodyweight_min = float(bodyweight_match.group(1))
                        bodyweight_max = float(bodyweight_match.group(2))
                    else:
                        continue
                    
                    # 성별 확인
                    gender_text = cells[1].get_text(strip=True).upper()
                    gender = 'MALE' if 'MALE' in gender_text or '남' in gender_text else 'FEMALE'
                    
                    # 레벨별 무게 추출
                    levels = ['BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE']
                    for i, level in enumerate(levels, start=2):
                        if i < len(cells):
                            weight_text = cells[i].get_text(strip=True)
                            weight_match = re.search(r'(\d+\.?\d*)', weight_text)
                            if weight_match:
                                weight_kg = float(weight_match.group(1))
                                
                                standards.append({
                                    'bodyweight_min': bodyweight_min,
                                    'bodyweight_max': bodyweight_max,
                                    'gender': gender,
                                    'level': level,
                                    'weight_kg': weight_kg,
                                })
                
                except Exception as e:
                    print(f"⚠️  기준 데이터 파싱 중 오류: {e}")
                    continue
    
    except Exception as e:
        print(f"⚠️  운동 기준 수집 중 오류 ({exercise_name}): {e}")
    
    return standards


def get_all_exercises(driver: webdriver.Chrome) -> List[Dict]:
    """
    Standards 페이지에서 모든 운동 목록을 수집합니다.
    "More Exercises" 버튼을 계속 클릭하여 모든 운동을 가져옵니다.
    
    Args:
        driver: WebDriver 인스턴스
    
    Returns:
        모든 운동 데이터 리스트
    """
    print("\n📋 운동 목록 수집 시작...")
    
    # Standards 페이지 접속
    standards_url = f"{BASE_URL}/strength-standards"
    print(f"🌐 페이지 접속: {standards_url}")
    driver.get(standards_url)
    time.sleep(5)  # 초기 페이지 로딩 대기
    
    all_exercises = []
    previous_count = 0
    no_change_count = 0
    max_no_change = 3  # 연속으로 변화가 없으면 종료
    
    # "More Exercises" 버튼을 계속 클릭하여 모든 운동 로드
    while True:
        # 현재 페이지의 운동 목록 추출
        soup = BeautifulSoup(driver.page_source, 'html.parser')
        current_exercises = extract_exercise_data(soup)
        
        # 중복 제거
        existing_names = {ex['name'] for ex in all_exercises}
        new_exercises = [ex for ex in current_exercises if ex['name'] not in existing_names]
        
        if new_exercises:
            all_exercises.extend(new_exercises)
            print(f"✅ {len(new_exercises)}개 운동 추가 (총 {len(all_exercises)}개)")
            no_change_count = 0
        else:
            no_change_count += 1
            if no_change_count >= max_no_change:
                print("✅ 모든 운동 수집 완료")
                break
        
        # "More Exercises" 버튼 클릭 시도
        if not click_more_exercises_button(driver):
            print("✅ 더 이상 로드할 운동이 없습니다")
            break
        
        # 무한 루프 방지
        if len(all_exercises) > 1000:  # 최대 1000개로 제한
            print("⚠️  최대 운동 개수에 도달했습니다 (1000개)")
            break
    
    print(f"\n📊 총 {len(all_exercises)}개 운동 수집 완료")
    return all_exercises


def generate_sql(exercises_data: List[Dict], output_file: str = 'database/addExercise.sql'):
    """
    수집한 데이터를 SQL INSERT 문으로 변환하여 파일로 저장합니다.
    
    Args:
        exercises_data: 운동 데이터 리스트
        output_file: 출력 SQL 파일 경로
    """
    print(f"\n📝 SQL 파일 생성 중: {output_file}")
    
    sql_lines = [
        "-- ============================================",
        "-- StrengthLevel.com 데이터 기반 운동 및 기준 추가 스크립트",
        f"-- 자동 생성됨: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        "-- ============================================\n",
    ]
    
    # Exercises 삽입
    sql_lines.append("-- ============================================")
    sql_lines.append("-- 1. EXERCISES 테이블 데이터 삽입")
    sql_lines.append("-- ============================================\n")
    
    for exercise in exercises_data:
        name = exercise.get('name', '').replace("'", "''")
        name_en = exercise.get('name_en', name).replace("'", "''")
        category = exercise.get('category', 'FULL_BODY')
        body_part = exercise.get('body_part', '').replace("'", "''")
        
        sql = f"""INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '{name}', '{name_en}', '{category}', '{body_part}', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;"""
        sql_lines.append(sql)
        sql_lines.append("")
    
    # Strength Standards 삽입
    sql_lines.append("-- ============================================")
    sql_lines.append("-- 2. STRENGTH_STANDARDS 테이블 데이터 삽입")
    sql_lines.append("-- ============================================")
    sql_lines.append("-- 주의: 각 운동의 상세 기준 데이터는 별도로 수집 필요")
    sql_lines.append("-- 아래는 예시 형식입니다.\n")
    
    # 예시 데이터 (실제로는 scrape_exercise_standards로 수집)
    sql_lines.append("-- 예시: 벤치프레스 기준 데이터")
    sql_lines.append("-- 실제 데이터는 각 운동의 상세 페이지에서 수집 필요\n")
    
    sql_lines.append("-- ============================================")
    sql_lines.append("-- 완료 메시지")
    sql_lines.append("-- ============================================")
    sql_lines.append("SELECT 'Exercise and Strength Standards data insertion completed!' AS message;")
    sql_lines.append("SELECT COUNT(*) as total_exercises FROM exercises;")
    sql_lines.append("SELECT COUNT(*) as total_standards FROM strength_standards;")
    
    # 파일 저장
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("\n".join(sql_lines))
    
    print(f"✅ SQL 파일 생성 완료: {output_file}")
    print(f"   - 운동 개수: {len(exercises_data)}")


def main():
    """
    메인 실행 함수
    """
    print("=" * 60)
    print("StrengthLevel.com 데이터 자동 수집 스크립트")
    print("=" * 60)
    print("\n⚠️  주의사항:")
    print("   - 이 스크립트는 포트폴리오 프로젝트용으로만 사용됩니다")
    print("   - 웹사이트에 과도한 부하를 주지 않도록 적절한 딜레이를 두었습니다")
    print("   - 실제 HTML 구조에 맞춰 선택자를 수정해야 할 수 있습니다\n")
    
    driver = None
    
    try:
        # Chrome 드라이버 설정 (headless=False: 브라우저 창 표시)
        print("🔧 Chrome 드라이버 설정 중...")
        driver = setup_chrome_driver(headless=False)
        
        # 모든 운동 목록 수집
        exercises_data = get_all_exercises(driver)
        
        if not exercises_data:
            print("❌ 수집된 운동 데이터가 없습니다.")
            print("   HTML 구조가 변경되었을 수 있으니 스크립트를 확인해주세요.")
            return
        
        # SQL 파일 생성
        generate_sql(exercises_data)
        
        # (선택적) 각 운동의 상세 기준 데이터 수집
        # 주의: 이 작업은 시간이 오래 걸릴 수 있습니다
        print("\n⚠️  상세 기준 데이터 수집은 별도로 진행해야 합니다.")
        print("   각 운동의 상세 페이지에서 체중 범위별, 성별별, 레벨별 데이터를 수집하세요.")
        
        print("\n✅ 작업 완료!")
        
    except KeyboardInterrupt:
        print("\n\n⚠️  사용자에 의해 중단되었습니다.")
    
    except Exception as e:
        print(f"\n❌ 오류 발생: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        # 브라우저 종료
        if driver:
            driver.quit()
            print("\n🔒 브라우저 종료 완료")


if __name__ == "__main__":
    main()
