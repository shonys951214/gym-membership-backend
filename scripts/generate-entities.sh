#!/bin/bash
# TypeORM 모델 생성 스크립트
# 기존 데이터베이스 스키마로부터 엔티티 자동 생성

typeorm-model-generator \
  -h localhost \
  -d gym_membership \
  -u postgres \
  -x postgres \
  -e postgres \
  -o ./src/entities-generated \
  --noConfig true \
  --cf camelCase \
  --ce pascal \
  --cp camel

