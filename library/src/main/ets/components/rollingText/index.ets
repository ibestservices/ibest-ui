import { IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsWidthUnit, getSizeByUnit, padZero } from "../../utils/utils"
import { IBestRollingTextColor } from "./color"
import { IBestRollingTextController } from "./index.type"

@Component
export struct IBestRollingText{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 起始数值
     */
    @Prop startNum: number = 0
    /**
     * 目标数值
     */
    @Prop targetNum: number = 0
    /**
     * 动画时长，单位ms
     */
    @Provide({allowOverride: "duration"}) duration: number = 2000
    /**
     * 翻滚方向
     */
    @Provide({allowOverride: "rollingDirection"}) rollingDirection: 'up' | 'down' = 'down'
    /**
     * 是否自动开始翻滚
     */
    @Prop autoStart: boolean = true
    /**
     * 自动翻滚延迟时长，单位ms
     */
    @Prop delay: number = 500
    /**
     * 停止顺序
     */
    @Prop stopOrder: 'ltr' | 'rtl' = 'ltr'
    /**
     * 单个数位宽度
     */
    @Provide({allowOverride: "numWidth"}) numWidth: IBestStringNumber = convertDimensionsWidthUnit(15)
    /**
     * 单个数位高度
     */
    @Provide({allowOverride: "numHeight"}) numHeight: IBestStringNumber = convertDimensionsWidthUnit(40)
    /**
     * 数字间距
     */
    @Prop gap: IBestStringNumber = 0
    /**
     * 文字背景色
     */
    @Provide({allowOverride: "textBgColor"}) textBgColor: ResourceColor = ''
    /**
     * 文字颜色
     */
    @Provide({allowOverride: "fontColor"}) fontColor: ResourceColor = IBestRollingTextColor.textColor
    /**
     * 字体大小
     */
    @Provide({allowOverride: "fontSize"}) fontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 单个数位边框圆角
     */
    @Provide({allowOverride: "radius"}) radius: IBestStringNumber = 0
    /**
     * 控制器
     */
    controller: IBestRollingTextController = new IBestRollingTextController()

    @State textHeight: number = 0
    @State isStart: boolean = false
    private circleNum: number = 2

    aboutToAppear() {
        this.controller.start = (): void => this.start()
        this.controller.reset = (): void => this.reset()
    }
    init(){
        if(this.autoStart && !this.isStart){
            setTimeout(() => {
                this.start()
            }, this.delay)
        }
    }
    // 获取数字长度
    getLength(){
        return `${Math.max(this.startNum, this.targetNum!)}`.length
    }
    // 获取目标数字的数组
    getTargetNumArr(){
        return padZero(this.targetNum, this.getLength()).split('')
    }
    // 获取每项数字数组
    getItemArr(index: number)                                                                                                                    {
        const startNumArr = padZero(this.startNum, this.getLength()).split('')
        const targetNumArr = this.getTargetNumArr()
        const result: number[] = []
        for (let i = Number(startNumArr[index]); i <= 9; i++) {
            result.push(i)
        }
        for (let i = 0; i <= this.circleNum; i++) {
            for (let j = 0; j <= 9; j++) {
                result.push(j)
            }
        }
        for (let i = 0; i <= Number(targetNumArr[index]); i++) {
            result.push(i)
        }
        return this.rollingDirection == "down" ? result.reverse() : result
    }
    // 获取延迟
    getDelay(i: number){
        if (this.stopOrder === 'ltr') return 0.2 * i
        return 0.2 * (this.getLength() - 1 - i)
    }
    // 开始
    start(){
        this.isStart = true
    }
    // 重置
    reset(){
        this.isStart = false
        if(this.autoStart){
            setTimeout(() => {
                this.start()
            }, this.delay)
        }
    }
    build() {
        Row({space: getSizeByUnit(this.gap)}){
            ForEach(this.getTargetNumArr(), (_: string, index: number) => {
                IBestRollingTextItem({
                    itemArr: this.getItemArr(index),
                    delay: this.getDelay(index),
                    textHeight: this.textHeight,
                    isStart: this.isStart
                })
            })
        }
        .height(getSizeByUnit(this.numHeight))
        .onAreaChange((_, newVal) => {
            this.textHeight = newVal.height as number
            this.init()
        })
    }
}

@Component
struct IBestRollingTextItem{
    @Prop itemArr: number[]
    @Prop delay: number
    @Prop @Watch("textHeightChange") textHeight: number
    @Prop @Watch("start") isStart: boolean
    @Consume numWidth: IBestStringNumber
    @Consume numHeight: IBestStringNumber
    @Consume rollingDirection: 'up' | 'down'
    @Consume duration: number
    @Consume textBgColor: ResourceColor
    @Consume fontColor: ResourceColor
    @Consume fontSize: IBestStringNumber
    @Consume radius: IBestStringNumber
    @State transY: number = 0
    private uiContext = this.getUIContext()

    start(){
        if(this.isStart) {
            this.uiContext.animateTo({
                duration: this.duration,
                delay: this.delay * 1000,
                curve: Curve.EaseInOut
            }, () => {
                this.transY = this.rollingDirection == 'down' ? 0 : -this.getTranslateY()
            })
        }else if(this.rollingDirection == 'down'){
            this.transY = -this.getTranslateY()
        }else {
            this.transY = 0
        }
    }
    textHeightChange(){
        if(this.rollingDirection == 'down'){
            this.transY = -this.getTranslateY()
        }
    }
    // 获取总偏移量
    getTranslateY(){
        return this.textHeight * (this.itemArr.length - 1)
    }
    build() {
        Row(){
            Column(){
                ForEach(this.itemArr, (item: number) => {
                    Row(){
                        Text(item.toString())
                            .fontColor(this.fontColor)
                            .fontSize(getSizeByUnit(this.fontSize, true))
                    }
                    .width(CONTAINER_SIZE.FULL)
                    .height(getSizeByUnit(this.numHeight))
                    .justifyContent(FlexAlign.Center)
                })
            }
            .translate({y: this.transY})
        }
        .width(getSizeByUnit(this.numWidth))
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(this.textBgColor)
        .borderRadius(getSizeByUnit(this.radius))
        .clip(true)
    }
}