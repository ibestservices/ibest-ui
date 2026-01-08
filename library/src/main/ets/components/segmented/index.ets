import { IBestAwaitable, IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, handleBeforeFunction } from "../../utils/utils"
import { IBestSegmentedColor } from "./color"
import { IBestSegmentedOption } from "./index.type"
import { debounce } from '../../utils/debounceThrottle'
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
    @Prop @Require @Watch("optionsChange") options: (IBestStringNumber | IBestSegmentedOption)[] = []
    /**
     * 宽度类型
     */
    @Prop widthType: 'auto' | 'flex' = 'flex'
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
    @Prop round: boolean = false
    /**
     * 圆角, 仅round为false时生效
     */
    @Prop radius: Length | BorderRadiuses | LocalizedBorderRadiuses = convertDimensionsWidthUnit(2)
    /**
     * 单个选项内边距
     */
    @Prop itemPadding: Length | Padding | LocalizedPadding = { left: convertDimensionsWidthUnit(10), right: convertDimensionsWidthUnit(10) }
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
    @Prop inactiveTextColor: ResourceColor = IBestSegmentedColor.inactiveTextColor
    /**
     * 选中文字颜色
     */
    @Prop activeTextColor: ResourceColor = IBestSegmentedColor.activeTextColor
    /**
     * 字体大小
     */
    @Prop fontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
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

    @State uniId: number = 0
    @State isReady: boolean = false
    // 盒子宽度
    @State contentWidth: number = 0
    // 宽度列表
    @State widthList: number[] = []
    // 标记块位移列表
    @State translateXList: number[] = []
    private context: UIContext = this.getUIContext()
    private scroller: Scroller = new Scroller()

    @Builder iconBuilder(item: IBestSegmentedOption, index: number){
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
                ForEach(this.options, (item: IBestStringNumber | IBestSegmentedOption, index: number) => {
                    Row({space: this.baseStyle.spaceX}){
                        if(typeof item === "object" && item.icon && (!item.iconPosition || item.iconPosition == "left")){
                            this.iconBuilder(item, index)
                        }
                        if(typeof item === "string" || typeof item === "object" && item.label){
                            Text(typeof item === "object" ? item.label : item.toString())
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
                        if(typeof item === "object" && item.icon && item.iconPosition == "right"){
                            this.iconBuilder(item, index)
                        }
                    }
                    .layoutWeight(this.widthType == "flex" ? 1 : undefined)
                    .height(CONTAINER_SIZE.FULL)
                    .padding(getSizeByUnit(this.itemPadding))
                    .justifyContent(FlexAlign.Center)
                    .borderRadius(this.getRadius())
                    .enabled(typeof item === "object" ? !item.disabled : true)
                    .opacity(typeof item === "object" && item.disabled ? 0.6 : 1)
                    .id(`ibest_segmented_option_${this.uniId}_${index}`)
                    .onClick(() => {
                        this.selectItem(item)
                    })
                })
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
    // 初始化
    init: () => void = debounce(() => {
        this.getWidth()
        this.scrollCenter()
        setTimeout(() => {
            this.isReady = true
        }, 50)
    }, 100)
    // 获取所有选项的宽度
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
    // 获取选中索引
    getActiveIndex(){
        return this.options.findIndex((item: IBestStringNumber | IBestSegmentedOption) => {
            if(typeof item === "object"){
                return item.value === this.value
            }else {
                return item === this.value
            }
        })
    }
    // 获取颜色
    getColor(index: number){
        return index == this.getActiveIndex() ? this.activeTextColor : this.inactiveTextColor
    }
    // 获取圆角
    getRadius(){
        return this.round ? this.baseStyle.borderRadiusMax : getSizeByUnit(this.radius)
    }
    // 点击选项
    async selectItem(item: IBestStringNumber | IBestSegmentedOption){
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
    // 滚动居中
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
    // 选项变化
    optionsChange(){
        setTimeout(() => {
            this.getWidth()
            this.scrollCenter()
        }, 10)
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
        .clip(true)
        .onAreaChange(() => {
            this.init()
        })
    }
}