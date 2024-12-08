import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { getSizeByUnit, padZero } from '../../utils/utils';

interface CurrentTime {
	days: number;
	hours: number;
	total: number;
	minutes: number;
	seconds: number;
	milliseconds: number;
};

const SECOND = 1000;
const MINUTE = 60 * SECOND;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;

function parseTime(time: number): CurrentTime {
	const days = Math.floor(time / DAY);
	const hours = Math.floor((time % DAY) / HOUR);
	const minutes = Math.floor((time % HOUR) / MINUTE);
	const seconds = Math.floor((time % MINUTE) / SECOND);
	const milliseconds = Math.floor(time % SECOND);

	return {
		total: time,
		days,
		hours,
		minutes,
		seconds,
		milliseconds,
	};
}

@Component
export struct IBestCountDown{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 倒计时时长 单位毫秒
     */
	@Prop time: number = 0
	/**
	 * 文字颜色
     */
	@Prop color: ResourceColor = GRAY_COLOR.GRAY_8
	/**
	 * 文字大小
     */
	@Prop fontSize: string | number = this.baseStyle.fontSizeMd
	/**
	 * 时间格式
     */
	@Prop format: string = 'HH:mm:ss'
	/**
	 * 是否自动开始倒计时
     */
	@Prop autoStart: boolean = true
	/**
	 * 是否开启毫秒级渲染
     */
	@Prop millisecond: boolean = false

	@State remain: number = 0
	endTime: number = 0
	timer: number = 0

	aboutToAppear(): void {
		this.endTime = Date.now() + this.time
		this.startCountDown()
	}

	aboutToDisappear(): void {
		this.clearTimer()
	}

	startCountDown(){
		if(this.millisecond){
			this.millisecondCountdown()
		}else {
			this.secondCountdown()
		}
	}

	getTimeText(){
		return this.parseFormat(this.format, parseTime(this.remain))
	}

	millisecondCountdown(){
		this.clearTimer()
		this.time = setTimeout(() => {
			let remain = this.getRemainSecond()
			if (!this.isSameSecond(remain, this.remain) || remain === 0) {
				this.remain = remain
			}
			if (this.remain > 0) {
				this.millisecondCountdown()
			}
		}, 30)
	}
	secondCountdown(){
		this.clearTimer()
		this.time = setTimeout(() => {
			this.remain = this.getRemainSecond()
			if(this.remain > 0){
				this.secondCountdown()
			}
		}, 30)
	}
	clearTimer(){
		clearTimeout(this.timer)
		this.timer = 0
	}
	getRemainSecond(){
		return Math.max(this.endTime - Date.now(), 0)
	}
	isSameSecond(time1: number, time2: number): boolean {
		return Math.floor(time1 / 1000) === Math.floor(time2 / 1000);
	}
	parseFormat(format: string, currentTime: CurrentTime): string {
		let days = currentTime.days,
			hours = currentTime.hours,
			minutes = currentTime.minutes,
			seconds = currentTime.seconds,
			milliseconds = currentTime.milliseconds
		if (format.includes('DD')) {
			format = format.replace('DD', padZero(currentTime.days))
		} else {
			hours += days * 24;
		}

		if (format.includes('HH')) {
			format = format.replace('HH', padZero(hours));
		} else {
			minutes += hours * 60;
		}

		if (format.includes('mm')) {
			format = format.replace('mm', padZero(minutes));
		} else {
			seconds += minutes * 60;
		}

		if (format.includes('ss')) {
			format = format.replace('ss', padZero(seconds));
		} else {
			milliseconds += seconds * 1000;
		}

		if (format.includes('S')) {
			const ms = padZero(milliseconds, 3);

			if (format.includes('SSS')) {
				format = format.replace('SSS', ms);
			} else if (format.includes('SS')) {
				format = format.replace('SS', ms.slice(0, 2));
			} else {
				format = format.replace('S', ms.charAt(0));
			}
		}

		return format;
	}

	build() {
		Text(this.getTimeText())
			.fontColor(this.color)
			.fontSize(getSizeByUnit(this.fontSize, true))
	}
}