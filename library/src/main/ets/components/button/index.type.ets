/**
 * 按钮尺寸样式的类型
 */
export interface BtnSizeStyle {
	height: string | number;
	padding: string | number;
	width?: string | number;
}
/**
 * 按钮尺寸对象数据
 */
export class ButtonSizeData {
	padding: string | number
	height: string | number
	fontSize: string | number
	width?: string | number
	constructor(padding: string | number, height: string | number, fontSize: string | number, width?: string | number) {
		this.padding = padding;
		this.height = height;
		this.fontSize = fontSize
		this.width = width
	}
}