/**
 * 加载图标类型
 */
export type IBestLoadingIconType = 'circular' | 'spinner'
/**
 * 文字换行类型
 */
export type IBestWordBreakType = 'normal' | 'break-all' | 'break-word'
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
 * 形状
 */
export type IBestShape = "square" | "circle"
/**
 * 分割线尺寸类型
 */
export type IBestBorderSizeType = "full" | "center" | "right"
/**
 * 组件信息类型
 */
export interface IBestComInfoType {
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
 * AppStorage key名称枚举
 */
export enum IBestStorageKey {
    /**
     * 全局基础样式
     */
    BASE_STYLE = 'ibestBaseStyle',
    /**
     * 顶部规避尺寸
     */
    TOP_AVOID_HEIGHT = 'ibestTopAvoidHeight',
    /**
     * 底部导航条高度
     */
    BOTTOM_BAR_HEIGHT = 'ibestBottomBarHeight',
    /**
     * 是否横屏
     */
    IS_LANDSCAPE = 'ibestIsLandscape',
    /**
     * 键盘高度
     */
    KEYBOARD_HEIGHT = 'ibestKeyBoardHeight',
    /**
     * 颜色模式
     */
    COLOR_MODE = 'ibestColorMode',
    /**
     * 语言
     */
    LANGUAGE = 'ibestLanguage',
    /**
     * 全局配置
     */
    GLOBAL_CONFIG = 'ibestGlobalConfig'
}