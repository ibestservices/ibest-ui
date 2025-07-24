import { IBestStringNumber } from "../../model/Global.type"
export interface Chunk {
	start: number
	end: number
	highlight: boolean
	color?: ResourceColor
	fontSize?: IBestStringNumber
}
export type Chunks = Array<Chunk>
export interface IBestHighlightKeywords {
	/**
	 * 关键字
     */
	text: ResourceStr
	/**
	 * 关键字颜色
     */
	color?: ResourceColor
	/**
	 * 关键字大小
     */
	fontSize?: IBestStringNumber
}