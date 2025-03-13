import { IBestStringNumber } from '../../model/Global.type'

/**
 * 按钮尺寸样式的类型
 */
export interface BtnSizeStyle {
	height: IBestStringNumber
	padding: IBestStringNumber
	width?: IBestStringNumber
}
/**
 * 按钮尺寸对象数据
 */
export class ButtonSizeData {
	padding: IBestStringNumber
	height: IBestStringNumber
	fontSize: IBestStringNumber
	width?: IBestStringNumber
	constructor(padding: IBestStringNumber, height: IBestStringNumber, fontSize: IBestStringNumber, width?: IBestStringNumber) {
		this.padding = padding;
		this.height = height;
		this.fontSize = fontSize
		this.width = width
	}
}