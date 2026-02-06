import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { getSizeByUnit } from '../../utils/utils'
import { IBestCell } from '../cell'
import { IBestCardColor } from './color'

@Component
export struct IBestCard{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 标题文字
     */
    @Prop title: ResourceStr = ''
    /**
     * 标题文字大小
     */
    @Prop titleFontSize: IBestStringNumber = this.baseStyle.fontSizeLg as string
    /**
     * 标题文字颜色
     */
    @Prop titleFontColor: ResourceColor = IBestCardColor.titleFontColor
    /**
     * 标题内边距
     */
    @Prop titlePadding: Length | Padding | LocalizedPadding = {
        left: this.baseStyle.spaceSm,
        right: this.baseStyle.spaceSm,
        top: this.baseStyle.spaceXsm,
        bottom: this.baseStyle.spaceXsm
    }
    /**
     * 标题是否可点击
     */
    @Prop titleClickable: boolean = false
    /**
     * 圆角
     */
    @Prop radius: IBestStringNumber = this.baseStyle.borderRadiusLg as string
    /**
     * 内容内边距
     */
    @Prop contentPadding: Length | Padding | LocalizedPadding = this.baseStyle.spaceSm as string
    /**
     * 背景色
     */
    @Prop bgColor: ResourceColor = IBestCardColor.bgColor
    /**
     * 背景图片
     */
    @Prop bgImage: ResourceStr = ''
    /**
     * 阴影半径
     */
    @Prop shadowRadius: number | Resource = 12
    /**
     * 阴影颜色
     */
    @Prop shadowColor: ResourceColor = IBestCardColor.shadowColor
    /**
     * 左侧图标
     * @since 2.2.6
     */
    @Prop leftIcon: ResourceStr
    /**
     * 左侧图标颜色
     * @since 2.2.6
     */
    @Prop leftIconColor: ResourceColor
    /**
     * 左侧图标大小
     * @since 2.2.6
     */
    @Prop leftIconSize: IBestStringNumber
    /**
     * 右侧内容
     * @since 2.2.6
     */
    @Prop value: ResourceStr
    /**
     * 内容的文字颜色
     * @since 2.2.6
     */
    @Prop valueColor: ResourceColor
    /**
     * 内容的文字大小
     * @since 2.2.6
     */
    @Prop valueFontSize: IBestStringNumber
    /**
     * 标题点击事件, titleClickable为true时生效
     */
    onTitleClick: () => void = () => {}

    @BuilderParam defaultBuilder: CustomBuilder

    private uiContext = this.getUIContext()

    getShadowRadius(){
        if(typeof this.shadowRadius == 'object'){
            return this.uiContext.getHostContext()!.resourceManager.getNumber(this.shadowRadius.id)
        }
        return this.shadowRadius
    }

    build() {
        Column(){
            if(this.title){
                IBestCell({
                    title: this.title,
                    titleColor: this.titleFontColor,
                    titleFontSize: this.titleFontSize,
                    cellPadding: this.titlePadding,
                    leftIcon: this.leftIcon,
                    leftIconColor: this.leftIconColor,
                    leftIconSize: this.leftIconSize,
                    value: this.value,
                    valueColor: this.valueColor,
                    valueFontSize: this.valueFontSize,
                    isLink: this.titleClickable,
                    borderSizeType: "full",
                    onCellClick: () => {
                        this.onTitleClick()
                    }
                })
            }
            Column(){
                if(this.defaultBuilder){
                    this.defaultBuilder()
                }
            }
            .width(CONTAINER_SIZE.FULL)
            .padding(getSizeByUnit(this.contentPadding))
            .alignItems(HorizontalAlign.Start)
        }
        .width(`calc(100% - ${this.getShadowRadius()}vp)`)
        .backgroundColor(this.bgColor)
        .backgroundImage(this.bgImage)
        .backgroundImageSize(ImageSize.FILL)
        .borderRadius(getSizeByUnit(this.radius))
        .margin(this.getShadowRadius() / 2)
        .clip(true)
        .shadow({
            radius: this.uiContext.vp2px(this.getShadowRadius()),
            color: this.shadowColor
        })
    }
}
