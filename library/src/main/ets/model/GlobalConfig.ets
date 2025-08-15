type IBestLengthUnit = "vp" | "px" | "lpx"
type IBestFontUnit = IBestLengthUnit | "fp"
/**
 * Avatar 配置信息
 */
interface IBestAvatarConfig {
    /**
     * 默认头像
     */
    defaultAvatar?: ResourceStr
}
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
    /**
     * 头像组件全局配置信息
     * @since 2.1.5
     */
    avatar?: IBestAvatarConfig
}
export class IBestGlobalConfig extends IBestGlobalConfigType {
    constructor(option?: IBestGlobalConfigType) {
        super()
        this.designWidth = option?.designWidth || 720
        this.unit = option?.unit || "vp"
        this.fontUnit = option?.fontUnit || "fp"
        this.avatar = option?.avatar
    }
}