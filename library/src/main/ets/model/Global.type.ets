/**
 * 加载图标类型
 */
export type LoadingIconType = 'circular' | 'spinner'
/**
 * 文字换行类型
 */
export type WordBreakType = 'normal' | 'break-all' | 'break-word'
/**
 * 字符串或数字类型
 */
export type IBestStringNumber = string | number
/**
 * 等待
 */
export type IBestAwaitable = Promise<boolean> | boolean
/**
 * 位置类型
 */
export interface IBestEdges {
    top?: number
	left?: number
    right?: number
	bottom?: number
}
/**
 * 宽高尺寸
 */
export interface IBestSize{
	width: IBestStringNumber
	height: IBestStringNumber
}
/**
 * 组件信息类型
 */
export interface ComInfoType {
    width: number
    height: number
    localLeft: number
    localTop: number
    screenLeft: number
    screenTop: number
    windowTop: number
    windowLeft: number
}
/**
 * 窗口规避尺寸信息
 */
export interface ComAvoidAreaSize{
    topSize: number
    bottomSize: number
    leftSize: number
    rightSize: number
    navigationSize: number
}

type IBestLengthUnit = "vp" | "px" | "lpx"
type IBestFontUnit = IBestLengthUnit | "fp"
/**
 * 全局配置信息
 */
export class IBestGlobalConfigType{
    /**
     * 标识页面设计基准宽度 默认720px
     */
    designWidth?: number
    /**
     * 全局尺寸单位, 默认vp
     */
    unit?: IBestLengthUnit
    /**
     * 全局字体尺寸单位, 默认fp
     */
    fontUnit?: IBestFontUnit
}
export class IBestGlobalConfig extends IBestGlobalConfigType {
    constructor(option?: IBestGlobalConfigType) {
        super()
        this.designWidth = option?.designWidth || 720
        this.unit = option?.unit || "vp"
        this.fontUnit = option?.fontUnit || "fp"
    }
}