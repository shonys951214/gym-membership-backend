// 대시보드 응답 DTO (타입 정의용)
export interface DashboardResponse {
	goal: {
		goal?: string;
		goalProgress: number;
		goalTrainerComment?: string;
	};
	sessionProgress: {
		totalSessions: number;
		completedSessions: number;
		progressPercentage: number;
	};
	workoutCalendar: Array<{
		date: string;
		ptSessions: Array<{
			id: string;
			sessionNumber: number;
			mainContent: string;
		}>;
		personalWorkouts: Array<{
			id: string;
			exerciseName: string;
			bodyPart: string;
		}>;
	}>;
	workoutAnalysis: {
		period: 'week' | 'month';
		bodyPartVolumes: Array<{
			bodyPart: string;
			volume: number;
		}>;
		totalVolume: number;
	};
}

