export enum ARROW_DIRECTION {
	TOP = 'top',
	RIGHT = 'right',
	BOTTOM = 'bottom',
	LEFT = 'left'
}
export type BorderSizeType = "full" | "center" | "right"
export class CellSizeData {
	padding?: string
	fontSize?: string
	labelFontSize?: string
	constructor(padding: string, fontSize: string, labelFontSize: string) {
		this.padding = padding;
		this.fontSize = fontSize;
		this.labelFontSize = labelFontSize
	}
}