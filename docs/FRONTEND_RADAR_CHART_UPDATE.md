# 프론트엔드 개발자용: 레이더 차트 API 업데이트 가이드

## 개요

레이더 차트 API가 개선되어 초기 평가와 현재 평가를 비교할 수 있는 기능이 추가되었습니다.

## API 변경사항

### 엔드포인트

**기존**: `GET /api/members/:id/abilities/hexagon`

**변경**: 동일하지만 쿼리 파라미터 추가 가능

### 요청 예시

#### 1. 기본 조회 (기존과 동일)

```typescript
GET /api/members/{memberId}/abilities/hexagon
```

**응답 형식** (기존과 동일):
```json
{
  "success": true,
  "data": {
    "indicators": [
      { "name": "하체 근력", "score": 75 },
      { "name": "심폐 지구력", "score": 60 },
      { "name": "근지구력", "score": 70 },
      { "name": "유연성", "score": 65 },
      { "name": "체성분 밸런스", "score": 80 },
      { "name": "부상 안정성", "score": 72 }
    ],
    "assessedAt": "2024-03-15T10:00:00Z",
    "version": "v1"
  },
  "message": "능력치 헥사곤 조회 성공"
}
```

#### 2. 초기 평가 비교 포함 (신규)

```typescript
GET /api/members/{memberId}/abilities/hexagon?compare=true
```

**응답 형식** (신규):
```json
{
  "success": true,
  "data": {
    "indicators": [
      { "name": "하체 근력", "score": 75 },
      { "name": "심폐 지구력", "score": 60 },
      { "name": "근지구력", "score": 70 },
      { "name": "유연성", "score": 65 },
      { "name": "체성분 밸런스", "score": 80 },
      { "name": "부상 안정성", "score": 72 }
    ],
    "assessedAt": "2024-03-15T10:00:00Z",
    "version": "v1",
    "initial": {
      "indicators": [
        { "name": "하체 근력", "score": 50 },
        { "name": "심폐 지구력", "score": 45 },
        { "name": "근지구력", "score": 55 },
        { "name": "유연성", "score": 50 },
        { "name": "체성분 밸런스", "score": 40 },
        { "name": "부상 안정성", "score": 60 }
      ],
      "assessedAt": "2024-01-15T10:00:00Z",
      "version": "v1"
    }
  },
  "message": "능력치 헥사곤 조회 성공"
}
```

**주의사항**:
- `initial` 필드는 초기 평가가 없으면 `null`입니다.
- 초기 평가가 없는 경우: `"initial": null`

## TypeScript 타입 정의

```typescript
interface HexagonIndicator {
  name: string;
  score: number;
}

interface HexagonData {
  indicators: HexagonIndicator[];
  assessedAt: string;
  version: string;
}

interface HexagonDataWithComparison extends HexagonData {
  initial: HexagonData | null;
}

interface HexagonResponse {
  success: boolean;
  data: HexagonData | HexagonDataWithComparison;
  message: string;
}
```

## 프론트엔드 구현 가이드

### 1. API 호출 함수 수정

**기존 코드**:
```typescript
async function getHexagonData(memberId: string): Promise<HexagonData> {
  const response = await fetch(`/api/members/${memberId}/abilities/hexagon`);
  const result: HexagonResponse = await response.json();
  return result.data as HexagonData;
}
```

**수정된 코드**:
```typescript
async function getHexagonData(
  memberId: string,
  includeInitial: boolean = false
): Promise<HexagonData | HexagonDataWithComparison> {
  const url = `/api/members/${memberId}/abilities/hexagon${
    includeInitial ? '?compare=true' : ''
  }`;
  const response = await fetch(url);
  const result: HexagonResponse = await response.json();
  return result.data;
}
```

### 2. 레이더 차트 컴포넌트 개선

#### 2.1 점수 표시 기능 추가

각 축에 점수(0-100) 숫자를 표시합니다.

**예시 (Recharts 사용 시)**:
```typescript
import { RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, LabelList } from 'recharts';

function AbilityRadarChart({ data, initialData }: Props) {
  return (
    <RadarChart data={data}>
      <PolarGrid />
      <PolarAngleAxis dataKey="name" />
      <PolarRadiusAxis angle={90} domain={[0, 100]} />
      
      {/* 현재 평가 */}
      <Radar
        name="현재"
        dataKey="score"
        stroke="#8884d8"
        fill="#8884d8"
        fillOpacity={0.6}
      >
        <LabelList dataKey="score" position="top" />
      </Radar>
      
      {/* 초기 평가 (있는 경우) */}
      {initialData && (
        <Radar
          name="초기"
          dataKey="score"
          stroke="#888888"
          fill="#888888"
          fillOpacity={0.3}
        />
      )}
    </RadarChart>
  );
}
```

