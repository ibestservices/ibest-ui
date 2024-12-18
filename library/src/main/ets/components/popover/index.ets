import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'
import { IBestPopoverColor } from './color'
import { IBestPopoverAction, IBestPopoverController, PopoverMask } from './index.type'


@Component
export struct IBestPopover{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 选项列表
     */
    @Provide({allowOverride: "actions"}) actions: IBestPopoverAction[] = []
    /**
     * 选项文字大小
     */
    @Provide({allowOverride: "textFontSize"}) textFontSize: string | number = this.baseStyle.fontSizeMd as string
    /**
     * 文字颜色
     */
    @Provide({allowOverride: "textColor"}) textColor: ResourceColor = IBestPopoverColor.textColor
    /**
     * 选项高度
     */
    @Provide({allowOverride: "itemHeight"}) itemHeight: string | number = convertDimensionsWidthUnit(44)
    /**
     * 选项内边距
     */
    @Provide({allowOverride: "itemPadding"}) itemPadding: string | number = this.baseStyle.spaceMd as string
    /**
     * 文字对齐方式
     */
    @Provide({allowOverride: "textAlign"}) textAlign?: TextAlign = undefined
    /**
     * 图标大小
     */
    @Provide({allowOverride: "iconSize"}) iconSize: string | number = convertDimensionsWidthUnit(20)
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
    @Provide({allowOverride: "popoverWidth"}) popoverWidth: string | number = ""
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
    @Prop arrowWidth: string | number = convertDimensionsWidthUnit(12)
    /**
     * 箭头高度
     */
    @Prop arrowHeight: string | number = convertDimensionsWidthUnit(6)
    /**
     * 是否显示遮罩
     */
    @Prop popoverMask: boolean | PopoverMask = true
    /**
     * 气泡与目标的间隙
     */
    @Prop space: string | number = convertDimensionsWidthUnit(4)
    /**
     * 气泡圆角
     */
    @Prop radius: string | number = convertDimensionsWidthUnit(8)
    /**
     * 气泡阴影
     */
    @Prop popoverShadow: ShadowOptions | ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD
    /**
     * 默认内容
     */
    @BuilderParam triggerBuilder?: CustomBuilder
    /**
     * 自定义popover内容
     */
    @BuilderParam popoverContentBuilder?: CustomBuilder
    /**
     * 点击选项是触发
     */
    onSelect: (action: IBestPopoverAction, index: number) => void = () => {}
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
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Consume actions: IBestPopoverAction[]
    @Consume popoverWidth: string | number
    @Consume itemHeight: string | number
    @Consume textFontSize: string | number
    @Consume textColor: ResourceColor
    @Consume textAlign?: TextAlign
    @Consume itemPadding: string | number
    @Consume iconSize: string | number
    @Consume iconColor: ResourceColor
    @Consume bgColor: ResourceColor
    @Consume dividerColor: ResourceColor
    @Link isShow: boolean
    onSelect: (action: IBestPopoverAction, index: number) => void = () => {}

    getTextAlign(item: IBestPopoverAction){
        return this.textAlign || (item.icon || item.iconName ? TextAlign.Start : TextAlign.Center)
    }

    build() {
        Column(){
            ForEach(this.actions, (item: IBestPopoverAction, index: number) => {
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
                        .border({width:{top: index > 0 ? 1 : 0}, color: this.dividerColor})
                        .textAlign(this.getTextAlign(item))
                        .maxLines(1)
                        .textOverflow({overflow: TextOverflow.Ellipsis})
                }
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
}