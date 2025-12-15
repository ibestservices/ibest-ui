import { IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import {
    addNumber,
    convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, measureTextSize } from "../../utils/utils"
import { IBestCaliperColor } from "./color"
import { IBestCaliperScale } from "./index.type"

const MOMENTUM_TIME = 300
const MOMENTUM_DISTANCE = 15
const swipeDuration = 150

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
    @Prop scaleSpace: IBestStringNumber = convertDimensionsWidthUnit(10)
    /**
     * 刻度变化回调
     */
    onChange: (value: number) => void = () => {}

    @State scaleList: IBestCaliperScale[] = []
    @State contentWidth: number = 0
    @State realActiveWidth: number = 0
    @State transX: number = 0
    @State isReady: boolean = false
    private uniId: number = 0
    private uiContext = this.getUIContext()
    private touchStartTime: number = 0
    private startOffset: number = 0
    private momentumOffset: number = 0
    private flag: boolean = false

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.init()
    }
    init(){
        this.initScaleList()
        setTimeout(() => {
            this.realActiveWidth = getComponentsInfo(this.uiContext, `ibest_caliper_active_width_${this.uniId}`).width
            this.getScaleLeftList()
        }, 100)
    }
    // 初始化刻度列表
    initScaleList(){
        let list: IBestCaliperScale[] = []
        const scaleSize = this.scales * this.scaleSize
        for (let i = this.startNum; i <= this.endNum; i = addNumber(i, this.scaleSize)) {
            list.push({
                value: i,
                isBig: i % scaleSize === 0,
                localLeft: 0
            })
        }
        this.scaleList = list
    }
    // 获取刻度左边距列表
    getScaleLeftList() {
        this.scaleList.forEach(e => {
            let info = getComponentsInfo(this.uiContext, `ibest_caliper_item_${this.uniId}_${e.value}`)
            e.localLeft = info.localLeft
        })
        this.updateTransX()
        setTimeout(() => {
            this.isReady = true
        }, swipeDuration)
    }
    // value变化
    valueChange(){
        if(this.flag){  // 内部更新
            this.flag = false
        }else { // 外部更新
            this.updateTransX()
        }
    }
    // 更新transX
    updateTransX() {
        let info = this.scaleList.find(item => item.value === this.value)
        if(info){
            this.transX = -info.localLeft
        }
    }
    // 获取字体高度
    getFontHeight() {
        return measureTextSize(this.uiContext, {
            textContent: "0",
            fontSize: this.fontSize
        }).height
    }
    // 通过偏移量获取索引
    getIndexByOffset(offset: number) {
        const arr = this.scaleList.map(item => item.localLeft)
        const n = this.scaleList.length
        if (offset <= arr[0]) return 0
        if (offset >= arr[n - 1]) return n - 1
        // 二分查找找插入位置
        let left = 0
        let right = n - 1
        while (left < right - 1) {
            const mid = Math.floor((left + right) / 2)
            if (arr[mid] < offset) {
                left = mid
            } else {
                right = mid
            }
        }
        // 此时 left 和 right 相邻，比较两个位置哪个更接近
        const leftDiff = Math.abs(arr[left] - offset)
        const rightDiff = Math.abs(arr[right] - offset)
        return leftDiff <= rightDiff ? left : right
    }
    // 手指接触屏幕
    onTouchStart(){
        this.startOffset = this.transX
        this.touchStartTime = Date.now()
        this.momentumOffset = this.startOffset
    }
    // 手指移动
    onTouchMove(event: GestureEvent): void {
        let bl = event.offsetX
        let newOffset = this.startOffset + bl
        let list = this.scaleList
        if(bl > 0 && newOffset > list[0].localLeft){    // 右滑
            newOffset = list[0].localLeft
        }else if(bl < 0 && newOffset < - list[list.length-1].localLeft){// 左滑
            newOffset = - list[list.length-1].localLeft
        }
        const now = Date.now()
        if (now - this.touchStartTime > MOMENTUM_TIME) {
            this.touchStartTime = now
            this.momentumOffset = newOffset
        }
        this.transX = newOffset
        const index = this.getIndexByOffset(Math.abs(newOffset))
        const value = list[index].value
        if(value !== this.value){
            this.flag = true
            this.value = value
        }
    }
    // 手指离开
    onTouchEnd(): void {
        let offset = this.transX
        const list = this.scaleList
        const distance = offset - this.momentumOffset
        const duration = Date.now() - this.touchStartTime
        const startMomentum = duration < MOMENTUM_TIME && Math.abs(distance) > MOMENTUM_DISTANCE
        if (startMomentum) {	// 惯性滑动
            const speed = Math.abs(distance / duration)
            offset = offset + (speed / 0.3) * (distance < 0 ? -1 : 1)
        }
        const index = this.getIndexByOffset(Math.abs(offset))
        const value = list[index].value
        this.transX = -this.scaleList[index].localLeft
        if(this.value !== value){
            this.flag = true
            this.value = value
            setTimeout(() => {
                this.onChange(this.value)
            }, swipeDuration)
        }
    }

    build() {
        Scroll(){
            Row({space: getSizeByUnit(this.scaleSpace)}) {
                Row()
                    .width(getSizeByUnit(this.activeScaleWidth))
                    .height(1)
                    .position({left: 0, top: 0})
                    .opacity(0)
                    .zIndex(-1)
                    .id(`ibest_caliper_active_width_${this.uniId}`)
                ForEach(this.scaleList, (item: IBestCaliperScale) => {
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
                                .translate({x: "-50%", y: "100%"})
                        }
                    }
                    .id(`ibest_caliper_item_${this.uniId}_${item.value}`)
                })
            }
            .translate({ x: this.transX + this.contentWidth/2 })
            .alignItems(this.scaleAlign == 'top' ? VerticalAlign.Top : this.scaleAlign == 'bottom' ? VerticalAlign.Bottom : VerticalAlign.Center)
            .padding({bottom: this.getFontHeight() + 5})
            .animation({
                duration: this.isReady ? swipeDuration : 0,
                curve: Curve.Ease
            })
            .gesture(
                PanGesture({
                    fingers: 1,
                    direction: PanDirection.Horizontal,
                    distance: 1
                })
                    .onActionStart(() => {
                        this.onTouchStart()
                    })
                    .onActionUpdate((event: GestureEvent) => {
                        this.onTouchMove(event)
                    })
                    .onActionEnd(() => {
                        this.onTouchEnd()
                    })
            )
        }
        .width(CONTAINER_SIZE.FULL)
        .scrollable(ScrollDirection.None)
        .enableScrollInteraction(false)
        .clip(true)
        .backgroundColor(this.bgColor)
        .opacity(this.isReady ? 1 : 0)
        .onAreaChange((oldVal, newVal) => {
            this.contentWidth = newVal.width as number
        })
    }
}