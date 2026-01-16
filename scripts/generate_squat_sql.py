#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
스쿼트 Strength Standards SQL 생성 스크립트
체중별 + 나이별 데이터 생성 (남성 + 여성)
"""

# 체중별 데이터 (남성: 50~140kg, 여성: 40~120kg)
male_weights = [50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140]
female_weights = [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120]
levels = ['BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE']

# 남성 체중별 무게 데이터 (표에서 가져온 값)
male_weight_data = {
    50: [33, 52, 76, 104, 136],
    55: [40, 60, 86, 116, 149],
    60: [47, 68, 95, 127, 161],
    65: [53, 76, 104, 137, 173],
    70: [59, 83, 113, 147, 184],
    75: [66, 91, 122, 157, 195],
    80: [72, 98, 130, 166, 205],
    85: [78, 105, 138, 175, 215],
    90: [83, 112, 146, 184, 225],
    95: [89, 118, 153, 192, 234],
    100: [95, 125, 160, 201, 243],
    105: [100, 131, 168, 209, 252],
    110: [106, 137, 174, 216, 260],
    115: [111, 143, 181, 224, 269],
    120: [116, 149, 188, 231, 277],
    125: [121, 155, 194, 238, 284],
    130: [126, 160, 201, 245, 292],
    135: [131, 166, 207, 252, 299],
    140: [136, 171, 213, 259, 307]
}

# 나이별 데이터
ages = [15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90]

# 남성 나이별 무게 데이터 (표에서 가져온 값)
male_age_data = {
    15: [55, 80, 111, 147, 187],
    20: [62, 91, 127, 168, 213],
    25: [64, 93, 130, 173, 219],
    30: [64, 93, 130, 173, 219],
    35: [64, 93, 130, 173, 219],
    40: [64, 93, 130, 173, 219],
    45: [61, 89, 123, 164, 208],
    50: [57, 83, 115, 153, 194],
    55: [52, 76, 106, 141, 179],
    60: [48, 70, 97, 129, 164],
    65: [43, 63, 88, 117, 148],
    70: [39, 57, 79, 105, 133],
    75: [35, 51, 71, 94, 119],
    80: [31, 46, 63, 84, 107],
    85: [28, 41, 57, 76, 96],
    90: [25, 37, 51, 68, 86]
}

# 여성 체중별 무게 데이터 (표에서 가져온 값)
female_weight_data = {
    40: [17, 31, 51, 75, 101],
    45: [20, 36, 56, 81, 109],
    50: [23, 39, 61, 87, 115],
    55: [26, 43, 65, 92, 122],
    60: [29, 47, 70, 97, 128],
    65: [32, 50, 74, 102, 133],
    70: [34, 53, 78, 106, 138],
    75: [37, 56, 81, 111, 143],
    80: [39, 59, 85, 115, 148],
    85: [41, 62, 88, 119, 152],
    90: [44, 65, 91, 123, 157],
    95: [46, 68, 95, 126, 161],
    100: [48, 70, 98, 130, 165],
    105: [50, 73, 101, 133, 169],
    110: [52, 75, 103, 136, 172],
    115: [54, 77, 106, 140, 176],
    120: [56, 80, 109, 143, 179]
}

# 여성 나이별 무게 데이터 (표에서 가져온 값)
female_age_data = {
    15: [25, 41, 62, 88, 116],
    20: [28, 45, 68, 95, 125],
    25: [30, 48, 73, 103, 136],
    30: [30, 48, 73, 103, 136],
    35: [30, 48, 73, 103, 136],
    40: [30, 48, 73, 103, 136],
    45: [28, 45, 68, 95, 125],
    50: [26, 42, 63, 88, 116],
    55: [24, 38, 57, 80, 105],
    60: [21, 34, 51, 71, 93],
    65: [19, 30, 45, 63, 82],
    70: [17, 27, 40, 56, 73],
    75: [15, 24, 35, 49, 64],
    80: [13, 21, 31, 43, 56],
    85: [12, 19, 29, 40, 52],
    90: [12, 19, 29, 40, 53]
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

# 스쿼트 남성 데이터 생성
generate_sql(
    '스쿼트',
    'Barbell Squat',
    'MALE',
    '남성',
    male_weight_data,
    male_age_data,
    'database/squat_male_standards.sql'
)

# 스쿼트 여성 데이터 생성
generate_sql(
    '스쿼트',
    'Barbell Squat',
    'FEMALE',
    '여성',
    female_weight_data,
    female_age_data,
    'database/squat_female_standards.sql'
)
