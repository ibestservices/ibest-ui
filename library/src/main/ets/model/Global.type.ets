import { IBestUIBaseStyleType } from "../theme-chalk/src/index.type"
import { window } from "@kit.ArkUI"
import { common } from "@kit.AbilityKit"
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

export interface IBestGlobalVoid{
    /**
     * 初始化组件库
     */
    init: (windowStage: window.WindowStage, context: common.UIAbilityContext) => void
    /**
     * 设置全局配置
     * @param option
     */
    setGlobalConfig: (option?: IBestGlobalConfigType) => void
    /**
     * 设置全局主题样式
     * @param styleData
     */
    setUIBaseStyle: (styleData?: Partial<IBestUIBaseStyleType>) => void
}