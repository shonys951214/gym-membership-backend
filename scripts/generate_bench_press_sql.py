#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
벤치프레스 Strength Standards SQL 생성 스크립트
체중별 + 나이별 데이터 생성 (남성 + 여성)
"""

# 체중별 데이터 (남성: 50~140kg, 여성: 40~120kg)
male_weights = [50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140]
female_weights = [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120]
levels = ['BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE']

# 남성 체중별 무게 데이터 (표에서 가져온 값)
male_weight_data = {
    50: [24, 38, 57, 79, 103],
    55: [29, 45, 64, 87, 113],
    60: [34, 51, 72, 96, 123],
    65: [39, 57, 79, 104, 132],
    70: [44, 62, 85, 112, 141],
    75: [49, 68, 92, 119, 149],
    80: [53, 74, 98, 127, 157],
    85: [58, 79, 105, 134, 165],
    90: [62, 84, 111, 141, 172],
    95: [67, 89, 116, 147, 180],
    100: [71, 94, 122, 153, 187],
    105: [75, 99, 128, 160, 194],
    110: [80, 104, 133, 166, 200],
    115: [84, 109, 138, 172, 207],
    120: [88, 113, 143, 177, 213],
    125: [92, 118, 148, 183, 219],
    130: [95, 122, 153, 188, 225],
    135: [99, 126, 158, 194, 231],
    140: [103, 130, 163, 199, 236]
}

# 여성 체중별 무게 데이터 (표에서 가져온 값)
female_weight_data = {
    40: [8, 18, 32, 50, 70],
    45: [10, 21, 36, 55, 76],
    50: [12, 24, 40, 59, 82],
    55: [15, 27, 43, 64, 87],
    60: [17, 29, 47, 68, 92],
    65: [19, 32, 50, 72, 96],
    70: [20, 34, 53, 75, 101],
    75: [22, 37, 56, 79, 105],
    80: [24, 39, 59, 82, 109],
    85: [26, 41, 62, 86, 112],
    90: [28, 44, 64, 89, 116],
    95: [29, 46, 67, 92, 119],
    100: [31, 48, 69, 95, 123],
    105: [33, 50, 72, 98, 126],
    110: [34, 52, 74, 100, 129],
    115: [36, 54, 76, 103, 132],
    120: [37, 56, 79, 106, 135]
}

# 나이별 데이터
ages = [15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90]

# 남성 나이별 무게 데이터 (표에서 가져온 값)
male_age_data = {
    15: [40, 59, 84, 113, 144],
    20: [46, 68, 96, 129, 164],
    25: [47, 70, 98, 132, 169],
    30: [47, 70, 98, 132, 169],
    35: [47, 70, 98, 132, 169],
    40: [47, 70, 98, 132, 169],
    45: [44, 66, 93, 125, 160],
    50: [42, 62, 87, 117, 149],
    55: [38, 57, 80, 108, 138],
    60: [35, 52, 73, 99, 126],
    65: [32, 47, 66, 89, 114],
    70: [29, 42, 60, 80, 103],
    75: [26, 38, 54, 72, 92],
    80: [23, 34, 48, 64, 82],
    85: [20, 30, 43, 58, 74],
    90: [18, 27, 39, 52, 66]
}

# 여성 나이별 무게 데이터 (표에서 가져온 값)
female_age_data = {
    15: [15, 27, 43, 63, 86],
    20: [17, 31, 49, 72, 98],
    25: [17, 31, 51, 74, 101],
    30: [17, 31, 51, 74, 101],
    35: [17, 31, 51, 74, 101],
    40: [17, 31, 51, 74, 101],
    45: [16, 30, 48, 70, 96],
    50: [15, 28, 45, 66, 89],
    55: [14, 26, 41, 61, 83],
    60: [13, 23, 38, 55, 75],
    65: [12, 21, 34, 50, 68],
    70: [11, 19, 31, 45, 61],
    75: [9, 17, 28, 40, 55],
    80: [8, 15, 25, 36, 49],
    85: [8, 14, 22, 32, 44],
    90: [7, 12, 20, 29, 40]
}

def generate_bodyweight_sql(gender, weight_data, weights_list, exercise_name, exercise_name_en):
    """체중별 SQL 생성"""
    sql_lines = []
    gender_name = '남성' if gender == 'MALE' else '여성'
    
    sql_lines.append(f'-- ============================================')
    sql_lines.append(f'-- 체중별 데이터 ({gender_name}, 나이 NULL)')
    sql_lines.append(f'-- ============================================')
    
    for i, w in enumerate(weights_list):
        if i == 0:
            min_bw = 0.0 if gender == 'FEMALE' else 40.0  # 여성은 0.0kg부터, 남성은 40.0kg부터 시작
            if len(weights_list) > 1:
                max_bw = float(weights_list[i+1]) - 0.01
            else:
                max_bw = 999.0
        elif i == len(weights_list) - 1:
            min_bw = float(weights_list[i-1])
            max_bw = 999.0
        else:
            min_bw = float(weights_list[i-1])
            max_bw = float(weights_list[i+1]) - 0.01
        
        sql_lines.append(f'-- 체중 {w}kg → {min_bw}kg ~ {max_bw}kg')
        for j, level in enumerate(levels):
            weight_kg = weight_data[w][j]
            sql_lines.append(f"INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)")
            sql_lines.append(f"SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', {min_bw}, {max_bw}, NULL, NULL, '{gender}', '{level}', {weight_kg}.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP")
            sql_lines.append(f"FROM exercises e WHERE e.name = '{exercise_name}' OR e.name_en = '{exercise_name_en}' ON CONFLICT DO NOTHING;")
            sql_lines.append('')
    
    return sql_lines

def generate_age_sql(gender, age_data, exercise_name, exercise_name_en):
    """나이별 SQL 생성"""
    sql_lines = []
    gender_name = '남성' if gender == 'MALE' else '여성'
    
    sql_lines.append(f'-- ============================================')
    sql_lines.append(f'-- 나이별 데이터 ({gender_name}, 체중 범위 NULL)')
    sql_lines.append(f'-- ============================================')
    
    for i, age in enumerate(ages):
        if i == 0:
            min_age = 15
            max_age = 19
        elif i == len(ages) - 1:
            min_age = 90
            max_age = 999
        else:
            min_age = age
            max_age = ages[i+1] - 1
        
        sql_lines.append(f'-- 나이 {age}세 → {min_age}세 ~ {max_age}세')
        for j, level in enumerate(levels):
            weight_kg = age_data[age][j]
            sql_lines.append(f"INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)")
            sql_lines.append(f"SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, {min_age}, {max_age}, '{gender}', '{level}', {weight_kg}.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP")
            sql_lines.append(f"FROM exercises e WHERE e.name = '{exercise_name}' OR e.name_en = '{exercise_name_en}' ON CONFLICT DO NOTHING;")
            sql_lines.append('')
    
    return sql_lines

def generate_bench_press_sql(gender):
    """벤치프레스 SQL 생성 (남성 또는 여성)"""
    sql_lines = []
    gender_name = '남성' if gender == 'MALE' else '여성'
    weight_data = male_weight_data if gender == 'MALE' else female_weight_data
    weights_list = male_weights if gender == 'MALE' else female_weights
    age_data = male_age_data if gender == 'MALE' else female_age_data
    
    # 헤더
    sql_lines.append('-- ============================================')
    sql_lines.append('-- 벤치프레스 (Bench Press - Powerlifting) Strength Standards')
    sql_lines.append(f'-- {gender_name} 데이터 (체중별 + 나이별)')
    sql_lines.append('-- ============================================')
    sql_lines.append('-- 데이터 수집: https://strengthlevel.com/strength-standards/bench-press')
    sql_lines.append('--')
    sql_lines.append('-- 주의: 데이터베이스에 \'Bench Press - Powerlifting\'로 저장되어 있습니다.')
    sql_lines.append('-- 한글명 \'벤치프레스\' 또는 영문명 \'Bench Press - Powerlifting\'로 찾습니다.')
    sql_lines.append('')
    
    # 체중별 데이터
    sql_lines.extend(generate_bodyweight_sql(gender, weight_data, weights_list, '벤치프레스', 'Bench Press - Powerlifting'))
    
    # 나이별 데이터
    sql_lines.extend(generate_age_sql(gender, age_data, '벤치프레스', 'Bench Press - Powerlifting'))
    
    return sql_lines

# 남성 데이터 생성
male_sql = generate_bench_press_sql('MALE')
with open('database/bench_press_male_standards.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(male_sql))

print('SQL 파일 생성 완료: database/bench_press_male_standards.sql')
print(f'   총 {len(male_sql)} 줄')
print('')
print('생성된 데이터:')
print(f'   - 남성 체중별: {len(male_weights)}개 체중 x 5개 레벨 = {len(male_weights) * 5}개 INSERT')
print(f'   - 남성 나이별: {len(ages)}개 나이 x 5개 레벨 = {len(ages) * 5}개 INSERT')
print(f'   - 총 {len(male_weights) * 5 + len(ages) * 5}개 INSERT 문')
print('')

# 여성 데이터 생성
female_sql = generate_bench_press_sql('FEMALE')
with open('database/bench_press_female_standards.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(female_sql))

print('SQL 파일 생성 완료: database/bench_press_female_standards.sql')
print(f'   총 {len(female_sql)} 줄')
print('')
print('생성된 데이터:')
print(f'   - 여성 체중별: {len(female_weights)}개 체중 x 5개 레벨 = {len(female_weights) * 5}개 INSERT')
print(f'   - 여성 나이별: {len(ages)}개 나이 x 5개 레벨 = {len(ages) * 5}개 INSERT')
print(f'   - 총 {len(female_weights) * 5 + len(ages) * 5}개 INSERT 문')
