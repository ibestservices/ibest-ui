import { IBestAwaitable, IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, handleBeforeFunction } from "../../utils/utils"
import { IBestSegmentedColor } from "./color"
import { IBestSegmentedItem, IBestSegmentedOption } from "./index.type"
import { IBestIcon } from "../icon"

@Component
export struct IBestSegmented{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 当前选中的值
     */
    @Link value: IBestStringNumber
    /**
     * 选项列表
     */
    @ObjectLink @Watch("init") options: (IBestStringNumber | IBestSegmentedItem)[]
    /**
     * 宽度类型
     */
    @Provide({allowOverride: "widthType"}) widthType: 'auto' | 'flex' = 'flex'
    /**
     * 高度
     */
    @Prop contentHeight: IBestStringNumber = convertDimensionsWidthUnit(34)
    /**
     * 内边距
     */
    @Prop contentPadding: Length | Padding | LocalizedPadding = convertDimensionsWidthUnit(4)
    /**
     * 是否为圆形
     */
    @Provide({allowOverride: "round"}) round: boolean = false
    /**
     * 圆角, 仅round为false时生效
     */
    @Provide({allowOverride: "radius"}) radius: Length | BorderRadiuses | LocalizedBorderRadiuses = convertDimensionsWidthUnit(2)
    /**
     * 单个选项内边距
     */
    @Provide({allowOverride: "itemPadding"}) itemPadding: Length | Padding | LocalizedPadding = { left: this.baseStyle.spaceXsm, right: this.baseStyle.spaceXsm }
    /**
     * 背景色
     */
    @Prop bgColor: ResourceColor = IBestSegmentedColor.bgColor
    /**
     * 选中背景颜色
     */
    @Prop activeBgColor: ResourceColor = ""
    /**
     * 未选中文字颜色
     */
    @Provide({allowOverride: "inactiveTextColor"}) inactiveTextColor: ResourceColor = IBestSegmentedColor.inactiveTextColor
    /**
     * 选中文字颜色
     */
    @Provide({allowOverride: "activeTextColor"}) activeTextColor: ResourceColor = IBestSegmentedColor.activeTextColor
    /**
     * 字体大小
     */
    @Provide({allowOverride: "fontSize"}) fontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 色块是否显示阴影
     */
    @Prop activeShadow: ShadowOptions | ShadowStyle = { radius: 4, color: "#333", offsetY: 2 }
    /**
     * 切换前回调
     */
    beforeChange?: (value: IBestStringNumber) => IBestAwaitable
    /**
     * 选项点击回调
     */
    onOptionClick: (value: IBestStringNumber) => void = () => {}
    /**
     * 切换回调
     */
    onChange: (value: IBestStringNumber) => void = () => {}

    @State contentWidth: number = 0
    @State widthList: number[] = []
    @State translateXList: number[] = []
    @Provide uniId: number = 0
    @Provide isReady: boolean = false
    private context: UIContext = this.getUIContext()
    private scroller: Scroller = new Scroller()

