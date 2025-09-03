import { IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { clamp, convertDimensions, getSizeByUnit } from "../../utils/utils"
import { IBestSectorProgressColor } from "./color"
import { matrix4 } from "@kit.ArkUI"

@Component
export struct IBestSectorProgress {
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 进度值
     */
    @Link @Watch("valueChange") value: number
    /**
     * 进度条直径
     */
    @Prop diameter: number = convertDimensions(100)
    /**
     * 目标进度
     */
    @Prop target: number = 100
    /**
     * 中间文字
     */
    @Prop text: ResourceStr = ''
    /**
     * 文字颜色
     */
    @Prop textColor: ResourceColor = IBestSectorProgressColor.textColor
    /**
     * 文字大小
     */
    @Prop textFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 字重
     */
    @Prop textFontWeight: FontWeight = 600
    /**
     * 是否顺时针
     */
    @Prop clockwise: boolean = true
    /**
     * 起始位置
     */
    @Prop startPosition: "left" | "right" | "bottom" | "top" = "top"
    /**
     * 底层背景色
     */
    @Prop bgColor: ResourceColor = IBestSectorProgressColor.bgColor
    /**
     * 扇形背景颜色
     */
    @Prop @Watch("drawFan") sectorBgColor: string | number | CanvasGradient | CanvasPattern = "#1989fa"
    /**
     * 边框
     */
    @Prop outerBorder: BorderOptions
    /**
     * 是否需要过渡动画
     */
    @Prop enableAnimation: boolean = false
    /**
     * 到达目标值
     */
    onReachTarget: () => void = () => {}

    private settings: RenderingContextSettings = new RenderingContextSettings(true)
    private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
    private timer: number = -1
    private curAngle: number = 0

    valueChange(){
        this.prepareToDraw("change")
    }
    // 准备绘制
    prepareToDraw(type: string){
        this.value = clamp(this.value, 0, this.target)
        if(this.enableAnimation){
            this.startDrawAnimation()
        }else {
            this.curAngle = this.value * 360 / this.target
            this.drawFan()
        }
        if(this.value == this.target && type == 'change'){
            this.onReachTarget()
        }
    }
    // 绘制扇形
    drawFan() {
        const ctx = this.context
        const radius = this.diameter/2
        ctx.clearRect(0, 0, this.diameter, this.diameter)
        ctx.beginPath()
        ctx.moveTo(radius, radius)
        ctx.arc(radius, radius, radius, 0, Math.PI * 2 * (this.curAngle / 360))
        ctx.closePath()
        ctx.fillStyle = this.sectorBgColor
        ctx.fill()
    }
    // 开始绘制扇形
    startDrawAnimation() {
        if (this.timer !== -1) {
            clearTimeout(this.timer)
        }
        let targetAngle = this.value * 360 / this.target
        if(this.curAngle == targetAngle){
            return
        }
        const step = targetAngle > this.curAngle ? 5 : -5
        const animate = () => {
            if ((step > 0 && this.curAngle >= targetAngle) || (step < 0 && this.curAngle <= targetAngle)) {
                this.curAngle = targetAngle
            } else {
                this.timer = setTimeout(() => {
                    let angle = this.curAngle + step
                    this.curAngle = angle < 0 ? 0 : angle > 360 ? 360 : angle
                    this.drawFan()
                    animate()
                }, 1000 / 60)
            }
        }
        animate()
    }
    getPosition(){
        let matrix1 = matrix4.identity()
        let matrix2 = matrix4.identity()
        switch (this.startPosition){
            case "top":
                return this.clockwise ? matrix1.rotate({ z: 1, angle: -90 }) : matrix1.rotate({ z: 1, angle: -90 }).combine(matrix2.rotate({ y: 1, angle: 180 }))
            case "bottom":
                return this.clockwise ? matrix1.rotate({ z: 1, angle: 90 }) : matrix1.rotate({ z: 1, angle: 90 }).combine(matrix2.rotate({ y: 1, angle: 180 }))
            case "left":
                return this.clockwise ? matrix1.rotate({ z: 1, angle: 180 }) : matrix1.rotate({ z: 1, angle: 180 }).combine(matrix2.rotate({ x: 1, angle: 180 }))
            case "right":
                return this.clockwise ? matrix1 : matrix1.combine(matrix2.rotate({ x: 1, angle: 180 }))
        }
    }
    build() {
        Stack(){
            Canvas(this.context)
                .width(CONTAINER_SIZE.FULL)
                .height(CONTAINER_SIZE.FULL)
                .transform(this.getPosition())
                .border(this.outerBorder)
                .borderRadius(this.baseStyle.borderRadiusMax)
                .backgroundColor(this.bgColor)
                .onReady(() => {
                    this.prepareToDraw('init')
                })
            if(this.text){
                Text(this.text)
                    .width(CONTAINER_SIZE.FULL)
                    .textAlign(TextAlign.Center)
                    .fontSize(getSizeByUnit(this.textFontSize, true))
                    .fontColor(this.textColor)
                    .fontWeight(this.textFontWeight)
            }
        }
        .width(getSizeByUnit(this.diameter))
        .aspectRatio(1)
    }
}