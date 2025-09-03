import { BorderRadiusData } from './border.type'
import { ColorData } from './color.type'
import { FontSizeData } from './font.type'
import { LineHeightData } from './line-height.type'
import { SpaceData } from './space.type'
/**
 * 根据默认的兜底style生成的类型
 */
export interface IBestUIBaseStyleType extends FontSizeData, ColorData, SpaceData, BorderRadiusData,
LineHeightData {
	// 滚动效果
	scrollEdgeEffect: EdgeEffect,
	// 滚动条颜色
	scrollBarColor: string,
	animationDuration: number
}
export type IBestUIBaseStyleValue = ResourceColor | EdgeEffect
export type IBestUIBaseStyleObjType = Record<keyof IBestUIBaseStyleType, IBestUIBaseStyleValue>