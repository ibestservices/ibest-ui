import { IBestStringNumber } from '../../model/Global.type'
import { generateId } from '../../utils/utils'
/**
 * 高亮类型
 */
export type IBestInputHighlightType = 'border' | 'shadow'
/**
 * 输入框model
 */
export class IBestCarInputModel {
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
export interface IBestCarKeyboardConfig {
	title?: ResourceStr,
	confirmBtnText?: ResourceStr
	keyHeight?: IBestStringNumber
}