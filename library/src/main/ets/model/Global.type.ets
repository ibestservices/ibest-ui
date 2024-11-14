/**
 * 加载图标类型
 */
export type LoadingIconType = 'circular' | 'spinner'
/**
 * 文字换行类型
 */
export type WordBreakType = 'normal' | 'break-all' | 'break-word'
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

type IBestLengthUnit = "vp" | "px" | "fp" | "lpx"
/**
 * 全局配置信息
 */
export class IBestGlobalConfigType{
    designWidth?: number
    /**
     * 全局尺寸单位, 默认vp
     */
    unit?: IBestLengthUnit
    /**
     * 全局字体尺寸单位, 默认fp
     */
    fontUnit?: IBestLengthUnit
}
export class IBestGlobalConfig extends IBestGlobalConfigType {
    constructor(option?: IBestGlobalConfigType) {
        super()
        this.designWidth = option?.designWidth || 720
        this.unit = option?.unit || "vp"
        this.fontUnit = option?.fontUnit || this.unit
    }
}