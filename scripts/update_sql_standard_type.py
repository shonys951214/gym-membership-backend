#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
addExercise.sql 파일에 standard_type 컬럼 추가 스크립트
"""

import re

# SQL 파일 읽기
with open('database/addExercise.sql', 'r', encoding='utf-8') as f:
    content = f.read()

# 체중별 데이터 INSERT 문에 standard_type 추가
# 패턴: INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, ...
# -> INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, ...

# 체중별 데이터 (나이 NULL인 것들) - standard_type = 'BODYWEIGHT' 추가
pattern1 = r"(INSERT INTO strength_standards \(id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at\)\s+SELECT gen_random_uuid\(\), e\.id, )([^,]+), ([^,]+), NULL, NULL,"
replacement1 = r"\1'BODYWEIGHT', \2, \3, NULL, NULL,"

content = re.sub(pattern1, replacement1, content)

# 나이별 데이터 (bodyweight_min=0.0, bodyweight_max=999.0인 것들) - standard_type = 'AGE' 추가, bodyweight는 NULL로
pattern2 = r"(INSERT INTO strength_standards \(id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at\)\s+SELECT gen_random_uuid\(\), e\.id, )0\.0, 999\.0,"
replacement2 = r"\1'AGE', NULL, NULL,"

content = re.sub(pattern2, replacement2, content)

# 파일 저장
with open('database/addExercise.sql', 'w', encoding='utf-8') as f:
    f.write(content)

print("SQL 파일 수정 완료!")
