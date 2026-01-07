# 프론트엔드 - 백엔드 API 비교 분석

## 인증 (Auth)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| POST /api/auth/login | POST /api/auth/login | ✅ |
| POST /api/auth/register | POST /api/auth/register | ✅ |
| POST /api/auth/logout | POST /api/auth/logout | ✅ |
| GET /api/auth/session | GET /api/auth/session | ✅ |

## 회원 관리 (Members)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members?page=&pageSize= | GET /api/members?page=&pageSize= | ✅ |
| GET /api/members/:id | GET /api/members/:id | ✅ |
| POST /api/members | POST /api/members | ✅ |
| PUT /api/members/:id | PUT /api/members/:id | ✅ |
| DELETE /api/members/:id | DELETE /api/members/:id | ✅ |

## 트레이너 승인 (Trainers)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/auth/pending-trainers | GET /api/auth/pending-trainers | ✅ |
| GET /api/auth/trainers | GET /api/auth/trainers | ✅ |
| POST /api/auth/approve-trainer/:id | POST /api/auth/approve-trainer/:id | ✅ |
| POST /api/auth/disapprove-trainer/:id | POST /api/auth/disapprove-trainer/:id | ✅ |
| DELETE /api/auth/reject-trainer/:id | DELETE /api/auth/reject-trainer/:id | ✅ |

## 목표 관리 (Goals)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/goals | GET /api/members/:id/goals | ✅ |
| POST /api/members/:id/goals | POST /api/members/:id/goals | ✅ |
| PUT /api/members/:id/goals | PUT /api/members/:id/goals | ✅ |
| DELETE /api/members/:id/goals | DELETE /api/members/:id/goals | ✅ |

## 평가 (Assessments)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/assessments | GET /api/members/:memberId/assessments | ✅ |
| GET /api/members/:id/assessments/:id | GET /api/members/:memberId/assessments/:id | ✅ |
| POST /api/members/:id/assessments | POST /api/members/:memberId/assessments | ✅ |
| PUT /api/members/:id/assessments/:id | PUT /api/members/:memberId/assessments/:id | ✅ |

## 능력치 (Abilities)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/abilities/latest | GET /api/members/:id/abilities/latest | ✅ |
| GET /api/members/:id/abilities/snapshots | GET /api/members/:id/abilities/snapshots | ✅ |
| GET /api/members/:id/abilities/compare?prev= | GET /api/members/:id/abilities/compare?prev= | ✅ |
| GET /api/members/:id/abilities/hexagon | GET /api/members/:id/abilities/hexagon | ✅ |
| GET /api/members/:id/abilities/history | GET /api/members/:id/abilities/history | ✅ |

## 부상 관리 (Injuries)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/injuries | GET /api/members/:memberId/injuries | ✅ |
| GET /api/members/:id/injuries/:id | GET /api/members/:memberId/injuries/:id | ✅ |
| POST /api/members/:id/injuries | POST /api/members/:memberId/injuries | ✅ |
| PUT /api/members/:id/injuries/:id | PUT /api/members/:memberId/injuries/:id | ✅ |
| POST /api/members/:id/injuries/:id/restrictions | POST /api/members/:memberId/injuries/:id/restrictions | ✅ |

## PT 세션 (PT Sessions)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/pt-sessions | GET /api/members/:id/pt-sessions | ✅ |
| GET /api/members/:id/pt-sessions/:id | GET /api/members/:id/pt-sessions/:sessionId | ✅ |
| POST /api/members/:id/pt-sessions | POST /api/members/:id/pt-sessions | ✅ |
| PUT /api/members/:id/pt-sessions/:id | PUT /api/members/:id/pt-sessions/:sessionId | ✅ |
| DELETE /api/members/:id/pt-sessions/:id | DELETE /api/members/:id/pt-sessions/:sessionId | ✅ |

## 운동 기록 (Workout Records)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/workout-records | GET /api/members/:id/workout-records | ✅ |
| GET /api/members/:id/workout-records/:id | GET /api/members/:id/workout-records/:recordId | ✅ |
| POST /api/members/:id/workout-records | POST /api/members/:id/workout-records | ✅ |
| PUT /api/members/:id/workout-records/:id | PUT /api/members/:id/workout-records/:recordId | ✅ |
| DELETE /api/members/:id/workout-records/:id | DELETE /api/members/:id/workout-records/:recordId | ✅ |
| GET /api/members/:id/workout-records/volume-analysis | GET /api/members/:id/workout-records/volume-analysis | ✅ |
| GET /api/members/:id/workout-records/calendar | GET /api/members/:id/workout-records/calendar | ✅ |

## 운동 루틴 (Workout Routines)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/workout-routines | GET /api/members/:id/workout-routines | ✅ |
| GET /api/members/:id/workout-routines/today | GET /api/members/:id/workout-routines/today | ✅ |
| GET /api/members/:id/workout-routines/:id | GET /api/members/:id/workout-routines/:routineId | ✅ |
| POST /api/members/:id/workout-routines | POST /api/members/:id/workout-routines | ✅ |
| PUT /api/members/:id/workout-routines/:id | PUT /api/members/:id/workout-routines/:routineId | ✅ |
| PUT /api/members/:id/workout-routines/:id/complete | PUT /api/members/:id/workout-routines/:routineId/complete | ✅ |
| DELETE /api/members/:id/workout-routines/:id | DELETE /api/members/:id/workout-routines/:routineId | ✅ |

## 공통 운동 루틴 (Common Workout Routines)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/workout-routines | GET /api/workout-routines | ✅ |
| GET /api/workout-routines/today | GET /api/workout-routines/today | ✅ |
| GET /api/workout-routines/:id | GET /api/workout-routines/:routineId | ✅ |
| POST /api/workout-routines | POST /api/workout-routines | ✅ |
| PUT /api/workout-routines/:id | PUT /api/workout-routines/:routineId | ✅ |
| DELETE /api/workout-routines/:id | DELETE /api/workout-routines/:routineId | ✅ |

## 분석 (Analytics)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/members/:id/analytics | GET /api/members/:id/analytics | ✅ |
| GET /api/analytics/averages | GET /api/analytics/averages | ✅ |
| GET /api/analytics/comparison/:id | GET /api/analytics/comparison/:memberId | ✅ |

## 인사이트 (Insights)
| 프론트엔드 API | 백엔드 엔드포인트 | 상태 |
|---------------|------------------|------|
| GET /api/insights/hexagon | GET /api/insights/hexagon | ✅ |
| GET /api/insights/weekly-summary | GET /api/insights/weekly-summary | ✅ |
| GET /api/insights/risk-members | GET /api/insights/risk-members | ✅ |

## 분석 결과

### ✅ 모든 API 엔드포인트가 백엔드에 구현되어 있습니다!

프론트엔드에서 요청하는 모든 API가 백엔드에 정상적으로 구현되어 있습니다. 
주요 확인 사항:
- 모든 CRUD 작업이 정상적으로 구현됨
- 페이지네이션 지원
- 필터링 및 쿼리 파라미터 지원
- 인증 및 권한 관리 구현
- 데이터 변환 및 정규화 처리

### 참고 사항
- 백엔드는 `:id`, `:recordId`, `:routineId`, `:sessionId` 등 명확한 파라미터명 사용
- 프론트엔드는 `:memberId`, `:injuryId`, `:assessmentId` 등 명확한 파라미터명 사용
- 실제로는 같은 엔드포인트이며, NestJS 라우팅이 올바르게 처리함

