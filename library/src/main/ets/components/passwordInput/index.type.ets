/**
 * 输入框model
 */
export class IBestPasswordInputModel {
	public value: string
	constructor(value: string) {
		this.value = value
	}
}
/**
 * 自定义键盘配置
 */
export interface NumberKeyboardConfig {
	title?: string,
	extraKey?: string | string[],
	closeBtnText?: string,
	deleteButtonText?: string,
	styleType?: 'default' | 'custom',
	isRandomKeyOrder?: boolean
}