import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsByUnit, getSizeByUnit } from "../../utils/utils"
import { IBestButton } from "../button"
import { IBestSignatureController } from "./index.type"
@Component
export struct IBestSignature{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 宽度
	 */
	@Prop boardWidth: number | string = CONTAINER_SIZE.FULL
	/**
	 * 高度
	 */
	@Prop boardHeight: number | string = convertDimensionsByUnit(200)
	/**
	 * 导出图片类型
	 */
	@Prop exportImgType: 'png' | 'jpeg' | 'webp' = 'png'
	/**
	 * 笔触颜色
	 */
	@Prop penColor: string | number | CanvasGradient | CanvasPattern = '#000'
	/**
	 * 线条宽度
	 */
	@Prop lineWidth: number = 3
	/**
	 * 背景色
	 */
	@Prop bgColor: string | number | CanvasGradient | CanvasPattern = '#fff'
	/**
	 * 清除按钮文案
	 */
	@Prop clearText: string = '清空'
	/**
	 * 确认按钮文案
	 */
	@Prop confirmText: string = '确认'
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
	onConfirm: (url: string) => void = () => {}
	/**
	 * 点击清空按钮的回调
	 */
	onClear: () => void = () => {}
	/**
	 * 控制器
	 */
	controller?: IBestSignatureController
	private settings: RenderingContextSettings = new RenderingContextSettings(true)
	private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

	aboutToAppear(): void {
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
		this.context.fillStyle = this.bgColor
		this.context.fillRect(0, 0, this.context.width, this.context.height)
	}
	// 触摸事件
	onFingerTouch(event: TouchEvent){
		let touch = event.touches[0]
		event.stopPropagation()
		switch (event.type){
			case TouchType.Down:
				this.context.beginPath()
				this.context.moveTo(touch.x, touch.y)
				break
			case TouchType.Move:
				this.context.lineTo(touch.x, touch.y)
				this.context.stroke()
				break
			case TouchType.Up:
				this.onDrawEnd()
				break
		}
	}
	// 清除画布
	clearCanvas(){
		this.context.clearRect(0, 0, this.context.width, this.context.height)
		this.setCanvasStyle()
		this.onClear()
	}
	// 确认
	confirm(){
		this.onConfirm(this.context.toDataURL(`image/${this.exportImgType}`))
	}

	build() {
		Column() {
			Canvas(this.context)
				.width(CONTAINER_SIZE.FULL)
				.height(getSizeByUnit(this.boardHeight))
				.borderRadius(this.baseStyle.borderRadiusLg)
				.monopolizeEvents(true)
				.onReady(() => {
					this.setCanvasStyle()
				})
				.onTouch((event: TouchEvent) => {
					this.onFingerTouch(event)
				})
			if(this.isShowFooter){
				Row({ space: this.baseStyle.spaceXs }){
					IBestButton({
						text: this.clearText,
						btnWidth: 60,
						btnHeight: 32,
						btnFontSize: 12,
						onClickBtn: () => {
							this.clearCanvas()
						}
					})
					IBestButton({
						type: 'primary',
						text: this.confirmText,
						btnWidth: 60,
						btnHeight: 32,
						btnFontSize: 12,
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