#### 2.2 초기 vs 현재 비교 표시

**스타일 가이드**:
- **초기 평가**: 회색 선 (`#888888` 또는 `gray`)
- **현재 평가**: 색상 선 (예: `#8884d8` 또는 브랜드 색상)
- **점수 라벨**: 각 축에 점수 숫자 표시

**예시**:
```typescript
function AbilityRadarChart({ currentData, initialData }: Props) {
  // 데이터 변환 (Recharts 형식)
  const currentRadarData = currentData.indicators.map((indicator, index) => ({
    name: indicator.name,
    score: indicator.score,
    initial: initialData?.indicators[index]?.score || 0,
  }));

  return (
    <RadarChart data={currentRadarData}>
      <PolarGrid />
      <PolarAngleAxis dataKey="name" />
      <PolarRadiusAxis angle={90} domain={[0, 100]} />
      
      {/* 초기 평가 (회색) */}
      {initialData && (
        <Radar
          name="초기 평가"
          dataKey="initial"
          stroke="#888888"
          fill="#888888"
          fillOpacity={0.2}
          strokeWidth={2}
        />
      )}
      
      {/* 현재 평가 (색상) */}
      <Radar
        name="현재 평가"
        dataKey="score"
        stroke="#8884d8"
        fill="#8884d8"
        fillOpacity={0.6}
        strokeWidth={2}
      >
        <LabelList dataKey="score" position="top" />
      </Radar>
    </RadarChart>
  );
}
```

#### 2.3 툴팁 개선

**예시**:
```typescript
import { Tooltip } from 'recharts';

const CustomTooltip = ({ active, payload }: any) => {
  if (active && payload && payload.length) {
    const current = payload.find((p: any) => p.dataKey === 'score');
    const initial = payload.find((p: any) => p.dataKey === 'initial');
    
    return (
      <div className="bg-white p-3 border rounded shadow">
        <p className="font-bold">{payload[0].payload.name}</p>
        {current && (
          <p className="text-blue-600">
            현재: {current.value}점
          </p>
        )}
        {initial && initial.value > 0 && (
          <p className="text-gray-600">
            초기: {initial.value}점
            {current && (
              <span className="ml-2">
                ({current.value > initial.value ? '+' : ''}
                {current.value - initial.value}점)
              </span>
            )}
          </p>
        )}
      </div>
    );
  }
  return null;
};

// RadarChart에 추가
<Tooltip content={<CustomTooltip />} />
```

### 3. 컴포넌트 사용 예시

```typescript
function MemberAbilityPage({ memberId }: { memberId: string }) {
  const [hexagonData, setHexagonData] = useState<HexagonDataWithComparison | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      try {
        const data = await getHexagonData(memberId, true); // 초기 평가 포함
        setHexagonData(data as HexagonDataWithComparison);
      } catch (error) {
        console.error('레이더 차트 데이터 조회 실패:', error);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, [memberId]);

  if (loading) return <div>로딩 중...</div>;
  if (!hexagonData) return <div>데이터가 없습니다.</div>;

  return (
    <div>
      <h2>능력치 레이더 차트</h2>
      <AbilityRadarChart
        currentData={hexagonData}
        initialData={hexagonData.initial}
      />
      <p className="text-sm text-gray-600 mt-4">
        이건 성적표가 아니라 운동 설계 지도입니다.
      </p>
    </div>
  );
}
```

## 주요 변경사항 요약

1. **API 호출**: `?compare=true` 쿼리 파라미터 추가
2. **응답 형식**: `initial` 필드 추가 (초기 평가가 없으면 `null`)
3. **레이더 차트**: 
   - 점수 표시 기능 추가
   - 초기 평가 vs 현재 평가 비교 표시
   - 초기 평가: 회색 선
   - 현재 평가: 색상 선
4. **툴팁**: 초기 vs 현재 비교 정보 표시

## 체크리스트

- [ ] API 호출 함수 수정 (`compare=true` 파라미터 추가)
- [ ] TypeScript 타입 정의 추가 (`HexagonDataWithComparison`)
- [ ] 레이더 차트 컴포넌트에 점수 표시 기능 추가
- [ ] 초기 평가 선 추가 (회색)
- [ ] 현재 평가 선 스타일 확인 (색상)
- [ ] 툴팁 개선 (초기 vs 현재 비교)
- [ ] 초기 평가가 없는 경우 처리 (`initial: null`)
- [ ] 반응형 디자인 확인
- [ ] 테스트 (초기 평가 있는/없는 회원 모두)

## 문의사항

백엔드 개발자에게 문의하세요.

