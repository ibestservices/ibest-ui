import { IBestBadge } from '../../../../../Index'
import { IBestShape, IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestGlobalConfig } from '../../model/GlobalConfig'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit, random } from '../../utils/utils'
import { IBestBadgeColor } from '../badge/color'
import { IBestBadgePosition } from '../badge/index.type'
import { IBestIcon } from '../icon'
import { IBestAvatarColor } from './color'

@Component
export struct IBestAvatar{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @StorageProp(IBestStorageKey.GLOBAL_CONFIG) config: IBestGlobalConfig = AppStorage.get(IBestStorageKey.GLOBAL_CONFIG)!
    /**
     * 头像地址
     */
    @Prop @Watch("srcChange") src: PixelMap | ResourceStr | DrawableDescriptor = ''
    /**
     * 头像形状
     */
    @Prop shape: IBestShape = 'circle'
    /**
     * 头像大小
     */
    @Prop avatarSize: IBestStringNumber = convertDimensionsWidthUnit(40)
    /**
     * 头像裁剪类型
     */
    @Prop objectFit: ImageFit = ImageFit.Cover
    /**
     * 圆角值
     */
    @Prop radius: Length | BorderRadiuses | LocalizedBorderRadiuses = convertDimensionsWidthUnit(4)
    /**
     * 背景色
     */
    @Prop bgColor: ResourceColor = IBestAvatarColor.bgColor
    /**
     * 文字替代图片, 优先级高于src
     */
    @Prop text: ResourceStr = ''
    /**
     * 显示的图标, 优先级大于text
     */
    @Prop icon: ResourceStr = ''
    /**
     * 图标、文字颜色
     */
    @Prop iconColor: ResourceColor = this.baseStyle.default
    /**
     * 图标、文字大小
     */
    @Prop iconFontSize: IBestStringNumber = convertDimensionsWidthUnit(18)
    /**
     * 随机背景色
     */
    @Prop randomBgColor: boolean = false
    /**
     * 默认头像
     */
    @Prop defaultAvatar: ResourceStr = this.config.avatar?.defaultAvatar || $r("app.media.ibest_default_avatar")
    /**
     * 徽标内容
     */
    @Prop badgeContent: IBestStringNumber = ''
    /**
     * 徽标背景色
     */
    @Prop badgeColor: ResourceColor = IBestBadgeColor.badgeBgColor
    /**
     * 是否展示为小红点
     */
    @Prop dot: boolean = false
    /**
     * 最大值,超过最大值会显示 {max}+,仅当 content 为数字时有效
     */
    @Prop max: number = -1
    /**
     * 值为0时是否显示徽标
     */
    @Prop showZero: boolean = true
    /**
     * 徽标位置
     */
    @Prop badgePosition: IBestBadgePosition = 'top-right'
    /**
     * 徽标图标, 优先级高于 content dot
     */
    @Prop badgeIcon: ResourceStr = ''
    /**
     * 徽标图标大小
     */
    @Prop badgeIconSize: IBestStringNumber = convertDimensionsWidthUnit(12)
    /**
     * 徽标图标颜色
     */
    @Prop badgeIconColor: ResourceColor
    /**
     * 头像点击事件
     */
    onAvatarClick: () => void = () => {}

    @State isError: boolean = false
    private colors: string[] = ['#ffb34b', '#f2bba9', '#f7a196', '#f18080', '#88a867', '#bfbf39', '#89c152', '#94d554', '#f19ec2',
        '#afaae4', '#e1b0df', '#c38cc1', '#72dcdc', '#9acdcb', '#77b1cc', '#448aca', '#86cefa', '#98d1ee', '#73d1f1', '#80a7dc'
    ]

    srcChange(){
        this.isError = !this.src
    }
    // 获取背景色
    getBgColor(){
        return (this.text || this.icon) ? this.randomBgColor ? this.colors[random(0, 19)] : this.bgColor : ''
    }

    build() {
        IBestBadge({
            content: this.badgeContent,
            color: this.badgeColor,
            dot: this.dot,
            max: this.max,
            showZero: this.showZero,
            badgePosition: this.badgePosition,
            icon: this.badgeIcon,
            iconSize: this.badgeIconSize,
            iconColor: this.badgeIconColor
        }){
            Row(){
                if(this.icon){
                    IBestIcon({
                        name: this.icon,
                        color: this.iconColor,
                        iconSize: this.iconFontSize
                    })
                }else if(this.text){
                    Text(this.text)
                        .fontColor(this.iconColor)
                        .fontSize(getSizeByUnit(this.iconFontSize, true))
                }else {
                    Image(this.isError ? this.defaultAvatar : this.src)
                        .width(CONTAINER_SIZE.FULL)
                        .height(CONTAINER_SIZE.FULL)
                        .objectFit(this.objectFit)
                        .onError(() => {
                            this.isError = true
                        })
                }
            }
            .width(getSizeByUnit(this.avatarSize))
            .aspectRatio(1)
            .borderRadius(this.shape === 'circle' ? this.baseStyle.borderRadiusMax : this.radius)
            .backgroundColor(this.getBgColor())
            .justifyContent(FlexAlign.Center)
            .clip(true)
            .onClick(() => {
                this.onAvatarClick()
            })
        }
    }
}
