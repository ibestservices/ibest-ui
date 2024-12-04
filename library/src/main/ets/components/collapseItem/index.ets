import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getComponentsInfo, getEventName, getSizeByUnit } from '../../utils/utils'
import { COLLAPSE_EVENT_NAME } from '../collapse/index.type'
import { IBestIcon } from '../icon'

@Component
export struct IBestCollapseItem {
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 分组id
     */
    @Prop groupId: string = ""
    /**
     * 唯一标识符
     */
    @Prop name: string = ""
    /**
     * 索引
     */
    @Prop index: number = 0
    /**
     * 标题栏左侧图标
     */
    @Prop icon: ResourceStr = ""
    /**
     * 标题栏左侧图标颜色
     */
    @Prop iconColor: ResourceStr = GRAY_COLOR.GRAY_8
    /**
     * 标题栏左侧图标大小
     */
    @Prop iconSize: number | string = convertDimensionsWidthUnit(16)
    /**
     * 标题
     */
    @Prop title: string = ""
    /**
     * 标题文字颜色
     */
    @Prop titleColor: ResourceStr = GRAY_COLOR.GRAY_8
    /**
     * 标题文字大小
     */
    @Prop titleFontSize: number | string = this.baseStyle.fontSizeMd
    /**
     * 标题栏右侧内容
     */
    @Prop value: string = ""
    /**
     * 标题右侧文字颜色
     */
    @Prop valueColor: ResourceStr = GRAY_COLOR.GRAY_6
    /**
     * 标题右侧文字大小
     */
    @Prop valueFontSize: number | string = this.baseStyle.fontSizeMd
    /**
     * 是否显示内边框
     */
    @Prop isShowBorder: boolean = true
    /**
     * 是否禁用
     */
    @Prop disabled: boolean = false
    /**
     * 是否只读
     */
    @Prop readOnly: boolean = false
    /**
     * 默认内容
     */
    @BuilderParam defaultBuilder?: CustomBuilder

    @State isExpand: boolean = false
    @State uniId: number = 0
    @State contentHeight: number = 0
    @State isReady: boolean = false
    @State isShow: boolean = false
    private uiContext = this.getUIContext()

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.getContentHeight()
        if(this.groupId){
            emitter.emit(getEventName(this.groupId, COLLAPSE_EVENT_NAME.GET_ALL_ITEM_NAME), this.name, this.disabled || this.readOnly)
            emitter.on(getEventName(this.groupId, COLLAPSE_EVENT_NAME.INIT_ITEM), (activeNames: string | string[]): void => this.changeState(activeNames))
        }
    }
    aboutToDisappear(): void {
        if(this.groupId){
            emitter.off(getEventName(this.groupId, COLLAPSE_EVENT_NAME.INIT_ITEM), (activeNames: string | string[]): void => this.changeState(activeNames))
        }
    }
    getIsDisabled(){
        return this.disabled || this.readOnly
    }
    changeState(activeNames: string | string[]){
        this.isExpand = typeof activeNames == "string" ? activeNames == this.name : activeNames.includes(this.name)
    }
    getContentHeight(){
        setTimeout(() => {
            this.contentHeight = getComponentsInfo(this.uiContext, `ibest_collapse_item_${this.uniId}`).height
            this.isReady = true
            setTimeout(() => {
                this.isShow = true
            }, 250)
        }, 0)
    }
    getHeight(){
        return this.isReady ? this.isExpand ? this.contentHeight : 0 : "auto"
    }

    toggle(){
        this.isExpand = !this.isExpand
        emitter.emit(getEventName(this.groupId, COLLAPSE_EVENT_NAME.ITEM_STATE_CHANGE), this.name, this.isExpand)
    }

    build() {
        Column(){
            Row(){
                if(this.icon){
                    Image(this.icon)
                        .width(getSizeByUnit(this.iconSize))
                        .fillColor(this.iconColor)
                        .margin({right: this.baseStyle.spaceBase})
                }
                Text(this.title)
                    .layoutWeight(1)
                    .fontSize(getSizeByUnit(this.titleFontSize, true))
                    .fontColor(this.titleColor)
                if(this.value){
                    Text(this.value)
                        .layoutWeight(1)
                        .textAlign(TextAlign.End)
                        .fontColor(this.valueColor)
                        .fontSize(getSizeByUnit(this.valueFontSize, true))
                }
                IBestIcon({
                    name: "arrow-down",
                    iconSize: this.baseStyle.fontSizeMd,
                    color: GRAY_COLOR.GRAY_6,
                    onIconClick: () => {
                        this.toggle()
                    }
                })
                    .margin({left: this.baseStyle.spaceBase})
                    .rotate({ z:1, angle: this.isExpand ? -180 : 0 })
                    .animation({ duration: 300 })
            }
            .padding({left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm})
            .stateStyles({
                pressed:{
                    .backgroundColor(GRAY_COLOR.GRAY_2)
                },
                normal:{
                    .backgroundColor(this.baseStyle.default)
                }
            })
            .enabled(!this.getIsDisabled())
            .opacity(this.disabled ? 0.4 : 1)
            .onClick(() => {
                this.toggle()
            })
            Row(){
                Row(){
                    Divider()
                        .height(1)
                        .color(GRAY_COLOR.GRAY_3)
                        .position({left: 0, top: "-" + this.baseStyle.spaceSm as Dimension})
                    if(this.defaultBuilder){
                        this.defaultBuilder()
                    }
                }
                .width(CONTAINER_SIZE.FULL)
                .padding({left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm})
                .id(`ibest_collapse_item_${this.uniId}`)
            }
            .height(this.getHeight())
            .clip(true)
            .animation({
                duration: 200,
                curve: Curve.EaseInOut
            })
            if(this.index > 0){
                Divider()
                    .width(`calc(100% - ${this.baseStyle.spaceMd} - ${this.baseStyle.spaceMd})`)
                    .height(1)
                    .color(GRAY_COLOR.GRAY_3)
                    .position({left: this.baseStyle.spaceMd as Dimension, top: 0})
            }
        }
        .backgroundColor(this.baseStyle.default)
        .opacity(this.isShow ? 1 : 0)
    }
}