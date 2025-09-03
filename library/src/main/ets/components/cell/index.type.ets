import { IBestStringNumber } from '../../../../../Index'

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
	constructor(padding: IBestStringNumber, fontSize: IBestStringNumber, labelFontSize: IBestStringNumber) {
		this.padding = padding;
		this.fontSize = fontSize;
		this.labelFontSize = labelFontSize
	}
}