    @Builder contentBuilder(showId: boolean = false){
        Stack({alignContent: Alignment.BottomStart}){
            if(this.getActiveIndex() > -1 && this.getActiveIndex() < this.options.length){
                Row()
                    .height(CONTAINER_SIZE.FULL)
                    .backgroundColor(this.activeBgColor || this.baseStyle.primary)
                    .borderRadius(this.getRadius())
                    .shadow(this.activeShadow)
                    .translate({ x: this.translateXList[this.getActiveIndex()] })
                    .animation({
                        duration: this.isReady ? 300 : 0,
                        curve: "cubic-bezier(0.645,0.045,0.355,1)"
                    })
                    .width(this.widthList[this.getActiveIndex()])
            }
            Row(){
                ForEach(this.options, (item: IBestStringNumber | IBestSegmentedItem, index: number) => {
                    if(typeof item == 'object'){
                        IBestSegmentedBox({
                            item: item,
                            index: index,
                            value: this.value,
                            options: this.options as IBestSegmentedItem[],
                            onOptionClick: item => {
                                this.selectItem(item)
                            }
                        })
                    }else {
                        Row({space: this.baseStyle.spaceX}){
                            Text(item.toString())
                                .constraintSize({maxWidth: CONTAINER_SIZE.FULL})
                                .fontSize(getSizeByUnit(this.fontSize, true))
                                .fontColor(this.getColor(index))
                                .maxLines(1)
                                .textOverflow({overflow: TextOverflow.Ellipsis})
                                .animation({
                                    duration: this.isReady ? 300 : 0,
                                    curve: "cubic-bezier(0.645,0.045,0.355,1)"
                                })
                        }
                        .layoutWeight(this.widthType == "flex" ? 1 : undefined)
                        .height(CONTAINER_SIZE.FULL)
                        .padding(getSizeByUnit(this.itemPadding))
                        .justifyContent(FlexAlign.Center)
                        .borderRadius(this.getRadius())
                        .id(`ibest_segmented_option_${this.uniId}_${index}`)
                        .onClick(() => {
                            this.selectItem(item)
                        })
                    }
                }, (_: IBestSegmentedItem, index: number) => index.toString())
            }
            .width(this.widthType == "flex" ? CONTAINER_SIZE.FULL : "")
            .borderRadius(this.getRadius())
        }
        .id(showId ? `ibest_segmented_${this.uniId}` : "")
    }

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
    }
    onDidBuild() {
        this.init()
    }
    init() {
        if(this.options.length){
            setTimeout(() => {
                this.getWidth()
                this.scrollCenter()
                setTimeout(() => {
                    this.isReady = true
                }, 50)
            }, 50)
        }
    }
    getWidth(){
        let tabWidthList: number[] = []
        let translateXList: number[] = []
        let contentInfo = getComponentsInfo(this.context, `ibest_segmented_${this.uniId}`)
        this.options.forEach((_: IBestStringNumber | IBestSegmentedOption, index: number) => {
            let boxInfo = getComponentsInfo(this.context, `ibest_segmented_option_${this.uniId}_${index}`)
            tabWidthList.push(boxInfo.width)
            translateXList.push(boxInfo.localLeft)
        })
        this.widthList = tabWidthList
        this.contentWidth = contentInfo.width
        this.translateXList = translateXList
    }
    getActiveIndex(){
        return this.options.findIndex((item: IBestStringNumber | IBestSegmentedOption) => {
            if(typeof item === "object"){
                return item.value === this.value
            }else {
                return item === this.value
            }
        })
    }
    getColor(index: number){
        return index == this.getActiveIndex() ? this.activeTextColor : this.inactiveTextColor
    }
    getRadius(){
        return this.round ? this.baseStyle.borderRadiusMax : getSizeByUnit(this.radius)
    }
    async selectItem(item: IBestStringNumber | IBestSegmentedItem){
        let value = typeof item === "object" ? item.value : item
        this.onOptionClick(value)
        if(value === this.value){
            return
        }
        let status = await handleBeforeFunction(this.beforeChange, value)
        if(!status){
            return
        }
        this.value = value
        this.onChange(value)
        this.scrollCenter()
    }
    scrollCenter(animate: boolean = true){
        if(this.widthType == "auto"){
            this.scroller.scrollTo({
                xOffset: this.translateXList[this.getActiveIndex()] - this.contentWidth/2 + this.widthList[this.getActiveIndex()]/2,
                yOffset: 0,
                animation: animate ? {
                    duration: animate ? 100 : 0,
                    curve: Curve.FastOutSlowIn
                } : false
            })
        }
    }

    build() {
        Row(){
            if(this.widthType == "auto"){
                Scroll(this.scroller){
                    this.contentBuilder()
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .align(Alignment.Start)
                .clip(false)
                .id(`ibest_segmented_${this.uniId}`)
            }else{
                this.contentBuilder(true)
            }
        }
        .width(this.widthType == "flex" ? CONTAINER_SIZE.FULL : "")
        .height(getSizeByUnit(this.contentHeight))
        .padding(getSizeByUnit(this.contentPadding))
        .borderRadius(this.getRadius())
        .backgroundColor(this.bgColor)
        .opacity(this.options.length ? 1 : 0)
        .animation({duration: this.baseStyle.animationDuration as number})
        .clip(true)
        .onAreaChange(() => {
            this.init()
        })
    }
}

@Component
struct IBestSegmentedBox{
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @ObjectLink item: IBestSegmentedItem
    @Prop @Require index: number
    @Prop @Require value: IBestStringNumber
    @Prop @Require options: IBestSegmentedItem[]
    @Consume uniId: number
    @Consume isReady: boolean
    @Consume widthType: "auto" | "flex"
    @Consume round: boolean
    @Consume fontSize: IBestStringNumber
    @Consume itemPadding: Length | Padding | LocalizedPadding
    @Consume activeTextColor: ResourceColor
    @Consume inactiveTextColor: ResourceColor
    @Consume radius: Length | BorderRadiuses | LocalizedBorderRadiuses
    @Builder iconBuilder(item: IBestSegmentedItem, index: number){
        IBestIcon({
            name: item.icon,
            iconSize: this.fontSize,
            color: this.getColor(index),
            iconAnimation: {
                duration: this.isReady ? 300 : 0,
                curve: "cubic-bezier(0.645,0.045,0.355,1)"
            }
        })
    }
    onOptionClick: (value: IBestSegmentedItem) => void = () => {}

    getColor(index: number){
        return index == this.getActiveIndex() ? this.activeTextColor : this.inactiveTextColor
    }
    getActiveIndex(){
        return this.options.findIndex((item: IBestSegmentedItem) => {
            return item.value === this.value
        })
    }
    getRadius(){
        return this.round ? this.baseStyle.borderRadiusMax : getSizeByUnit(this.radius)
    }
    build() {
        Row({space: this.baseStyle.spaceX}){
            if(this.item.icon && (!this.item.iconPosition || this.item.iconPosition == "left")){
                this.iconBuilder(this.item, this.index)
            }
            if(this.item.label){
                Text(this.item.label)
                    .constraintSize({maxWidth: CONTAINER_SIZE.FULL})
                    .fontSize(getSizeByUnit(this.fontSize, true))
                    .fontColor(this.getColor(this.index))
                    .maxLines(1)
                    .textOverflow({overflow: TextOverflow.Ellipsis})
                    .animation({
                        duration: this.isReady ? 300 : 0,
                        curve: "cubic-bezier(0.645,0.045,0.355,1)"
                    })
            }
            if(this.item.icon && this.item.iconPosition == "right"){
                this.iconBuilder(this.item, this.index)
            }
        }
        .layoutWeight(this.widthType == "flex" ? 1 : undefined)
        .height(CONTAINER_SIZE.FULL)
        .padding(getSizeByUnit(this.itemPadding))
        .justifyContent(FlexAlign.Center)
        .borderRadius(this.getRadius())
        .enabled(!this.item.disabled)
        .opacity(this.item.disabled ? 0.6 : 1)
        .id(`ibest_segmented_option_${this.uniId}_${this.index}`)
        .onClick(() => {
            this.onOptionClick(this.item)
        })
    }
}