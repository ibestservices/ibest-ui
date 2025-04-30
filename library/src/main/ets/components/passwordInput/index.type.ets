import { generateId } from '../../utils/utils'
/**
 * 输入框model
 */
export class IBestPasswordInputModel {
	public id: string = ''
	public value: string = ''
	constructor(value: string) {
		if(value){
			this.value = value
			this.id = generateId()
		}
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