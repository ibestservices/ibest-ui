import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { getSizeByUnit, padZero } from '../../utils/utils'
import { IBestCountDownColor } from './color'
import { CurrentTime, IBestCountDownController } from './index.type'

const SECOND = 1000
const MINUTE = 60 * SECOND
const HOUR = 60 * MINUTE
const DAY = 24 * HOUR

function parseTime(time: number): CurrentTime {
	const days = Math.floor(time / DAY)
	const hours = Math.floor((time % DAY) / HOUR)
	const minutes = Math.floor((time % HOUR) / MINUTE)
	const seconds = Math.floor((time % MINUTE) / SECOND)
	const milliseconds = Math.floor(time % SECOND)

	return {
		total: time,
		days,
		hours,
		minutes,
		seconds,
		milliseconds,
	}
}

@Component
export struct IBestCountDown{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 倒计时时长 单位毫秒
     */
	@Prop time: number = 0
	/**
	 * 文字颜色
     */
	@Prop color: ResourceColor = IBestCountDownColor.textColor
	/**
	 * 文字大小
     */
	@Prop fontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 时间格式
     */
	@Prop format: string = 'HH:mm:ss'
	/**
	 * 是否自动开始倒计时
     */
	@Prop autoStart: boolean = true
	/**
	 * 结束事件
	 * @since 2.1.3
     */
	onFinish: () => void = () => {}
	/**
	 * 实例
     */
	controller: IBestCountDownController = new IBestCountDownController()

	@State isCounting: boolean = false
	@State remain: number = 0
	endTime: number = 0
	timer: number = 0

	aboutToAppear(): void {
		this.controller.start = (): void => this.startCountDown()
		this.controller.pause = (): void => this.pause()
		this.controller.reset = (totalTime?: number): void => this.reset(totalTime)
		this.remain = this.time
		if(this.autoStart){
			this.startCountDown()
		}
	}
	aboutToDisappear(): void {
		this.clearTimer()
	}
	startCountDown(){
		if(!this.isCounting){
			this.endTime = Date.now() + this.remain
			this.secondCountdown()
			this.isCounting = true
		}
	}
	pause(){
		this.isCounting = false
	}
	reset(totalTime: number = this.time){
		this.pause()
		this.remain = totalTime
	}
	getTimeText(){
		return this.parseFormat(this.format, parseTime(this.remain))
	}
	secondCountdown(){
		this.clearTimer()
		this.timer = setTimeout(() => {
			if(this.isCounting){
				this.remain = this.getRemainSecond()
				if(this.remain > 0){
					this.secondCountdown()
				}else {
					this.onFinish()
				}
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
	parseFormat(format: string, currentTime: CurrentTime): string {
		let days = currentTime.days,
			hours = currentTime.hours,
			minutes = currentTime.minutes,
			seconds = currentTime.seconds,
			milliseconds = currentTime.milliseconds
		if (format.includes('DD')) {
			format = format.replace('DD', padZero(currentTime.days))
		} else {
			hours += days * 24
		}

		if (format.includes('HH')) {
			format = format.replace('HH', padZero(hours))
		} else {
			minutes += hours * 60
		}

		if (format.includes('mm')) {
			format = format.replace('mm', padZero(minutes))
		} else {
			seconds += minutes * 60
		}

		if (format.includes('ss')) {
			format = format.replace('ss', padZero(seconds))
		} else {
			milliseconds += seconds * 1000
		}

		if (format.includes('S')) {
			const ms = padZero(milliseconds, 3)

			if (format.includes('SSS')) {
				format = format.replace('SSS', ms)
			} else if (format.includes('SS')) {
				format = format.replace('SS', ms.slice(0, 2))
			} else {
				format = format.replace('S', ms.charAt(0))
			}
		}

		return format
	}

	build() {
		Text(this.getTimeText())
			.fontColor(this.color)
			.fontSize(getSizeByUnit(this.fontSize, true))
	}
}