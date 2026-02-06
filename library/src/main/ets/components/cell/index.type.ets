import { IBestStringNumber } from "../../model/Global.type";

export enum ARROW_DIRECTION {
	TOP = 'top',
	RIGHT = 'right',
	BOTTOM = 'bottom',
	LEFT = 'left'
}
export class CellSizeData {
	padding: IBestStringNumber
	fontSize: IBestStringNumber
	labelFontSize: IBestStringNumber
	valueFontSize: IBestStringNumber
	constructor(padding: IBestStringNumber, fontSize: IBestStringNumber, labelFontSize: IBestStringNumber, valueFontSize: IBestStringNumber) {
		this.padding = padding
		this.fontSize = fontSize
		this.labelFontSize = labelFontSize
		this.valueFontSize = valueFontSize
	}
}