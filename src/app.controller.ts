import { Controller, Get } from "@nestjs/common";
import { AppService } from "./app.service";
import { DateHelper } from "./common/utils/date-helper";

@Controller()
export class AppController {
	constructor(private readonly appService: AppService) {}

	@Get()
	getHello(): string {
		return this.appService.getHello();
	}

	@Get("health")
	getHealth() {
		return {
			status: "정상",
			timestamp: DateHelper.getKoreaTimeISOString(),
		};
	}
}
