#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
데드리프트 Strength Standards SQL 생성 스크립트
체중별 + 나이별 데이터 생성 (남성 + 여성)
"""

# 체중별 데이터 (남성: 50~140kg, 여성: 40~120kg)
male_weights = [50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140]
female_weights = [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120]
levels = ['BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE']

# 나이별 데이터
ages = [15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90]

# 남성 체중별 무게 데이터 (표에서 가져온 값)
male_weight_data = {
    50: [44, 65, 93, 125, 160],
    55: [51, 74, 103, 137, 174],
    60: [58, 83, 114, 149, 187],
    65: [66, 92, 124, 160, 200],
    70: [73, 100, 133, 171, 212],
    75: [79, 108, 142, 182, 224],
    80: [86, 116, 151, 192, 235],
    85: [93, 123, 160, 201, 245],
    90: [99, 131, 168, 211, 256],
    95: [105, 138, 176, 220, 266],
    100: [111, 145, 184, 228, 275],
    105: [117, 151, 192, 237, 284],
    110: [123, 158, 199, 245, 293],
    115: [129, 164, 206, 253, 302],
    120: [134, 171, 213, 261, 311],
    125: [140, 177, 220, 268, 319],
    130: [145, 183, 227, 276, 327],
    135: [150, 188, 233, 283, 335],
    140: [155, 194, 240, 290, 342]
}

# 남성 나이별 무게 데이터 (표에서 가져온 값)
male_age_data = {
    15: [67, 95, 130, 170, 214],
    20: [76, 109, 148, 194, 244],
    25: [78, 112, 152, 200, 250],
    30: [78, 112, 152, 200, 250],
    35: [78, 112, 152, 200, 250],
    40: [78, 112, 152, 200, 250],
    45: [74, 106, 144, 189, 237],
    50: [69, 99, 135, 177, 222],
    55: [64, 91, 124, 163, 205],
    60: [59, 83, 114, 149, 187],
    65: [53, 75, 103, 135, 169],
    70: [48, 68, 93, 121, 152],
    75: [43, 61, 83, 109, 136],
    80: [38, 54, 74, 97, 122],
    85: [34, 49, 67, 87, 109],
    90: [31, 44, 60, 78, 98]
}

# 여성 체중별 무게 데이터 (표에서 가져온 값)
female_weight_data = {
    40: [24, 40, 62, 89, 118],
    45: [27, 45, 68, 95, 126],
    50: [31, 49, 73, 102, 133],
    55: [34, 53, 78, 107, 140],
    60: [37, 57, 83, 113, 146],
    65: [40, 61, 87, 118, 152],
    70: [43, 64, 91, 123, 157],
    75: [45, 67, 95, 127, 163],
    80: [48, 71, 99, 132, 168],
    85: [51, 74, 102, 136, 172],
    90: [53, 77, 106, 140, 177],
    95: [55, 79, 109, 144, 181],
    100: [58, 82, 112, 147, 185],
    105: [60, 85, 116, 151, 189],
    110: [62, 87, 119, 154, 193],
    115: [64, 90, 121, 158, 197],
    120: [66, 92, 124, 161, 200]
}

# 여성 나이별 무게 데이터 (표에서 가져온 값)
female_age_data = {
    15: [33, 51, 74, 103, 134],
    20: [37, 58, 85, 117, 153],
    25: [38, 60, 87, 120, 157],
    30: [38, 60, 87, 120, 157],
    35: [38, 60, 87, 120, 157],
    40: [38, 60, 87, 120, 157],
    45: [36, 57, 83, 114, 148],
    50: [34, 53, 77, 107, 139],
    55: [31, 49, 71, 98, 128],
    60: [28, 45, 65, 90, 117],
    65: [26, 40, 59, 81, 106],
    70: [23, 36, 53, 73, 95],
    75: [21, 33, 48, 66, 85],
    80: [19, 29, 43, 59, 76],
    85: [17, 26, 38, 53, 68],
    90: [15, 23, 34, 47, 61]
}

def generate_sql(exercise_name_kr, exercise_name_en, gender, gender_name, weights_data, ages_data, output_file):
    """SQL 생성 함수"""
    sql_lines = []
    sql_lines.append(f'-- ============================================')
    sql_lines.append(f'-- {exercise_name_kr} ({exercise_name_en}) Strength Standards')
    sql_lines.append(f'-- {gender_name} 데이터 (체중별 + 나이별)')
    sql_lines.append(f'-- ============================================')
    sql_lines.append(f'-- 데이터 수집: https://strengthlevel.com/strength-standards/{exercise_name_en.lower().replace(" ", "-")}')
    sql_lines.append(f'--')
    sql_lines.append(f'-- 주의: 데이터베이스에 \'{exercise_name_en}\'로 저장되어 있습니다.')
    sql_lines.append(f'-- 한글명 \'{exercise_name_kr}\' 또는 영문명 \'{exercise_name_en}\'로 찾습니다.')
    sql_lines.append('')

    # 체중별 데이터
    sql_lines.append('-- ============================================')
    sql_lines.append(f'-- 체중별 데이터 ({gender_name}, 나이 NULL)')
    sql_lines.append('-- ============================================')

    weights_list = sorted(weights_data.keys())
    for i, w in enumerate(weights_list):
        min_bw = 0.0 if i == 0 and w == 40 and gender == 'FEMALE' else (40.0 if i == 0 and w == 50 and gender == 'MALE' else float(w))
        max_bw = float(weights_list[i+1]) - 0.01 if i < len(weights_list) - 1 else 999.0
        
        sql_lines.append(f'-- 체중 {w}kg → {min_bw}kg ~ {max_bw}kg')
        for j, level in enumerate(levels):
            weight_kg = weights_data[w][j]
            sql_lines.append(f"INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)")
            sql_lines.append(f"SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', {min_bw}, {max_bw}, NULL, NULL, '{gender}', '{level}', {weight_kg}.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP")
            sql_lines.append(f"FROM exercises e WHERE e.name = '{exercise_name_kr}' OR e.name_en = '{exercise_name_en}' ON CONFLICT DO NOTHING;")
            sql_lines.append('')

    # 나이별 데이터
    sql_lines.append('-- ============================================')
    sql_lines.append(f'-- 나이별 데이터 ({gender_name}, 체중 범위 NULL)')
    sql_lines.append('-- ============================================')

    ages_list = sorted(ages_data.keys())
    for i, age in enumerate(ages_list):
        min_age = age
        max_age = ages_list[i+1] - 1 if i < len(ages_list) - 1 else 999
        
        sql_lines.append(f'-- 나이 {age}세 → {min_age}세 ~ {max_age}세')
        for j, level in enumerate(levels):
            weight_kg = ages_data[age][j]
            sql_lines.append(f"INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)")
            sql_lines.append(f"SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, {min_age}, {max_age}, '{gender}', '{level}', {weight_kg}.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP")
            sql_lines.append(f"FROM exercises e WHERE e.name = '{exercise_name_kr}' OR e.name_en = '{exercise_name_en}' ON CONFLICT DO NOTHING;")
            sql_lines.append('')
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))

    print(f'SQL 파일 생성 완료: {output_file}')
    print(f'   총 {len(sql_lines)} 줄')
    print(f'생성된 데이터 요약:')
    print(f'   - {gender_name} 체중별: {len(weights_list)}개 체중 x {len(levels)}개 레벨 = {len(weights_list) * len(levels)}개 INSERT')
    print(f'   - {gender_name} 나이별: {len(ages_list)}개 나이 x {len(levels)}개 레벨 = {len(ages_list) * len(levels)}개 INSERT')
    print(f'   - 총 {len(weights_list) * len(levels) + len(ages_list) * len(levels)}개 INSERT 문')

# 데드리프트 남성 데이터 생성
generate_sql(
    '데드리프트',
    'Barbell Deadlift',
    'MALE',
    '남성',
    male_weight_data,
    male_age_data,
    'database/deadlift_male_standards.sql'
)

# 데드리프트 여성 데이터 생성
generate_sql(
    '데드리프트',
    'Barbell Deadlift',
    'FEMALE',
    '여성',
    female_weight_data,
    female_age_data,
    'database/deadlift_female_standards.sql'
)
