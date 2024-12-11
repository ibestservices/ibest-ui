/**
 * 倒计时controller
 */
export class IBestCountDownController {
	/**
	 * 开始倒计时
     */
	start: () => void = () => {}
	/**
	 * 暂停倒计时
	 */
	pause: () => void = () => {}
	/**
	 * 重置倒计时
	 */
	reset: (time?: number) => void = () => {}
}
/**
 * 当前时间格式化类型
 */
export interface CurrentTime {
	days: number
	hours: number
	total: number
	minutes: number
	seconds: number
	milliseconds: number
}
