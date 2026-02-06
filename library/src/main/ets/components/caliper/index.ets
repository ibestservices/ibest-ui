import { IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { addNumber, convertDimensionsWidthUnit, getSizeByUnit, measureTextSize } from "../../utils/utils"
import { IBestCaliperColor } from "./color"
import { IBestCaliperScale, IBestCaliperScaleSource } from "./index.type"

@Component
export struct IBestCaliper{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 绑定值
     */
    @Link @Watch("valueChange") value: number
    /**
     * 大刻度之间分为几个小刻度
     */
    @Prop scales: number = 10
    /**
     * 每个小刻度代表数值
     */
    @Prop scaleSize: number = 1
    /**
     * 开始刻度值
     */
    @Prop startNum: number = 0
    /**
     * 结束刻度值
     */
    @Prop endNum: number = 100
    /**
     * 背景色
     */
    @Prop bgColor: ResourceColor
    /**
     * 刻度线颜色
     */
    @Prop scaleColor: ResourceColor = IBestCaliperColor.scaleColor
    /**
     * 选中刻度线颜色
     */
    @Prop activeScaleColor: ResourceColor = ""
    /**
     * 刻度对齐方式
     */
    @Prop scaleAlign: "top" | "center" | "bottom" = "top"
    /**
     * 字体大小
     */
    @Prop fontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 字体颜色
     */
    @Prop fontColor: ResourceColor = ""
    /**
     * 大刻度宽度
     */
    @Prop bigScaleWidth: IBestStringNumber = 1
    /**
     * 大刻度高度
     */
    @Prop bigScaleHeight: IBestStringNumber = convertDimensionsWidthUnit(30)
    /**
     * 小刻度宽度
     */
    @Prop smallScaleWidth: IBestStringNumber = 1
    /**
     * 小刻度高度
     */
    @Prop smallScaleHeight: IBestStringNumber = convertDimensionsWidthUnit(20)
    /**
     * 选中刻度宽度
     */
    @Prop activeScaleWidth: IBestStringNumber = 3
    /**
     * 选中刻度文字字重
     */
    @Prop activeFontWeight: IBestStringNumber | FontWeight = FontWeight.Normal
    /**
     * 刻度间距
     */
    @Prop scaleSpace: IBestStringNumber = this.baseStyle.spaceXsm as string
    /**
     * 刻度变化回调
     */
    onChange: (value: number) => void = () => {}

    @State realActiveWidth: number = 0
    @State scaleList: IBestCaliperScaleSource = new IBestCaliperScaleSource([])
    private uiContext = this.getUIContext()
    private listScroller: ListScroller = new ListScroller()
    private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right })
    private flag: boolean = false

    aboutToAppear(): void {
        this.initScaleList()
    }
    initScaleList(){
        let list: IBestCaliperScale[] = []
        const scaleSize = this.scales * this.scaleSize
        for (let i = this.startNum; i <= this.endNum; i = addNumber(i, this.scaleSize)) {
            list.push({
                value: i,
                isBig: i % scaleSize === 0
            })
        }
        this.scaleList = new IBestCaliperScaleSource(list)
        if(this.value != this.startNum){
            setTimeout(() => {
                this.updateIndex()
            })
        }
    }
    valueChange(){
        if(!this.flag){
            this.updateIndex()
        }
    }
    getFontHeight() {
        return measureTextSize(this.uiContext, {
            textContent: "0",
            fontSize: this.fontSize
        }).height
    }
    updateIndex() {
        let index = this.scaleList.getAll().findIndex(item => item.value === this.value)
        if(index > -1){
            this.listScroller.scrollToIndex(index, true, ScrollAlign.CENTER)
        }
    }
    onScroll(index: number){
        if(this.flag){
            const i = index < 0 ? 0 : index > this.scaleList.totalCount() - 1 ? this.scaleList.totalCount() - 1 : index
            this.value = this.scaleList.getData(i).value
        }
    }

    build() {
        List({ space: getSizeByUnit(this.scaleSpace), scroller: this.listScroller }) {
            LazyForEach(this.scaleList, (item: IBestCaliperScale, index: number) => {
                ListItem() {
                    Row(){
                        Row()
                            .width(getSizeByUnit(this.value === item.value ? this.activeScaleWidth : item.isBig ? this.bigScaleWidth : this.smallScaleWidth))
                            .height(getSizeByUnit(item.isBig ? this.bigScaleHeight : this.smallScaleHeight))
                            .backgroundColor(this.value === item.value ? this.activeScaleColor || this.baseStyle.primary : this.scaleColor)
                            .borderRadius(this.value === item.value ? this.baseStyle.borderRadiusMax : 0)
                        if(item.isBig){
                            Text(item.value.toString())
                                .fontColor(this.fontColor || this.baseStyle.primary)
                                .fontSize(getSizeByUnit(this.fontSize, true))
                                .fontWeight(this.value === item.value ? this.activeFontWeight : "")
                                .position({left: this.value === item.value ? this.realActiveWidth / 2 : 0, bottom: -5})
                                .translate({x: "-50%", y: CONTAINER_SIZE.FULL})
                        }
                        if(index == 0){
                            Row()
                                .width(getSizeByUnit(this.activeScaleWidth))
                                .height(1)
                                .position({left: 0, top: 0})
                                .opacity(0)
                                .zIndex(-1)
                                .onAreaChange((_, newVal) => {
                                    this.realActiveWidth = newVal.width as number
                                })
                        }
                    }
                    .padding({bottom: this.getFontHeight() + 5})
                }
            }, (item: IBestCaliperScale) => item.value.toString())
        }
        .width(CONTAINER_SIZE.FULL)
        .backgroundColor(this.bgColor)
        .scrollBar(BarState.Off)
        .chainAnimation(true)
        .edgeEffect(EdgeEffect.None)
        .listDirection(Axis.Horizontal)
        .scrollSnapAlign(ScrollSnapAlign.CENTER)
        .alignListItem(this.scaleAlign == 'center' ? ListItemAlign.Center : this.scaleAlign == 'bottom' ? ListItemAlign.End : ListItemAlign.Start)
        // api22 更新
        // .scrollSnapAnimationSpeed(ScrollSnapAnimationSpeed.SLOW)
        .onScrollIndex((_start: number, _: number, centerIndex: number) => {
            this.onScroll(centerIndex)
        })
        .onScrollStop(() => {
            this.flag = false
        })
        .parallelGesture(
            PanGesture(this.panOption)
                .onActionUpdate(() => {
                    this.flag = true
                })
        )
    }
}