import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensions, convertDimensionsWidthUnit, getComponentSnapshot, getSizeByUnit } from '../../utils/utils'
import { IBestButton } from '../button'
import { IBestSignatureColor } from './color'
import { IBestSignatureController } from './index.type'
class Position {
	isFirst: boolean
	isEnd: boolean
	x: number
	y: number
	constructor(isFirst: boolean, isEnd: boolean, x: number, y: number) {
		this.isFirst = isFirst
		this.isEnd = isEnd
		this.x = x
		this.y = y
	}
}
@Component
export struct IBestSignature{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("IBestColorMode") @Watch("setCanvasStyle") colorMode: ColorMode = ColorMode.LIGHT
	/**
	 * 宽度
	 */
	@Prop boardWidth: IBestStringNumber = CONTAINER_SIZE.FULL
	/**
	 * 高度
	 */
	@Prop boardHeight: IBestStringNumber = convertDimensionsWidthUnit(200)
	/**
	 * 导出图片类型
	 */
	@Prop exportImgType: 'png' | 'jpeg' | 'webp' = 'png'
	/**
	 * 笔触颜色
	 */
	@Prop penColor: IBestStringNumber | CanvasGradient | CanvasPattern = '#000'
	/**
	 * 线条宽度
	 */
	@Prop lineWidth: number = 3
	/**
	 * 背景色
	 */
	@Prop bgColor: ResourceColor = IBestSignatureColor.bg
	/**
	 * 清除按钮文案
	 */
	@Prop clearText: ResourceStr = $r("app.string.ibest_text_clear")
	/**
	 * 确认按钮文案
	 */
	@Prop confirmText: ResourceStr = $r("app.string.ibest_text_confirm")
	/**
	 * 是否显示底部按钮
	 */
	@Prop isShowFooter: boolean = true
	/**
	 * 绘制完毕的回调
	 */
	onDrawEnd: () => void = () => {}
	/**
	 * 点击确定按钮的回调
	 */
	onConfirm: (pixelMap: PixelMap) => void = () => {}
	/**
	 * 点击清空按钮的回调
	 */
	onClear: () => void = () => {}
	/**
	 * 是否开启报点预测
	 */
	@Prop predictionAssist: boolean = false
	/**
	 * 控制器
	 */
	controller?: IBestSignatureController
	@State uniId: number = 0
	private uiContext = this.getUIContext()
	private settings: RenderingContextSettings = new RenderingContextSettings(true)
	private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
	private data: Position[] = []

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.init()
	}
	// 初始化
	init(){
		if(this.controller){
			this.controller.confirm = (): void => this.confirm()
			this.controller.clear = (): void => this.clearCanvas()
		}
	}
	// 设置canvas 初始样式
	setCanvasStyle(){
		this.context.lineCap = "round"
		this.context.lineJoin = "round"
		this.context.lineWidth = this.lineWidth
		this.context.strokeStyle = this.penColor
	}
	// 触摸事件
	onFingerTouch(event: TouchEvent){
		let touch = event.touches[0]
		event.stopPropagation()
		switch (event.type){
			case TouchType.Down:
				this.data.push(new Position(true, false, touch.x, touch.y))
        		this.draw()
				break
			case TouchType.Move:
				this.data.push(new Position(false, false, touch.x, touch.y))
        		this.draw()
				break
			case TouchType.Up:
				this.data.push(new Position(false, true, touch.x, touch.y))
        		this.draw()
				this.onDrawEnd()
				break
		}
	}
	// 清除画布
	clearCanvas(){
		this.context.clearRect(0, 0, this.context.width, this.context.height)
		this.data = []
		this.setCanvasStyle()
		this.onClear()
	}
	// 确认
	confirm(){
		this.onConfirm(getComponentSnapshot(this.uiContext, `ibest_signature_${this.uniId}`))
	}
	// 生成预测点位
	generatePredictedPoints(p1: Position, p2: Position, numPoints: number = 3): Position[] {
		const dx = p2.x - p1.x
		const dy = p2.y - p1.y
		const angle = Math.atan2(dy, dx)
		const distance = Math.sqrt(dx * dx + dy * dy)
		const step = distance / (numPoints + 1)
		const predictedPoints: Position[] = []
		for (let i = 1; i <= numPoints; i++) {
			const newX = p1.x + i * step * Math.cos(angle)
			const newY = p1.y + i * step * Math.sin(angle)
			predictedPoints.push(new Position(false, false, newX, newY))
		}
		return predictedPoints
	}
	draw() {
		if (this.data.length > 3) {
			let ex = this.data[this.data.length - 1]
			if (ex.isFirst) {
				this.context.beginPath()
				this.context.moveTo(ex.x, ex.y)
			} else {
				if (this.predictionAssist) {
					const predictedPoints = this.generatePredictedPoints(
						this.data[this.data.length - 2],
						this.data[this.data.length - 1]
					)
					this.data.splice(this.data.length - 1, 0, ...predictedPoints)
				}
				let x = (this.data[this.data.length - 2].x + this.data[this.data.length - 1].x) / 2
				let y = (this.data[this.data.length - 2].y + this.data[this.data.length - 1].y) / 2
				this.context.quadraticCurveTo(this.data[this.data.length - 2].x, this.data[this.data.length - 2].y, x, y)
				this.context.stroke()
			}
		} else {
			this.data.forEach((res) => {
				if (res.isFirst) {
					this.context.beginPath()
					this.context.moveTo(res.x, res.y)
				} else {
					this.context.lineTo(res.x, res.y)
					if (res.isEnd) {
						this.context.stroke()
					}
				}
			})
		}
	}
	build() {
		Column() {
			Row(){
				Canvas(this.context)
					.width(CONTAINER_SIZE.FULL)
					.height(getSizeByUnit(this.boardHeight))
					.monopolizeEvents(true)
					.onReady(() => {
						this.setCanvasStyle()
					})
					.onTouch((event: TouchEvent) => {
						this.onFingerTouch(event)
					})
			}
			.border({width: 1, color: IBestSignatureColor.borderColor, style: BorderStyle.Dashed})
			.borderRadius(this.baseStyle.borderRadiusLg)
			.backgroundColor(this.bgColor)
			.clip(true)
			.id(`ibest_signature_${this.uniId}`)
			if(this.isShowFooter){
				Row({ space: this.baseStyle.spaceXs as string }){
					IBestButton({
						text: this.clearText,
						btnWidth: convertDimensions(60),
						btnHeight: convertDimensions(32),
						btnFontSize: convertDimensions(12),
						onClickBtn: () => {
							this.clearCanvas()
						}
					})
					IBestButton({
						type: 'primary',
						text: this.confirmText,
						btnWidth: convertDimensions(60),
						btnHeight: convertDimensions(32),
						btnFontSize: convertDimensions(12),
						onClickBtn: () => {
							this.confirm()
						}
					})
				}
				.width(CONTAINER_SIZE.FULL)
				.margin({ top: this.baseStyle.spaceXs })
				.justifyContent(FlexAlign.End)
			}
		}
		.width(getSizeByUnit(this.boardWidth))
	}
}