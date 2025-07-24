import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensions, getSizeByUnit } from '../../utils/utils'
import { matrix4 } from '@kit.ArkUI'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestCircleProgressColor } from './color'
import { IBestStringNumber } from '../../model/Global.type'

class Point {
    x: number
    y: number

    constructor(x: number, y: number) {
        this.x = x
        this.y = y
    }
    plus(rhs: Point): Point {
        return new Point(this.x + rhs.x, this.y + rhs.y)
    }
    subtract(rhs: Point): Point {
        return new Point(this.x - rhs.x, this.y - rhs.y)
    }
    multiply(scale: number): Point {
        return new Point(this.x * scale, this.y * scale)
    }
    equals(rhs: Point): boolean {
        return this.x === rhs.x && this.y === rhs.y
    }
}

@AnimatableExtend(Circle) function animatableDashArray(point: Point) {
    .strokeDashArray([point.x, point.y])
}

@Component
export struct IBestCircleProgress{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
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
    @Prop textColor: ResourceColor = IBestCircleProgressColor.textColor
    /**
     * 文字大小
     */
    @Prop textFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 字重
     */
    @Prop textFontWeight: FontWeight = 600
    /**
     * 进度条颜色
     */
    @Prop color: ResourceColor = ""
    /**
     * 进度条背景颜色
     */
    @Prop bgColor: ResourceColor = IBestCircleProgressColor.bgColor
    /**
     * 进度条宽度
     */
    @Prop strokeWidth: number = 4
    /**
     * 动画时长
     */
    @Prop duration: number = 300
    /**
     * 边框端点绘制样式
     */
    @Prop strokeLineCap: LineCapStyle = LineCapStyle.Round
    /**
     * 是否顺时针
     */
    @Prop clockwise: boolean = true
    /**
     * 起始位置
     */
    @Prop startPosition: "left" | "right" | "bottom" | "top" = "top"
	/**
	 * 到达目标值
	 * @since 2.0.8
	 */
	onReachTarget: () => void = () => {}

    @State maxPerimeter: number = 0
    @State isShow: boolean = false
    @State strokeDashArray: Point = new Point(0,0)

    aboutToAppear() {
        this.maxPerimeter = Math.floor(Math.PI * this.diameter)
        this.isShow = this.value > 0
        this.valueChange()
    }
    valueChange(){
        if(this.value > 0){
            this.isShow = true
        }
        this.value = Math.min(this.target, Math.max(this.value, 0))
        this.strokeDashArray = new Point(this.value ? (this.maxPerimeter * this.value) / this.target : 0.01, this.maxPerimeter)
		if(this.value == this.target){
			this.onReachTarget()
		}
	}
    getSize(){
        return getSizeByUnit(this.diameter - this.strokeWidth)
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

    getColor(){
        return this.color || this.baseStyle.primary
    }

    build() {
        Row(){
            Circle({width: this.getSize(), height: this.getSize()})
                .fill("transparent")
                .strokeWidth(this.strokeWidth)
                .stroke(this.bgColor)
                .strokeLineCap(LineCapStyle.Round)
                .position({left: this.strokeWidth/2, top: this.strokeWidth/2})
            Circle({width: this.getSize(), height: this.getSize()})
                .fill("transparent")
                .strokeWidth(this.strokeWidth)
                .stroke(this.getColor())
                .strokeLineCap(LineCapStyle.Round)
                .position({left: this.strokeWidth/2, top: this.strokeWidth/2})
                .animatableDashArray(this.strokeDashArray)
                .animation({
                    duration: this.duration,
                    onFinish: () => {
                        this.isShow = this.value > 0
                    }
                })
                .transform(this.getPosition())
                .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)
            if(this.text){
                Text(this.text)
                    .width(CONTAINER_SIZE.FULL)
                    .textAlign(TextAlign.Center)
                    .fontSize(getSizeByUnit(this.textFontSize, true))
                    .fontColor(this.textColor)
                    .fontWeight(this.textFontWeight)
                    .padding({left: this.strokeWidth, right: this.strokeWidth})
                    .position({left:0, top: "50%"})
                    .translate({ y: "-50%" })
            }
        }
        .width(getSizeByUnit(this.diameter))
        .aspectRatio(1)
    }
}