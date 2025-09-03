import { IBestBorderSizeType, IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'
import { IBestPopoverColor } from './color'
import { IBestPopoverAction, IBestPopoverController, IBestPopoverMask } from './index.type'

@Component
export struct IBestPopover{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 选项列表
     */
    @Prop actions: IBestPopoverAction[] = []
    /**
     * 选项文字大小
     */
    @Provide({allowOverride: "textFontSize"}) textFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 文字颜色
     */
    @Provide({allowOverride: "textColor"}) textColor: ResourceColor = IBestPopoverColor.textColor
    /**
     * 选项高度
     */
    @Provide({allowOverride: "itemHeight"}) itemHeight: IBestStringNumber = convertDimensionsWidthUnit(44)
    /**
     * 选项内边距
     */
    @Provide({allowOverride: "itemPadding"}) itemPadding: IBestStringNumber = this.baseStyle.spaceMd as string
    /**
     * 文字对齐方式
     */
    @Provide({allowOverride: "textAlign"}) textAlign?: TextAlign = undefined
    /**
     * 图标大小
     */
    @Provide({allowOverride: "iconSize"}) iconSize: IBestStringNumber = convertDimensionsWidthUnit(20)
    /**
     * 图标颜色
     */
    @Provide({allowOverride: "iconColor"}) iconColor: ResourceColor = IBestPopoverColor.textColor
    /**
     * 分割线颜色
     */
    @Provide({allowOverride: "dividerColor"}) dividerColor: ResourceColor = IBestPopoverColor.borderColor
    /**
     * 弹出位置
     */
    @Prop placement: Placement = Placement.Bottom
    /**
     * 气泡框宽度
     */
    @Provide({allowOverride: "popoverWidth"}) popoverWidth: IBestStringNumber = ""
    /**
     * 背景色
     */
    @Provide({allowOverride: "bgColor"}) bgColor: ResourceColor = IBestPopoverColor.bgColor
    /**
     * 是否显示箭头
     */
    @Prop showArrow: boolean = true
    /**
     * 箭头宽度
     */
    @Prop arrowWidth: IBestStringNumber = convertDimensionsWidthUnit(12)
    /**
     * 箭头高度
     */
    @Prop arrowHeight: IBestStringNumber = convertDimensionsWidthUnit(6)
    /**
     * 设置气泡是否有遮罩层及遮罩颜色。如果设置为false，则没有遮罩层；如果设置为true，则设置有遮罩层并且颜色为透明色；如果设置为Color，则为遮罩层的颜色。
     */
    @Prop popoverMask: boolean | IBestPopoverMask = true
    /**
     * 气泡与目标的间隙
     */
    @Prop space: IBestStringNumber = convertDimensionsWidthUnit(4)
    /**
     * 气泡圆角
     */
    @Prop radius: IBestStringNumber = convertDimensionsWidthUnit(8)
    /**
     * 气泡阴影
     */
    @Prop popoverShadow: ShadowOptions | ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD
    /**
     * 底部分割线尺寸类型
     * @since 2.0.5
     */
    @Provide borderSizeType: IBestBorderSizeType = "center"
    /**
     * 固定高度
     * @since 2.0.6
     */
    @Provide({allowOverride: "fixHeight"}) fixHeight: IBestStringNumber = "auto"
    /**
     * 最大高度
     * @since 2.0.6
     */
    @Provide({allowOverride: "maxHeight"}) maxHeight: IBestStringNumber = "auto"
    /**
     * 滚动条状态
     * @since 2.0.6
     */
    @Provide({allowOverride: "scrollBarState"}) scrollBarState: BarState = BarState.Auto
    /**
     * 默认内容
     */
    @BuilderParam triggerBuilder: CustomBuilder
    /**
     * 自定义popover内容
     */
    @BuilderParam popoverContentBuilder: CustomBuilder
    /**
     * 点击选项是触发
     */
    onSelect: (action: IBestPopoverAction, index: number) => void = () => {}
    /**
     * 打开时触发
     * @since 2.0.4
     */
    onOpen: () => void = () => {}
    /**
     * 气泡框实例
     */
    controller: IBestPopoverController = new IBestPopoverController()

    @State isShow: boolean = false

    @Builder popoverContent(){
        if(this.popoverContentBuilder){
            this.popoverContentBuilder()
        }else {
            PopoverContent({
                isShow: $isShow,
                actions: this.actions,
                onOpen: (): void => this.onOpen(),
                onSelect: (action: IBestPopoverAction, index: number): void => this.onSelect(action, index)
            })
        }
    }

    aboutToAppear(): void {
        this.controller.open = (): void => this.open()
        this.controller.close = (): void => this.close()
    }
    open(): void {
        this.isShow = true
    }
    close(): void {
        this.isShow = false
    }

    build() {
        Column(){
            if(this.triggerBuilder){
                this.triggerBuilder()
            }
        }
        .parallelGesture(
            TapGesture({fingers: 1})
                .onAction(() => {
                    this.isShow = !this.isShow
                })
        )
        .bindPopup(this.isShow, {
            builder: (): void => this.popoverContent(),
            width: getSizeByUnit(this.popoverWidth) as Dimension,
            popupColor: this.bgColor,
            placement: this.placement,
            backgroundBlurStyle: BlurStyle.NONE,
            shadow: this.popoverShadow,
            enableArrow: this.showArrow,
            arrowWidth: getSizeByUnit(this.arrowWidth) as Dimension,
            arrowHeight: getSizeByUnit(this.arrowHeight) as Dimension,
            mask: this.popoverMask,
            targetSpace: this.space,
            radius: getSizeByUnit(this.radius) as Dimension,
            onWillDismiss: (): void => this.close()
        })
    }
}

@Component
struct PopoverContent{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Prop actions: IBestPopoverAction[]
    @Consume popoverWidth: IBestStringNumber
    @Consume fixHeight: IBestStringNumber
    @Consume maxHeight: IBestStringNumber
    @Consume itemHeight: IBestStringNumber
    @Consume textFontSize: IBestStringNumber
    @Consume textColor: ResourceColor
    @Consume textAlign?: TextAlign
    @Consume itemPadding: IBestStringNumber
    @Consume iconSize: IBestStringNumber
    @Consume iconColor: ResourceColor
    @Consume bgColor: ResourceColor
    @Consume borderSizeType: IBestBorderSizeType
    @Consume dividerColor: ResourceColor
    @Consume scrollBarState: BarState
    @Link isShow: boolean
    onOpen: () => void = () => {}
    onSelect: (action: IBestPopoverAction, index: number) => void = () => {}

    getTextAlign(item: IBestPopoverAction){
        return this.textAlign || (item.icon || item.iconName ? TextAlign.Start : TextAlign.Center)
    }
    aboutToAppear(): void {
        this.onOpen()
    }

    build() {
        Scroll(){
            Column(){
                ForEach(this.actions, (item: IBestPopoverAction, index: number) => {
                    Row(){
                        Row(){
                            if(item.icon || item.iconName){
                                IBestIcon({
                                    name: item.icon || item.iconName,
                                    iconSize: this.iconSize,
                                    color: this.iconColor
                                }).margin({right: this.baseStyle.spaceXs})
                            }
                            Text(item.text)
                                .layoutWeight(this.popoverWidth ? 1 : 0)
                                .height(getSizeByUnit(this.itemHeight))
                                .fontSize(getSizeByUnit(this.textFontSize, true))
                                .fontColor(item.color || this.textColor)
                                .border({width:{top: this.borderSizeType == 'right' && index > 0 ? 1 : 0}, color: this.dividerColor})
                                .textAlign(this.getTextAlign(item))
                                .maxLines(1)
                                .textOverflow({overflow: TextOverflow.Ellipsis})
                        }
                        .border({width:{top: this.borderSizeType == 'center' && index > 0 ? 1 : 0}, color: this.dividerColor})
                    }
                    .border({width: {top: this.borderSizeType == 'full' && index > 0 ? 1 : 0}, color: this.dividerColor})
                    .padding({left: getSizeByUnit(this.itemPadding), right: getSizeByUnit(this.itemPadding)})
                    .stateStyles({
                        pressed: {
                            .backgroundColor(IBestPopoverColor.activeBg)
                        },
                        normal: {
                            .backgroundColor(this.bgColor)
                        }
                    })
                    .enabled(!item.disabled)
                    .opacity(item.disabled ? 0.5 : 1)
                    .onClick(() => {
                        this.onSelect(item, index)
                        this.isShow = false
                    })
                })
            }
        }
        .scrollBar(this.scrollBarState)
        .height(getSizeByUnit(this.fixHeight))
        .constraintSize({maxHeight: getSizeByUnit(this.maxHeight)})
    }
}