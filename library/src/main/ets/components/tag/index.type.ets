import { IBestStringNumber } from "../../model/Global.type";

/**
 * 按钮尺寸对象数据
 */
export class TagSizeData {
	padding: IBestStringNumber
	height: IBestStringNumber
	fontSize: IBestStringNumber
	borderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses
	constructor(padding: IBestStringNumber, height: IBestStringNumber, fontSize: IBestStringNumber,
		borderRadius: BorderRadiuses | Length) {
		this.padding = padding;
		this.height = height;
		this.fontSize = fontSize
		this.borderRadius = borderRadius
	}
}